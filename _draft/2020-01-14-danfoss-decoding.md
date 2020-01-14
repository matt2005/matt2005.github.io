---
layout: post
title: "Danfoss decoding"
date: 2020-01-14
tags: []
---

Post Description

# Index

* TOC
{:toc}

# Overview

I'm attempting to decode the signal that is produced by Danfoss RX2. Based on [replay_attack]

## Idea

I'm planning to use the following

* Raspberry Pi 3 with Debian Buster
* [RPItx-github]
* [RTL-SDR-github]

## Setup PI

Prepare PI and test RPItx and RTL-SDR

### Prep Buster

```bash
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
```

### Install rpitx

```bash
su -
git clone https://github.com/F5OEO/rpitx
cd rpitx
./install.sh
```

### Install RTL-SDR

```bash
sudo apt-get install cmake libusb-1.0-0-dev -y
cd ~/
git clone https://github.com/keenerd/rtl-sdr
cd rtl-sdr/
mkdir build
cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo make install
sudo ldconfig
```

### Install SOX

```bash
sudo apt-get install sox -y
```

### Reboot

```bash
sudo reboot
```


<!-- Images -->
[1]: /img/file.jpg "File"

<!-- links -->
[replay_attack]: https://www.rtl-sdr.com/tutorial-replay-attacks-with-an-rtl-sdr-raspberry-pi-and-rpitx/
[RPItx-github]: https://github.com/F5OEO/rpitx
[RTL-SDR-github]: https://github.com/keenerd/rtl-sdr