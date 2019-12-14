---
layout: post
title: Vagcom on Linux
date: 2012-10-31 18:13
author: matt2005
comments: true
tags: [old blog, Car, Linux, VAGCOM]
---
# Download vagcom 311.2

## Installation

1. Install wine

    ```bash
    sudo apt-get install win
    ```

2. Setup wine

    ```bash
    winecft
    ```

3. Click ok on wine popup with no changes to any configs
4. copy installation file to ~/.wine/drive_c/

    ```bash
    cp ~/Desktop/VAGCOM/Release3112n.exe ~/.wine/drive_c/
    ```

5. run installation

    ```bash
    wine c:\Release3112n2.exe
    ```

6. Follow installation through ACCEPT, install.....
7. run shortcut on desktop
   - if not created create using

        ```bash
        env WINEPREFIX="~/.wine" wine "C:\Program Files\VAG-COM\VagCom.exe"
        ```

## Setup the dongle

1. Symlink usb

   ```bash
   ln -s /dev/ttyUSB0 ~/.wine/dosdevices/com1
   ```

2. Select vagcom to use com1 and go test
