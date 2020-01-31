---
layout: post
title: "A first look at OpenAuto"
date: 2020-01-27
tags: [openauto, AndroidAuto, Crankshaft, Crankshaft-NG]
---

A first look at OpenAuto. This is the first post of the project.

# Index

* TOC
{:toc}

# Overview

OpenAuto is an AndroidAuto(tm) headunit emulator based on aasdk library and Qt libraries.
I plan to build a headunit to be a simple plug 'n' play but with the AndroidAuto support.

Initially I planned to build it via source this was [original plan], but following a [rethink] I'm now using [Crankshaft-NG]. I have left the code build instructions the post in case I need to change this decision.

# Hardware

* Raspberry PI 3
* USB Audio adapter with headphone output and mic input
* HDMI display

# Re-thinking the solution {#rethink}

## Software

Upon a rethink it has occured to me that it'll be better to use [Crankshaft-NG] which is a pre image based on OpenAuto.

### Steps performed

- Download Crankshaft-NG
- Image SD card with downloaded image
- Enable Dev_Mode
    - Edit /boot/crankshaft/chrankshaft_env.sh
      - DEV_MODE=1
      - DEV_MODE_APP=1
- Power on pi
- SSH to pi
  - Using pi/raspberry
- Update
```bash
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo reboot
```
- Rename host (Optional). Update each file with the new hostname.
```bash
sudo nano /etc/hostname
sudo nano /etc/hosts
```
- Enable onboard BT
    You must reboot after this.
```bash
crankshaft bluetooth builtin
sudo reboot
```
- Set crankshaft to pariable for 120 secs
```bash
crankshaft bluetooth pairable
```
- Pair phone


# Original Plan {#original-plan}

## Software

* Raspbian Buster Lite
* aasdk
* OpenAuto

### Update Raspbian

- Login as pi
- Set GPU memory to 256MB via raspi-config
- Ensure Raspbian is fully updated.
```bash
sudo apt update -y
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoclean -y
```
- add basic GUI [addgui]
```bash
#sudo apt install -y --no-install-recommends xserver-xorg raspberrypi-ui-mods
#sudo apt install -y xvfb
sudo apt-get install --no-install-recommends xserver-xorg
sudo apt-get install --no-install-recommends xinit
sudo apt-get install -y lxde-core lxappearance
sudo apt-get install -y lightdm
```
- add default gui and autologin
/etc/systemd/system/default.target → /lib/systemd/system/graphical.target

## aasdk

### Build

Build [aasdk] from the source code. This takes about 40 minutes.

- Install pre-requirements
```bash
sudo apt-get install -y libboost-all-dev libusb-1.0.0-dev libssl-dev cmake libprotobuf-dev protobuf-c-compiler protobuf-compiler
```
- Get aasdk code
```bash
cd ~/
git clone -b development https://github.com/opencardev/aasdk.git
```
- Prepare build environment
```bash
mkdir aasdk_build
cd aasdk_build
```
- Generate cmake files
```bash
cmake -DCMAKE_BUILD_TYPE=Release ../aasdk
```
- Build aasdk
```bash
make
```

## OpenAuto

Build [OpenAuto] from source code. This takes about 40 minutes.

### Build

- Install pre-requirements
```bash
sudo apt-get install -y libqt5multimedia5 libqt5multimedia5-plugins libqt5multimediawidgets5 qtmultimedia5-dev libqt5bluetooth5 libqt5bluetooth5-bin qtconnectivity5-dev pulseaudio librtaudio-dev librtaudio6
```
- Build ilclient from Raspberry PI 3 firmware
```bash
cd /opt/vc/src/hello_pi/libs/ilclient
make
```
- Get OpenAuto code
```bash
cd ~/
git clone -b crankshaft-ng https://github.com/opencardev/openauto.git
```
- Prepare build environment
```bash
mkdir openauto_build
cd openauto_build
```
- Generate cmake files
```bash
cmake -DCMAKE_BUILD_TYPE=Release -DRPI3_BUILD=TRUE -DAASDK_INCLUDE_DIRS="/home/pi/aasdk/include" -DAASDK_LIBRARIES="/home/pi/aasdk/lib/libaasdk.so" -DAASDK_PROTO_INCLUDE_DIRS="/home/pi/aasdk_build" -DAASDK_PROTO_LIBRARIES="/home/pi/aasdk/lib/libaasdk_proto.so" ../openauto
```
- Build OpenAuto
```bash
make
```

### OpenAuto First Run

Run OpenAuto
```bash
/home/pi/openauto/bin/autoapp
```

<!-- Images -->
[1]: /img/file.jpg "File"

<!-- Links -->
[Blog]: https://matthilton2005.github.io
[aasdk]: https://github.com/opencardev/aasdk
[OpenAuto]: https://github.com/f1xpl/openauto
[OpenAuto2]: https://github.com/opencardev/openauto.git
[Crankshaft-NG]: https://getcrankshaft.com/
[addgui]: https://www.raspberrypi.org/forums/viewtopic.php?t=133691
[original plan]: #original-plan
[rethink]: #rethink