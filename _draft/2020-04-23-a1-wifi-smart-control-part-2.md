---
layout: post
title: "A1 WiFi Smart Control part 2"
date: 2020-04-23
comments: true
tags: [esp8266,esphome,openmqttgateway,homeassistant]
---

Post Description

# Index

* TOC
{:toc}

# Content

## steps

Need to test [Idea]
Reference [reference#1]

The ESP8266 in this case is on an TYW3ES module which I think is commonly used in Tuya gear. Looking at the [TYWE3S Datasheet] I was able to identify the pins on the module. 
![1]

TYWE3S based controller, with handy breakout through-holes, all labelled and ready to go, had it running off my laptop usb power with a double ground wire to pull GPIO0 to ground and the 2nd ground to my serial programmer, with the requisite TX\RX wires too, flashed Tasmota 6.4 on to it first go, selected the YTF IR bridge and started learning all the codes from my remotes.

<!-- Images -->
[1]: /img/2020/04/23/e3scc.png "TYWE3S Pinout"

<!-- Links -->
[Blog]: https://matthilton2005.github.io
[Idea]: https://community.home-assistant.io/t/mirabella-genio-ir-controller/126918?u=matt2005
[reference#1]: https://newadventuresinwi-fi.blogspot.com/2019/10/brilliant-smart-elite-glass-wall.html?m=1
[TYWE3S Datasheet]: https://docs.tuya.com/docDetail?code=K8uhkbb1ihp8u
