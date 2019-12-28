---
layout: post
title: "repost - Reading OBD2 data without ELM327 - Part2"
date: 2019-12-28
tags: [Repost, OBD2, Kinetis]
---

Repost from https://m0agx.eu/2018/01/02/reading-obd2-data-without-elm327-part-2-k-line/

# Index

* TOC
{:toc}

# Content

## Reading OBD2 data without ELM327, part 2 – K-Line

**Originally Posted on 2018-01-02 at https://m0agx.eu/2018/01/02/reading-obd2-data-without-elm327-part-2-k-line/**
K-Line is another popular OBD2 interfacing standard, that has been used in European cars before CAN bus became common. There are a couple of physical variations (K-line, K+L, KKL) and slightly different protocols (KWP2000 or Keyword Protocol, and ISO 9141) running on those lines. Basically all you need to talk to an older car is an MCU with a UART and a single transistor. 🙂

This is a second post in series about OBD2. First one is here.

## Physical layer
K-line is just a fancy name for a single-wire half-duplex UART running at 10400 baud and using 0/12V voltage levels. The “high” voltage level is actually the battery voltage (so it varies between 12V and 14,4V if the engine is running). Regular UARTs use 0/3,3V levels or 0/5V, while RS-232 uses +12/-12V.

The physical interface is quite simple – basically you have to interface MCU’s RX and TX lines to the 12V line. This is a reference schematic taken straight from ELM327 datasheet:
Kline Wiring ![Kline Wiring][1]

Reception from the K-Line is done with a simple voltage divider. The values may have to be slightly changed if the MCU uses 3,3V. Assuming that the K-Line voltage can vary between 12V and 14,4V the output of the divider should not exceed MCU supply voltage.

Transmission is also simple – just an NPN transistor in the open collector configuration with pullup resistor. The only catch here is that UART idle voltage is logically high, that would lead to logical low voltage on the K-Line because of the transistor. The solution is to enable TX inversion in UART peripheral. Not all MCUs support that. For example Kinetis E and XMEGA can invert the TX pin, while older AVRs (like ATmega328p) can not. Of course you could use a PNP transistor or another way to externally invert the TX logic level.

The L-Line is transmit only from the MCU side. It is used to transmit a 5-baud wakeup sequence (alongside K-line) in one of the older protocols. Only older cars have the L-line present.

## Protocols

I gathered the data by capturing signals with a logic analyzer between a no-name ELM327 USB cable and Freematics OBD emulator. All communication takes place at 10400 baud (8N1), except the initial pulses or slow initialization. Every protocol data frame ends with a checksum. The checksum is a simple 8-bit sum of all bytes, initial value is 0. It is transmitted as the last byte.

## KWP2000 – fast initialization

Fast initialization begins with a 25ms low and 25ms high state of the K-Line (and maybe doing the same with the L-Line, I did not dig into the official specs, it certainly does not hurt 🙂 ). Then a frame of 0xC1 0x33 0xF1 0x81 0x66 is transmitted by the UART to the car. The car responds with 0x83 0xF1 0x11 0xC1 0x8F 0xEF 0xC4 (sum of all received bytes except the last should be 0xC4). If the car responds with a valid frame (ie. valid CRC) it can be assumed that initialization succeeded (the response may depend on the car/year, but as far as basic OBD2 is concerned – anything valid means a good initialization).

If the procedure fails (the car does not respond with a valid frame), then the slow initialization procedure should be attempted after at least ~2,5 seconds!

## Slow initialization

For slow initialization it is best to switch the TX line to GPIO, because the UART may not be able to work at 5 baud, so software-controlled delays are more appropriate. The sequence starts with a 200ms low, 400ms high/low/high/low, 227ms high. This may also be done with the L-Line (at the same time).

The car will respond with 3 bytes, for example: 0x55 0xEF 0x8F. Depending on the values the protocol will be either KWP2000 or ISO-9141. First byte is always 0x55. The other bytes are respectively called KB1 and KB2.

If KB1 and KB2 are both 0x08 0x08 or 0x94 0x94, then the protocol to be used is ISO-9141, otherwise it is KWP2000.

After receiving the first frame from the car, an inverted KB2 has to be sent to the car. In this example (inverted 0x8F) it is 0x70. The car will then respond (single byte) with its inverted ECU address that will be used for all future requests.

## Requesting a PID – KWP2000

The request frame is: 0xC2 <ECU_ADDRESS> 0xF1 <MODE> <PID> <CHECKSUM>.

Some examples (PID values in bold, ELM request 010C means sending exactly those characters + newline via serial terminal to an OBD2 USB cable):

ELM request 010C (mode 01, PID 0x0C – RPM)
request: C2 33 F1 01 0C F3 (0x33 is the ECU address, 0x01 mode, 0x0C PID, 0xF3 checksum)
response: 84 F1 11 41 0C 1F 40 32 (1F40 = 2000rpm, see formula)
response: 84 F1 11 41 0C 1F 44 36 (1F44 = 2001rpm, see formula)
ELM request 010D (mode 01, PID 0x0D – speed km/h)
request: C2 33 F1 01 0D F4
response: 83 F1 11 41 0D 64 37 (0x64 = 100km/h)
response: 83 F1 11 41 0D 38 0B (0x38 = 56km/h)
ELM request 0100 (mode 01, PID 0x00 – available mode 01 PIDs)
request: C2 33 F1 01 00 E7
response: 86 F1 11 41 00 FF FF FF FF C5 (0xFFFFFFFF = all pids)
ELM request 0902 (mode 09, PID 0x02 – get VIN, this request is special as response comes in several frames, the result is ASCII, left padded with zeros)
request: C2 33 F1 09 02 F1
response:
87 F1 11 49 02 01 00 00 00 31 06
87 F1 11 49 02 02 41 31 4A 43 D5
87 F1 11 49 02 03 35 34 34 34 A8
87 F1 11 49 02 04 52 37 32 35 C8
keepalive – I’ve seen this being sent by the ELM327 every 2 seconds (if no other requests were sent), but I think that requesting mode 01 PID 0x00 could also be a good keepalive.
request: C1 33 F1 3E 23
response: 81 F1 11 7E 01
Note that the first response byte contains frame length. It is encoded on the 6 lower bits. The length does not include the initial length byte, 2 type bytes and checksum byte (so you would have to add 4 to the number to get the whole frame length in bytes).

## Requesting a PID – ISO-9141

This is an older protocol. Main issue is that the response length is not transmitted, so you have to either have a lookup table of all possible lengths (ie. PID+length pairs) or receive byte-by-byte, compute the checksum on the fly and process when the checksum is valid (plus some timeout logic).

Examples (PID values in bold):

ELM request 010C (mode 01, PID 0x0C – RPM)
request: 68 6A F1 01 0C D0
response: 48 6B 11 41 0C 1F 40 70
ELM request 0100 (mode 01, PID 0x00 – available mode 01 PIDs)
request: 68 6A F1 01 00 C4
response: 48 6B 11 41 00 FF FF FF FF 01
ELM request 010D (mode 01, PID 0x0D – speed km/h)
request: 68 6A F1 01 0D D1
reponse: 48 6B 11 41 0D 00 12
ELM request 0902 (mode 09, PID 0x02 – get VIN, this request is special as response comes in several frames, the result is ASCII, left padded with zeros)
request: 68 6A F1 09 02 CE
response:
48 6B 11 49 02 01 00 00 00 31 41
48 6B 11 49 02 02 41 31 4A 43 10
48 6B 11 49 02 03 35 34 34 34 E3
48 6B 11 49 02 04 52 37 32 35 03
48 6B 11 49 02 05 32 33 36 37 E6

[1]: /img/2019/12/28/KL-line_wiring.png "Kline Wiring"
