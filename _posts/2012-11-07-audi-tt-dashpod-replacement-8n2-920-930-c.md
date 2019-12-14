---
layout: post
title: Audi TT Dashpod replacement 8N2 920 930 C
date: 2012-11-07 18:54
author: matt2005
comments: true
tags: [old blog, Audi TT, Car, VAGCOM]
---
# Audi TT 2001 8N2 920 930 C dashpod replacement using VAGCOM

# Problem

My car has Immo3 so I needed to make the dashpod copy the vin from the ecu. The issue I had with the ross-tech instruction was that the save button was ghosted out in the adaption 50

![Screenshot 1][1]

# Instructions

Heres what I did, well as much as I can remember as was getting annoyed with it.

First my cluster was showing as a new/replacement cluster not adapted. This info is found by xxxxxxxxxxxxx in the extra info and measuring blocks 023.
In the third column (Immobiliser status) it should display 4 (New or replacement part cluster, not matched/ adapted), if not it'll be one of the following

| Value | Status                                                |
| ----- | ----------------------------------------------------- |
| 4     | New or replacement part cluster, not matched/ adapted |
| 5     | Customer service locked, Adaptation data programmed   |
| 6     | Immobilizer adapted, normal operating condition       |
| 7     | Key adaptation in progress via scan-tool              |

# Procedure

1. Make sure battery is 12.5V
2. Open vagcom and goto 17 - Instruments
3. login with the pin for the new cluster
4. Adaption 0, test, save, ok, close controller
5. 01- Engine, login with pin for old cluster
6. Adaption 0, test, save, ok, close controller
7. Turn ignition off, remove key wait a few seconds and turn back on (don't start)
   - I may have gone 01- engine, login with old cluster pin and close controller !!!
17 - Instruments,
8. I may have logged in using the new pin before the next step !!!
Adaption 50, read
the top box should display **pin?**
9. In the new value box type in the 0 and then 4 digit pin. e.g. if your pin is 1234 then type 01234
with the cursor still in the box press enter
10. Your VIN should appear split across the top boxes
11. the save box will be ghosted out press 0 then type the new cluster pin in the box. e.g. new pin 9876 then type 09876 and press enter
12. Your vin should still be in the boxes above
13. In the new value box type 32000 and then enter
14. Now the save button should be enabled, click save, ok, close controller
15. re-open 17- instruments, your vin should now be in the extra info box.
16. Login using your old pin (this is now your clusters pin, as the data in the cluster has been re-written with the old immo data.
17. now you can match the keys to the immo
18. Once I matched the Cluster the key matching worked prefectly, now the car is running fine.

I hope this helps others, I used a vagcom dumb cable while doing this to my 2001 225.

[1]: /img/2012/11/vagcom.png "Screenshot 1"
