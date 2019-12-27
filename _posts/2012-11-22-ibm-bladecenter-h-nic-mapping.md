---
layout: post
title: "IBM Bladecenter H NIC Mapping"
date: 2012-11-22 11:10
author: matt2005
comments: true
tags: [old blog, Bladecenter, computer, ethernet connections, ethernet switches, H series, HS22, IBM, ibm bladecenter, IBM Bladecenter, software, technology, VMware]
---
# IBM Bladecenter H NIC Mapping

Each Blade has 2 Onboard Ethernet Connections, a CIOv Card with 2 Fibrechannel connections (44X1945) and a CFFh card with 4 Ethernet connections (44W4479).

The Bladecenter has 6 Ethernet switches (Cisco 3012 43W4395), 2 Fibrechannel modules (39Y9280) and 2 Multi-Switch Interconnect modules (39Y9314).

The Multi-switch interconnect modules are installed in the top and bottom high-speed switch bays these create bays 7 and 9 and bays 8 and 10.The Ethernet switches are installed in bays 1, 2, 7, 8, 9, 10. The fibrechannel modules are installed in bays 3 and 4.

On the Blade the NIC's connect as follows
| NIC | Switch Bay |
| --- | --- |
| First NIC | 1|
| Second NIC | 2 |
| Third NIC | 7 |
| Forth NIC | 8 |
| Fifth NIC | 9 |
| Sixth NIC | 10 |

Below is a image of the connections
![NIC Mapping][1]

[1]: /img/2012/11/ibm_bladecenter_nicmapping1.jpg "Screenshot 1"