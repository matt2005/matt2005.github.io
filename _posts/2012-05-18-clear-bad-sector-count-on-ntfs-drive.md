---
layout: post
title: Clear bad sector count on NTFS drive
date: 2012-05-18 19:37
author: matt2005
comments: true
tags: [old blog,  Bad sector, gparted, ntfsresize, ntfstruncate, VMware]
---
Here's my first post.

# Problem

I've recent PV'd a failing server to VMware, however the old server had a 250GB disk but only was using 10GB of it.

VMware converter wouldn't let me re-size the disk so I ended up just doing a full copy, now the disk is a thin disk but is taking up 250GB.

The server only needs a 40GB disk so I tried to shrink it with gparted but I was getting an error about bad sectors, as per the warning message I ran chkdsk /r /f several times but all was ok, however gparted wouldn't run. 

I know I could have used ntfsresize -bad-sectors, but I know the disk doesn't have bad sectors.

This made m start thinking if I could reset the bad sector count on the partition, I've written how I did this below.

# Instructions

**Make sure you have a full backup before proceeding**

The instructions below assume the NTFS partition is on /dev/sda1

1. Download gparted live cd

2. When the cd has booted click on terminal type:

    ```dos
    ntfsinfo -i 8 /dev/sda1
	```

3. The command will output similar to the below screenshot
   ![Screenshot 1][1]

4. Make a note of the Allocated size for the '$Bad' attribute, as indicated by the red line above type:

    ```dos
    ntfstruncate /dev/sda1 8 0x80 '$Bad' 0
    ```

5. In the next command you will need to use the allocated size from step 4 type:

    ```dos
    ntfstruncate /dev/sda1 8 0x80 '$Bad' <value from step 4>
    ntfstruncate /dev/sda1 8 0x80 '$Bad' 250048479232
    ```
   Screenshot ![Screenshot 2][2]

6. You can now size the partition with gparted

I hope others find this useful.

Matt

[1]: /img/2012/05/image-4.jpg "Screenshot 1"
[2]: /img/2012/05/image-3.jpg "Screenshot 2"
