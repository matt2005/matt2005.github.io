---
layout: post
title: Clear bad sector count on NTFS drive
date: 2012-05-18 19:37
author: matt2005
comments: true
tags: [old blog, From old blog, Bad sector, gparted, ntfsresize, ntfstruncate, VMware]
---
Here's my first post.

I've recent PV'd a failing server to VMware, however the old server had a 250GB disk but only was using 10GB of it. VMware converter wouldn't let me re-size the disk so I ended up just doing a full copy, now the disk is a thin disk but is taking up 250GB.
The server only needs a 40GB disk so I tried to shrink it with gparted but I was getting an error about bad sectors, as per the warning message I ran chkdsk /r /f several times but all was ok, however gparted wouldn't run. I know I could have used ntfsresize -bad-sectors, but I know the disk doesn't have bad sectors.  This made m start thinking if I could reset the bad sector count on the partition, I've written how I did this below.

****Make sure you have a full backup before proceeding****

The instructions below assume the NTFS partition is on /dev/sda1
<ol>
	<li>Download gparted live cd</li>
	<li>When the cd has booted click on terminal</li>
	<li>type: <em>
ntfsinfo -i 8 /dev/sda1</em></li>
	<li>The command will output similar to the below screenshot<img src="/img/2012/05/image-4.jpg" alt="Screenshot 1" /></li>
	<li>Make a note of the Allocated size for the '$Bad' attribute, as indicated by the red line above</li>
	<li>type:
<em>ntfstruncate</em> /dev/sda1 8 0x80 '$Bad' 0</li>
	<li>In the next command you will need to use the allocated size form step 5.</li>
	<li>type:
ntfstruncate /dev/sda1 8 0x80 '$Bad' &lt;number from step 5&gt;
ntfstruncate /dev/sda1 8 0x80 '$Bad' 250048479232</li>
	<li>Screen shot of steps 6-8<img src="/img/2012/05/image-3.jpg" alt="Screenshot 2" /></li>
	<li>You can now size the partition with gparted</li>
</ol>
I hope others find this useful.

Matt
