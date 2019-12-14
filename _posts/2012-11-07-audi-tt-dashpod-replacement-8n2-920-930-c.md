---
layout: post
title: Audi TT Dashpod replacement 8N2 920 930 C
date: 2012-11-07 18:54
author: matt2005
comments: true
tags: [old blog, Audi TT, Car, VAGCOM]
---
Dashpod replacement Audi TT 2001 8N2 920 930 C

My car has Immo3 so i needed to make the dashpod copy the vin from the ecu. The issue i had with the ross-tech instruction was that the save button was ghosted out in the adaption 50

<img alt="http://www.ttforum.co.uk/forum/download/file.php?id=15822&amp;mode=view" src="http://www.ttforum.co.uk/forum/download/file.php?id=15822&amp;mode=view" />

Heres what i did, well as much as i can remember as was getting annoyed with it.
First my cluster was showing as a new/replacement cluster not adapted. This info is found by xxxxxxxxxxxxx in the extra info and measuring blocks 023, in the third column (Immobiliser status) it should display 4 (New or replacement part cluster, not matched/ adapted), if not it'll be one of the following
5 = Customer service locked; adaptation data programmed
6 = Immobilizer adapted, normal operating condition
7 = Key adaptation in progress via scan-tool

Make sure battery is 12.5V
17 - Instruments, login with the pin for the new cluster
Adaption 0, test, save, ok, close controller
01- Engine, login with pin for old cluster
Adaption 0, test, save, ok, close controller
Turn ignition off, remove key wait a few seconds and turn back on (don't start)
!!! I may have gone 01- engine, login with old cluster pin and close controller !!!
17 - Instruments,
!!! I may have logged in using the new pin before the next step !!!
Adaption 50, read
the top box should display <b>pin?</b>
In the new value box type in the 0 and then 4 digit pin. e.g. if your pin is 1234 then type 01234
with the cursor still in the box press enter
your VIN should appear split across the top boxes, the save box will be ghosted out
press 0 then type the new cluster pin in the box. e.g. new pin 9876 then type 09876 and press enter
your vin should still be in the boxes above
now in the new value box type 32000 and then enter
Now the save button should be enabled, click save, ok, close controller
re-open 17- instruments, your vin should now be in the extra info box.
Login using your old pin (this is now your clusters pin, as the data in the cluster has been re-written with the old immo data.
now you can match the keys to the immo
Once I matched the Cluster the key matching worked prefectly, now the car is running fine.

I hope this helps others, I used a vagcom dumb cable while doing this to my 2001 225.
