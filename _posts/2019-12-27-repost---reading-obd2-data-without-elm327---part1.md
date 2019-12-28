---
layout: post
title: "Repost - Reading OBD2 data without ELM327 - Part1"
date: 2019-12-27
tags: [repost, OBD2, Kinetis, CAN Bus]
---

Repost from https://m0agx.eu/2017/12/27/reading-obd2-data-without-elm327-part-1-can/

# Index

* TOC
{:toc}

# Content

## Reading OBD2 data without ELM327, part 1 – CAN

**Originally Posted on 2017-12-27 at https://m0agx.eu/2017/12/27/reading-obd2-data-without-elm327-part-1-can/**

All modern cars have an OBD2 diagnostic connector that allows reading many engine and drivetrain parameters like RPM, vehicle speed, temperatures etc.

Most of car interfaces use a special protocol translating chip like ELM327 or STN1110 to convert different vehicle protocols (that depend on the age and brand of the car) into an easier to use serial protocol with AT-commands.

I wanted to build a datalogger that would fit into a OBD2 connector. There was no space to fit my microcontroller and another chip to do protocol conversion, so I investigated and reverse-engineered the most common OBD2 protocols to be able to implement them directly on my MCU.

This is the first post in series about OBD2. Second one is here.

## Basics

Because the OBD2 standards are not freely available I decided to buy an OBD2 emulator from Freematics, connect it to a chinese OBD2 USB cable and sniff the traffic with a protocol analyzer. Later I have found out that the emulator prints out all traffic to the terminal, so the analyzer was not necessary.

There are several physical layer (think “the wires”) standards (CAN, K-Line, VPV, PWM) and several protocols that run over those wires. This post is about one of them – the CAN bus used for OBD2 (formally standarized as ISO 15765-4).

## CAN bus

CAN bus standard allows many devices to send and receive messages over a single (twisted) pair of wires. Each message has a message identifier (11 or 29 bit long), length field and up to 8 payload bytes (+some other flags that are not needed for OBD2). There is no notion of sender or receiver. The message ID is used to distinguish the source (or destination).

Devices connected to a CAN bus must have a CAN transceiver (can be thought of similar to an RS-485 driver) and a CAN controller. The transceiver is always a separate chip. The controller may be integrated into a microcontroller or be a separate chip.

## OBD2 modes and PIDs

OBD2 defines several modes (which can for example deliver live data, freeze frame data, diagnostic trouble codes etc.). Each of the modes support many PIDs (Parameter IDs). For example mode 01 PID 0x0C is current engine RPM. A PID can have up to 4 bytes and requires a formula to convert those bytes to a meaningful reading. Wikipedia has an excellent list of PIDs. Not all PIDs are available on every car.

## OBD2 and CAN

The CAN-flavor of OBD2 comes in 4 variants:

500kbps with standard (11 bit) identifiers
250kbps with standard (11 bit) identifiers
500kbps with extended (29 bit) identifiers
250kbps with extended (29 bit) identifiers
It is hard to predict which one is used by the car. I have chosen to simply request mode 01 PID 0x00 (that is always available) using different variants.

## Requesting a PID

The message is always 8 bytes long, even if less information is required. The first byte specifies the length within payload (in this case the first byte is 2 because only the mode and PID bytes are used).

PID message request (bytes):
0x02 <mode> <pid> 0x00 0x00 0x00 0x00 0x00

For example to request mode 0x01 PID 0x0C (RPM) simply send:
0x02 0x01 0x0C 0x00 0x00 0x00 0x00 0x00

Message ID must be 0x7DF for standard (11 bit) addressing and 0x18DB33F1 for extended (29 bit) addressing. Each message will be acknowledged by the car.

## PID response

The response will carry a message ID of 0x7E8 (standard addressing) or 0x18DAF111 (extended), so the CAN controller receive filter must pass those message IDs. Example:
0x04 0x41 0x0C 0x31 0x64 0x00 0x00 0x00

First byte is the length of the payload field (in this case 4 bytes are valid), second byte – it is a response to mode 0x01 PID, third byte is the PID (0x0C), bytes 0x31 and 0x64 are byes A and B of the PID.

To get RPM you have to use a formula from table of PIDs. In this case the engine speed is (256 * 0x31 + 0x64)/4 = 3161 rpm.

## Summary

Everything you need to get live OBD2 data from your car is to send a simple CAN frame and wait for the response. You don’t need a protocol translator like ELM327 or STN1110 (though they will support more protocols and vehicle types, including all communication quirks found through the years).

I have described only getting data for mode 01 (mode 02 is identical). Other modes may require different data formats. For example getting the VIN number (due to its length) is more complicated, because it has to be split between many CAN frames.

## Example driver code

This is a piece of code from my upcoming OBD2 datalogger project. It runs on a Kinetis MKE06Z128 and uses the built-in CAN controller. The driver requires FreeRTOS and some other files, but still it provides an easy reference on implementing OBD2 communications with MSCAN peripheral.

```c
#include <FreeRTOS/include/FreeRTOS.h>
#include <FreeRTOS/include/task.h>
#include "misc.h"
#include <MKE06Z4.h>
#include "obd_can.h"
#include <string.h>

#define DEBUG_ID DEBUG_ID_OBD_CAN
#include <debug.h>

#if DEFAULT_BUS_CLOCK == 20000000
//Values were calculated using the spreadsheet in dev_documentation directory
#define CANBTR0_500KBAUD 0xC3
#define CANBTR1_500KBAUD 0x34
#define CANBTR0_250KBAUD 0xC7
#define CANBTR1_250KBAUD 0x34
#else
#error "CAN baud registers not defined for this bus clock!"
#endif

#define CAN_PID_RESPONSE_TIMEOUT_ms 50
//ISO 15765-4 identifiers, reverse engineered from ELM327 communication ;)
#define CAN_OBD2_STD_ID_ECU_REQ_ID 0x7DF
#define CAN_OBD2_STD_ID_ECU_RESPONSE_ID 0x7E8
#define CAN_OBD2_STD_ID_ECU_RESPONSE_FILTER_MASK 0x7FF //simply all 11 bits must match
#define CAN_OBD2_EXT_ID_ECU_REQ_ID 0x18DB33F1
#define CAN_OBD2_EXT_ID_ECU_RESPONSE_ID 0x18DAF111
#define CAN_OBD2_EXT_ID_ECU_RESPONSE_FILTER_MASK 0x1FEFFFFF //simply all 29 bits must match *except* the RSRR

typedef struct {
	uint32_t identifier;
	bool identifier_is_extended;
	uint8_t length;
	uint8_t payload[8];
	uint8_t padding1[2];
} can_rx_frame_t;

static TaskHandle_t _local_task_handle = NULL;
static volatile can_rx_frame_t _rx_frame;
static bool _use_extended_id;
static uint32_t _obd_id_request;
static uint32_t _obd_id_response;

static void obd_can_transmit(uint32_t identifier, bool identifier_is_extended,
		const uint8_t *payload, uint8_t payload_length);
static void obd_can_tx_abort(void);

void obd_can_init(can_speed_t speed, bool use_extended_id){
	_local_task_handle = xTaskGetCurrentTaskHandle();

	portENTER_CRITICAL();
	SIM->SCGC |= SIM_SCGC_MSCAN_MASK;

	SIM->PINSEL1 |= SIM_PINSEL1_MSCANPS_MASK; //CAN_TX PTE7, CAN_RX PTH2

	portEXIT_CRITICAL();

	MSCAN->CANCTL0 |= MSCAN_CANCTL0_INITRQ_MASK; //enter controller initialization mode
	while (!(MSCAN->CANCTL1 & MSCAN_CANCTL1_INITAK_MASK)) {
		//wait for the controller to enter initialization mode
		vTaskDelay(2);
	}

	MSCAN->CANCTL1 = MSCAN_CANCTL1_CLKSRC_MASK /*use bus clock*/
			| MSCAN_CANCTL1_CANE_MASK; //enable CAN module*/

	//	MSCAN->CANCTL1 |= MSCAN_CANCTL1_LOOPB_MASK; //enable loopback for testing

	//set baud
	if (speed == can_speed_500kbaud){
		MSCAN->CANBTR0 = CANBTR0_500KBAUD;
		MSCAN->CANBTR1 = CANBTR1_500KBAUD;
		debugf("500k baud init");
	} else {
		MSCAN->CANBTR0 = CANBTR0_250KBAUD;
		MSCAN->CANBTR1 = CANBTR1_250KBAUD;
		debugf("250k baud init");
	}

	_use_extended_id = use_extended_id;
	if (_use_extended_id){
		debugf("Using extended 29-bit IDs");
		_obd_id_request = CAN_OBD2_EXT_ID_ECU_REQ_ID;
		_obd_id_response = CAN_OBD2_EXT_ID_ECU_RESPONSE_ID;
	} else {
		debugf("Using standard 11-bit IDs");
		_obd_id_request = CAN_OBD2_STD_ID_ECU_REQ_ID;
		_obd_id_response = CAN_OBD2_STD_ID_ECU_RESPONSE_ID;
	}

	MSCAN->CANRIER = MSCAN_CANRIER_RXFIE_MASK; //enable RX interrupt

	//RX filter - standard ID
	MSCAN->CANIDAR_BANK_1[0] = (uint8_t) (CAN_OBD2_STD_ID_ECU_RESPONSE_ID >> 3); //this register holds bits 10-3 of the ID
	MSCAN->CANIDAR_BANK_1[1] = (CAN_OBD2_STD_ID_ECU_RESPONSE_ID & 0x7) << MSCAN_TSIDR1_TSID2_TSID0_SHIFT;
	//MSCAN->CANIDAR_BANK_1[2] and [3] - don't care
	MSCAN->CANIDMR_BANK_1[0] = (uint8_t) ~((CAN_OBD2_STD_ID_ECU_RESPONSE_FILTER_MASK >> 3));
	MSCAN->CANIDMR_BANK_1[1] = (uint8_t) ~((CAN_OBD2_STD_ID_ECU_RESPONSE_FILTER_MASK & 0x7) << MSCAN_TSIDR1_TSID2_TSID0_SHIFT);
	MSCAN->CANIDMR_BANK_1[2] = 0xFF;
	MSCAN->CANIDMR_BANK_1[3] = 0xFF;

	debugf("%02X%02X %02X%02X%02X%02X",
			MSCAN->CANIDAR_BANK_1[0],
			MSCAN->CANIDAR_BANK_1[1],
			MSCAN->CANIDMR_BANK_1[0],
			MSCAN->CANIDMR_BANK_1[1],
			MSCAN->CANIDMR_BANK_1[2],
			MSCAN->CANIDMR_BANK_1[3]
	);

	MSCAN->CANIDAR_BANK_2[0] = CAN_OBD2_EXT_ID_ECU_RESPONSE_ID >> 21;
	MSCAN->CANIDAR_BANK_2[1] = ((CAN_OBD2_EXT_ID_ECU_RESPONSE_ID >> (20/*source bit position*/- 7/*destination bit position*/))
			& MSCAN_TEIDR1_TEID20_TEID18_MASK)
			| ((CAN_OBD2_EXT_ID_ECU_RESPONSE_ID >> (17 - 2)) & MSCAN_TEIDR1_TEID17_TEID15_MASK)
			| MSCAN_TEIDR1_TEIDE_MASK;
	MSCAN->CANIDAR_BANK_2[2] = (uint8_t) (CAN_OBD2_EXT_ID_ECU_RESPONSE_ID >> 7);
	MSCAN->CANIDAR_BANK_2[3] = (uint8_t) (CAN_OBD2_EXT_ID_ECU_RESPONSE_ID << 1);

	MSCAN->CANIDMR_BANK_2[0] = (uint8_t) ~(CAN_OBD2_EXT_ID_ECU_RESPONSE_FILTER_MASK >> 24);
	MSCAN->CANIDMR_BANK_2[1] = (uint8_t) ~(CAN_OBD2_EXT_ID_ECU_RESPONSE_FILTER_MASK >> 16);
	MSCAN->CANIDMR_BANK_2[2] = (uint8_t) ~(CAN_OBD2_EXT_ID_ECU_RESPONSE_FILTER_MASK >> 8);
	MSCAN->CANIDMR_BANK_2[3] = (uint8_t) ~(CAN_OBD2_EXT_ID_ECU_RESPONSE_FILTER_MASK);

	debugf("%02X%02X%02X%02X %02X%02X%02X%02X",
			MSCAN->CANIDAR_BANK_2[0],
			MSCAN->CANIDAR_BANK_2[1],
			MSCAN->CANIDAR_BANK_2[2],
			MSCAN->CANIDAR_BANK_2[3],
			MSCAN->CANIDMR_BANK_2[0],
			MSCAN->CANIDMR_BANK_2[1],
			MSCAN->CANIDMR_BANK_2[2],
			MSCAN->CANIDMR_BANK_2[3]
	);

	MSCAN->CANIDAC = MSCAN_CANIDAC_IDAM(0); //use two 32-bit acceptance filters

	NVIC_SetPriority(MSCAN_RX_IRQn, 5);
	NVIC_EnableIRQ(MSCAN_RX_IRQn);

	MSCAN->CANCTL0 &= ~MSCAN_CANCTL0_INITRQ_MASK; //exit initialization mode

	while (MSCAN->CANCTL1 & MSCAN_CANCTL1_INITAK_MASK) {
		//wait for the controller to exit initialization mode
		vTaskDelay(2);
	}

	MSCAN->CANRIER = MSCAN_CANRIER_RXFIE_MASK; //enable RX interrupt

	debugf("OBD CAN initialized");
}

void obd_can_deinit(void){
	NVIC_DisableIRQ(MSCAN_RX_IRQn);

	MSCAN->CANCTL0 |= MSCAN_CANCTL0_INITRQ_MASK; //enter controller initialization mode

	while (!(MSCAN->CANCTL1 & MSCAN_CANCTL1_INITAK_MASK)) {
			//wait for the controller to enter initialization mode
	}

	MSCAN->CANCTL1 = 0; //disable CAN module

	SIM->SCGC &= ~SIM_SCGC_MSCAN_MASK; //disable clock to module
}

void obd_can_task(void){
	//no need for keepalive messages
}

static void obd_can_tx_abort(void) {
	uint8_t busy_buffers = (~MSCAN->CANTFLG) & MSCAN_CANTFLG_TXE_MASK; //zero means a busy buffer
	MSCAN->CANTARQ = busy_buffers;          //writing one triggers abort request
	while (MSCAN->CANTAAK != busy_buffers) {
		vTaskDelay(2); //wait for abort ack
	}
}

static void obd_can_transmit(uint32_t identifier, bool identifier_is_extended,
		const uint8_t *payload, uint8_t payload_length) {

	uint8_t empty_buffer_mask = MSCAN->CANTFLG & MSCAN_CANTFLG_TXE_MASK;
	if (!empty_buffer_mask) { //this should never happen as only one buffer is used in a lockstep
		debugf("TX busy, dropping frame"); //and after a timeout all transmissions are aborted
		return;
	}

	//select transmit buffer
	MSCAN->CANTBSEL = MSCAN_CANTBSEL_TX(empty_buffer_mask);
	debugf("Buffers available %02X selected %02X, payload length %d", empty_buffer_mask, MSCAN->CANTBSEL, payload_length);

	MSCAN->TBPR = 0; //priority of this buffer

	if (identifier_is_extended) {
		MSCAN->TEIDR0 = identifier >> 21;
		MSCAN->TEIDR1 = ((identifier >> (20/*source bit position*/- 7/*destination bit position*/))
				& MSCAN_TEIDR1_TEID20_TEID18_MASK)
								| ((identifier >> (17 - 2)) & MSCAN_TEIDR1_TEID17_TEID15_MASK)
								| MSCAN_TEIDR1_TEIDE_MASK;
		MSCAN->TEIDR2 = identifier >> 7;
		MSCAN->TEIDR3 = identifier << 1;
	} else {
		MSCAN->TSIDR0 = (uint8_t) (identifier >> 3); //this register holds bits 10-3 of the ID
		MSCAN->TSIDR1 = (identifier & 0x7) << MSCAN_TSIDR1_TSID2_TSID0_SHIFT;
	}

	for (uint8_t i = 0; i < 8; i++){
		MSCAN->TEDSR[i] = payload[i];
	}
	MSCAN->TDLR = payload_length;

	//enable transmission of this buffer
	uint8_t transmit_flag = MSCAN->CANTBSEL & MSCAN_CANTBSEL_TX_MASK;
	debugf("transmit flag = %02X", transmit_flag);

	MSCAN->CANTFLG = transmit_flag;
}

int32_t obd_can_get_pid(pid_mode_t mode, uint8_t pid, obd_pid_response_t *target_response) {
	uint8_t data[8];
	data[0] = 2; //"real" length of the payload, CAN frame has to be 8 bytes long
	data[1] = mode;
	data[2] = pid;
	data[3] = 0x0;
	data[4] = 0x0;
	data[5] = 0x0;
	data[6] = 0x0;
	data[7] = 0x0;

	obd_can_transmit(_obd_id_request, _use_extended_id, data, sizeof(data));
	//data is transmitted - now wait for other the response or timeout
	uint32_t status = ulTaskNotifyTake(
			pdTRUE/*clear notification value when ready*/,
			pdMS_TO_TICKS(CAN_PID_RESPONSE_TIMEOUT_ms));
	if (status) {
		debugf("rx frame id=%X id_ext=%d length=%d", (unsigned int)_rx_frame.identifier,
				_rx_frame.identifier_is_extended, _rx_frame.length);

		for (uint32_t i = 0; i < _rx_frame.length; i++) {
			debugf("rx payload[%ld]=%02X", i, _rx_frame.payload[i]);
		}

		//not all PIDs return 4 bytes but higher layer will handle it
		target_response->byte_a = _rx_frame.payload[3];
		target_response->byte_b = _rx_frame.payload[4];
		target_response->byte_c = _rx_frame.payload[5];
		target_response->byte_d = _rx_frame.payload[6];

		return _rx_frame.payload[0] - 2; //length of the particular PID response (minus PID and mode bytes)
	} else { //timeout
		debugf("timeout");
		obd_can_tx_abort();
		return OBD_PID_ERR;
	}
}

extern void MSCAN_RX_IRQHandler(void);
void MSCAN_RX_IRQHandler(void) {
	if (MSCAN->REIDR1 & MSCAN_REIDR1_REIDE_MASK) { //frame has extended identifier
		_rx_frame.identifier_is_extended = true;
		//getting the ID back together is a nightmare, see MSCAN reference manual...
		_rx_frame.identifier = MSCAN->REIDR0 << 21;
		_rx_frame.identifier |=
				(MSCAN->REIDR1 & MSCAN_REIDR1_REID20_REID18_MASK) << (18 - 5);
		_rx_frame.identifier |=
				(MSCAN->REIDR1 & MSCAN_REIDR1_REID17_REID15_MASK) << 15;
		_rx_frame.identifier |= MSCAN->REIDR2 << 7;
		_rx_frame.identifier |= (MSCAN->REIDR3 & MSCAN_REIDR3_REID6_REID0_MASK) >> 1;
	} else {
		_rx_frame.identifier_is_extended = false;
		_rx_frame.identifier = ((MSCAN->RSIDR1 & MSCAN_RSIDR1_RSID2_RSID0_MASK)
				>> MSCAN_RSIDR1_RSID2_RSID0_SHIFT) | (MSCAN->RSIDR0 << 3);
	}

	if (unlikely(_rx_frame.identifier != _obd_id_response)){
		MSCAN->CANRFLG = MSCAN_CANRFLG_RXF_MASK; //clear RX interrupt flag
		return; //drop frames that are not OBD2 replies
	}

	_rx_frame.length = MSCAN->RDLR & MSCAN_RDLR_RDLC_MASK;

	for (uint32_t i = 0; i < _rx_frame.length; i++) {
		_rx_frame.payload[i] = MSCAN->REDSR[i];
	}

	MSCAN->CANRFLG = MSCAN_CANRFLG_RXF_MASK; //clear RX interrupt flag

	BaseType_t xHigherPriorityTaskWoken = pdFALSE;
	xTaskNotifyFromISR(_local_task_handle, pdTRUE, eSetValueWithOverwrite,
			&xHigherPriorityTaskWoken);
	portYIELD_FROM_ISR(xHigherPriorityTaskWoken);
}
```