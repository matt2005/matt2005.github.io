---
layout: post
title: "A1 WiFi Smart Control - part 1"
date: 2020-04-23
comments: true
tags: [esp8266,esphome,openmqttgateway,automating IR,homeassistant]
---

Post Description

# Index

* TOC
{:toc}

# Content

## Overview

Enable control of IR devices using [Home Assistant] using a off-the-shelf product with minimal changes.

I have chosen [Smart Universal Remote controller IR WiFi Intelligent Home Remote Suitable for Alexa Google Assistant] as it was cheap £14.99, and used the TuyaSmart app which meant it's probably based on esp8266.

This post is post 1, which will cover the product basic teardown.

## Teardown

I have just received the product and it looks pretty good, i haven't powered it up as there have ben reports of problems when using Tuya convert if you allow it to update.

Here are photos of the unit. The unit is screwed together by 4 phillips screws under the foam padding on the bottom.

![box_front][1]
![box_rear][2]
![inside][3]
![pcb_front][4]
![pcb_front_closeup_1][5]
![pcb_front_closeup_2][6]
![pcb_rear][7]
![a1_back][8]
![pcb_rear_closeup_1][9]
![pcb_rear_closeup_2][10]

## next steps

Work out pin out for J11, so we can program it.

<!-- Images -->
[1]: /img/2020/04/23/box_front.jpg "box_front"
[2]: /img/2020/04/23/box_rear.jpg "box_rear"
[3]: /img/2020/04/23/inside.jpg "inside"
[4]: /img/2020/04/23/pcb_front.jpg "pcb_front"
[5]: /img/2020/04/23/pcb_front_closeup_1.jpg "pcb_front_closeup_1"
[6]: /img/2020/04/23/pcb_front_closeup_2.jpg "pcb_front_closeup_2"
[7]: /img/2020/04/23/pcb_rear.jpg "pcb_rear"
[8]: /img/2020/04/23/a1_back.jpg "a1_back"
[9]: /img/2020/04/23/pcb_rear_closeup_1.jpg "pcb_rear_closeup_1"
[10]: /img/2020/04/23/pcb_rear_closeup_2.jpg "pcb_rear_closeup_2"

<!-- Links -->
[Blog]: https://matthilton2005.github.io
[Home Assistant]: https://home-assistant.io
[Smart Universal Remote controller IR WiFi Intelligent Home Remote Suitable for Alexa Google Assistant]: https://www.amazon.co.uk/gp/product/B07T9KLWK3
