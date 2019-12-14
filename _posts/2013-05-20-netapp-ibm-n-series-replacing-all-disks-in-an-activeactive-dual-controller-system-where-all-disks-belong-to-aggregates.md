---
layout: post
title: NetApp / IBM N-Series - Replacing all disks in an active/active dual controller system where all disks belong to aggregates.
date: 2013-05-20 13:05
author: matt2005
comments: true
tags: [old blog, needs content checking Uncategorized]
---
 HOW DO I REPLACE ALL DISKS IN A TWO CONTROLLER ACTIVE/ACTIVE IBM N-SERIES OR NETAPP FAS STORAGE SYSTEM WHEN ALL DISKS ARE ALREADY ALLOCATED TO AGGREGATES?
Need to replace all the disks in your NetApp FAS or IBM N-Series Storage System?

Need to replace all the disks in your NetApp FAS or IBM N-Series Storage System?

This explains how to deal with a common disk replacement scenario that occurs within SMEs running entry-level dual controller NetApp FAS or IBM N-Series storage systems, where the controllers are running in an active/active configuration with each controller owning one aggregate.

Scenario
The Customer has two NetApp FAS or IBM N-series ONTAP 7-mode 7.x or 8.x Storage Systems on their network.  One is used for production and one for backups/archiving.

The Customer wants to replace all of the disks in the production storage system.

The Storage System we are working with is a 2-controller system.  In this example, the controllers are called CONTROLLER1 and CONTROLLER2.

CONTROLLER1 owns 12 disks in tray 1 (Internal SATA/SAS Tray)
CONTROLLER2 owns 14 disks in tray 2 (External FC/SAS Tray)

The disks we want to replace are the 12 disks in tray1 owned by CONTROLLER1

There are no unallocated or unowned disks in tray 2. All disks are 100% allocated to their controller’s respective Aggregates (aggr0 for CONTROLLER1, aggr1 for CONTROLLER2).  Both aggregates are RAID-DP and each has a single online spare.

All production volumes on CONTROLLER1 have already been backed up and migrated elsewhere.  All that remains on aggr0 is the root volume for CONTROLLER1, which we call vol0 in this example.

Removing the disks from tray1 will destroy root volume vol0 for CONTROLLER1, rendering the controller unbootable, therefore forcing a time consuming rebuild of the controller’s configuration.

This procedure avoids this undesirable consequence and provides for a very fast route to the desired upgrade with a minimum of risk.

The migration takes place in 4 steps:

-          Backing up volumes to another NetApp/IBM N series storage system
-          Freeing up and reassigning disks
-          Copying the root volume and forcing boot from the copy.
-          Replacing the disks
-          Assigning the new disks
-          Copying the root volume to the new disks and forcing boot from the copy
-          Tidy-up

Backing up volumes
This assumes you have another IBM N-Series or NetApp 7.x or 8.x 7-mode  storage system on the network with spare capacity to take a backup of all of the data on the Storage system being upgraded.  If you have a D2D or D2T backup system that can take block level backups of NetApp volumes (such as Snapvault) then this solution could be used instead of the method described in this section.

The controller host name of the second storage system we are using for backup purposes is SYSTEM2 in this exercise.

1)        On SYSTEM2 create volumes identical in name, size and configuration to those on CONTROLLER2:
CONTROLLER2&gt; vol create   g
CONTROLLER2&gt; snap reserve  0

2)        Repeat step 1 for all volumes on CONTROLLER2

3)        Create a user on CONTROLLER2 called ndmpuser

4)        Create a user on SYSTEM2 called ndmpuser

5)        On CONTROLLER2 run commands:
CONTROLLER2&gt; ndmpd on
(This turns on “ndmp” volume to volume block copy functionality)
CONTROLLER2&gt; ndmpd password ndmpuser
This will return a response similar to this:
password g8x8xxxxxmZ0121

6)        On SYSTEM2 run commands:
SYSTEM2&gt; ndmpd on
SYSTEM2&gt; ndmpd password ndmpuser
This will return a response similar to this:
password 48so8xxxxxxZ00nA

7)        On CONTROLLER2 run command:
CONTROLLER2&gt; ndmpdcopy –sa ndmpuser: –da ndmpuser: “CONTROLLER2:/vol/” “SYSTEM2: :/vol/”

8)        Wait for the NDMPCOPY block level backup to complete

9)        Repeat steps 7 and 8 for all volumes on CONTROLLER2

10)     The backup of all production volumes on the Storage system is now complete.  Your data is now safe

Freeing up and reassigning disks
This is the “clever” bit.  We actually have two disks on CONTROLLER2’s aggregate  that we can use to temporarily host CONTROLLER1’s root volume vol0.  Where?  One is the online spare and the other is the second parity disk.  We just need to persuade CONTROLLER2 to give them up.

Obviously the production data on CONTROLLER2’s aggregate is at risk in this procedure – one slip of the fingers, or a disk hardware failure while carrying out this procedure could wipe out the whole aggregate and everything on it.  This is why we backed up all the volumes first!

1)        First, we change the aggregate on CONTROLLER2 from RAID-DP to RAID4.  This frees up the disk we need.
CONTROLLER2&gt; aggr options  raidtype raid4

2)        Now we take a look at the Disk Ids for all 12 disks on CONTROLLER2&gt;
CONTROLLER2&gt; disk show
This returns a list similar to this:
DISK             OWNER
0c.00.10     CONTROLLER1(142242188)   Pool0  WD-WCAW31835980
0c.00.11     CONTROLLER1(142242188)   Pool0  WD-WCAW31794728
0c.00.7      CONTROLLER1(142242188)   Pool0  WD-WCAW31794859
0c.00.6      CONTROLLER1(142242188)   Pool0  WD-WCAW31837574
0c.00.9      CONTROLLER1(142242188)   Pool0  WD-WCAW31837897
0c.00.1      CONTROLLER1(142242188)   Pool0  WD-WCAW31838280
0c.00.2      CONTROLLER1(142242188)   Pool0  WD-WCAW31833821
0c.00.4      CONTROLLER1(142242188)   Pool0  WD-WCAW31837475
0c.00.3      CONTROLLER1(142242188)   Pool0  WD-WCAW31838144
0c.00.5      CONTROLLER1(142242188)   Pool0  WD-WCAW31797802
0c.00.8      CONTROLLER1(142242188)   Pool0  WD-WCAW31837141
0b.16        CONTROLLER2(142242248)   Pool0  JXY3288N
0b.26        CONTROLLER2(142242248)   Pool0  JXY3SPNN
0b.25        CONTROLLER2(142242248)   Pool0  JXY32VAN
0b.27        CONTROLLER2(142242248)   Pool0  JXY69ENN
0b.29        CONTROLLER2(142242248)   Pool0  JXY32P3N
0b.18        CONTROLLER2(142242248)   Pool0  JXY3ST7N
0b.17        CONTROLLER2(142242248)   Pool0  JXY3212N
0b.20        CONTROLLER2(142242248)   Pool0  JXY68ADN
0b.21        CONTROLLER2(142242248)   Pool0  JXY6R85N
0b.23        CONTROLLER2(142242248)   Pool0  JXY69B3N
0b.22        CONTROLLER2(142242248)   Pool0  JXY32A0N
0b.28        CONTROLLER2(142242248)   Pool0  JXY68EVN
0b.19        CONTROLLER2(142242248)   Pool0  JXY688UN
0b.24        CONTROLLER2(142242248)   Pool0  JXY3SR9N
0c.00.0      CONTROLLER1(142242188)   Pool0  WD-WCAW31835829

3) Find out which two of CONTROLLER2’s disks are the spares (one being the original spare and the second being the parity disk we liberated by converting the aggregate to RAID4 earlier.  The spares can be viewed under CONTROLLER2 &gt; Storage &gt; Disks in NetApp System Manager.  They will have a “State” of “Spare”.

In this case, let’s say the Spare disks are:
0b.16
0b.29

4)        First we turn disk Autoassign off:
on CONTROLLER2:
CONTROLLER2&gt; options disk.auto_assign off
on CONTROLLER1:
CONTROLLER1&gt; options disk.auto_assign off

5)        We now need to remove the owner from these two disks:
From CONTROLLER2:
CONTROLLER2&gt; disk assign 0b.16 –s unowned –f
CONTROLLER2&gt; disk assign 0b.29 –s unowned –f

substituting 0b.16 and 0b.29 with your spare disk Ids

You will get a warning about there not being enough spare disks.  Ignore this for now.

6)        Next, we assign our two newly liberated disks to CONTROLLER1.
From CONTROLLER1:
CONTROLLER1&gt; disk show –n
This will show the two unassigned disks something like this:
DISK       OWNER                  POOL   SERIAL NUMBER
0b.16      Not Owned              NONE   JXY3288N
0b.29      Not Owned              NONE   JXY32P3N

7)        Now we assign the two disks to CONTROLLER1:
CONTROLLER1&gt; disk assign 0b.16 –o CONTROLLER1
CONTROLLER1&gt; disk assign 0b.29 –o CONTROLLER1

Again, substituting 0b.16 and 0b.29 with the same disk Ids you worked with in step 5

8)        If we execute a DISK SHOW command now, we should see that CONTROLLER1 now owns the two liberated disks (0b.16 and 0b.29 in this example)

9)        No we can create an aggregate called “aggr_temp” on the two new disks to take the temporary root volume while we swap out CONTROLLER1’s disks:
CONTROLLER1&gt; aggr create aggr_temp -f -t raid4 -d 0b.16 0b.29
again use your own disk IDs per steps 6 &amp; 7

10)     Run command AGGR STATUS and watch the status of aggr_temp.  As soon as it goes to status “Online” you may proceed to the next step.  This process could take several minutes or several hours depending on the speed and size of your disks and other load on the storage system.

11)     Now we create a new volume on the new aggregate aggr_temp called vol0_temp of identical size and configuration as CONTROLLER1’s root volume
CONTROLLER1&gt; vol create vol0_temp aggr_temp 12g
CONTROLLER1&gt; snap reserve vol0_temp 0

 

Copying the root volume and making it bootable

12)     We are now ready to copy our root volume.  We need to elevate our access level for these commands:
CONTROLLER1&gt; priv set diag

13)     Now we do a block level copy of the root vol:
CONTROLLER1*&gt; ndmpd on
CONTROLLER1*&gt; ndmpcopy “/vol/” /vol/vol0_temp

14)     Once copy is complete, we tag the copy root volume on the tray 2 disks as the root volume for the controller, then restart the controller.
CONTROLLER1*&gt; vol options vol0_temp root
CONTROLLER1*&gt; reboot –t 0

15)     Wait for CONTROLLER1 to reboot, then log back into it.

16)     You may now offline and destroy the original root volume and original production aggregate (the one containing the original root volume).  From CONTROLLER1 run commands:
CONTROLLER1*&gt; vol offline 
CONTROLLER1*&gt; vol destroy 
CONTROLLER1*&gt; aggr offline 
CONTROLLER1*&gt; aggr destroy 

17)     We can then remove CONTROLLER1 as the owner of the 12 disks that we are replacing.  Use the DISK SHOW command to get the list of 12 Disk Ids, then run a:
disk remove_ownership 
command for each disk

Replacing the disks

The Disks connected to CONTROLLER1 may now be physically replaced with the newer items.

Assigning the new disks

We can  now assign the new disks to CONTROLLER1.

1)      From CONTROLLER1, execute command:
CONTROLLER1&gt; disk show –n

You will see the 12 new disks listed in a manner similar to that shown below:

DISK       OWNER                  POOL   SERIAL NUMBER
0c.00.6    Not Owned              NONE   6SL3TBTZ0000N2411P6L
0c.00.10  Not Owned              NONE   6SL3TKFT0000N240E87Y
0c.00.2    Not Owned              NONE   6SL3TXR00000N2404LQ7
0c.00.7    Not Owned              NONE   6SL3SVJB0000N2406TNF
0c.00.11  Not Owned              NONE   6SL3VKKZ0000N2404MXT
0c.00.9    Not Owned              NONE   6SL3RSXR0000N240EFS9
0c.00.5    Not Owned              NONE   6SL3TGLC0000N240JW0C
0c.00.8    Not Owned              NONE   6SL3VBE40000N240MLSW
0c.00.1    Not Owned              NONE   6SL3TSRK0000N240HSMF
0c.00.4    Not Owned              NONE   6SL3SXW10000N240CN53
0c.00.0    Not Owned              NONE   6SL3VHJE0000N2410VFT
0c.00.3    Not Owned              NONE   6SL3TL7G0000N2404J91

2)      Now we assign each of the new disks in turn to CONTROLLER1 using command:
CONTROLLER1&gt; disk assign  -o CONTROLLER1
i.e.
disk assign 0c.00.6 -o CONTROLLER1
disk assign 0c.00.10 -o CONTROLLER1
etc
until you have assigned all 12 disks.

3)      We can now create our new aggregates using the “aggr create” command.  The setup of these is obviously up to you.  Remember to leave one spare though!

For the purposes of this example, we assume the new aggregate on which the root volume for CONTROLLER1 will be placed is called aggr0.

4)      Next create your new root volume on the new disks:
CONTROLLER1&gt; vol create vol0 aggr0 12g
creates a 12GB volume called vol0 on aggregate aggr0.  If you prefer another size, use this instead.

5)      Now we can copy the root volume back to its proper location on the new disks:
CONTROLLER1*&gt; ndmpd on
CONTROLLER1*&gt; ndmpcopy /vol/vol0_temp /vol/vol0
You should substitute vol0 for your chosen volume name if different to the above.  But the TEMP vol0 should always go FIRST and the root volume on the new disks SECOND.

6)      Once copy is complete, we tag the copy root volume on the tray 2 disks as the root volume for the controller, then restart the controller.
CONTROLLER1*&gt; vol options vol0 root
CONTROLLER1*&gt; reboot –t 0

7)      Wait for CONTROLLER1 to reboot

Tidy-up

1)      On CONTROLLER1, run these commands to remove the old temp root volume:
CONTROLLER1&gt; Vol offline vol0_temp
CONTROLLER1&gt; Vol destroy vol0_temp
with “Y” to acknowledge

2)      On CONTROLLER1, run these commands to remove the old temp root aggregate:
CONTROLLER1&gt; Aggr offline aggr_temp
CONTROLLER1&gt; Vol destroy aggr_temp
with “Y” to acknowledge

3)      On CONTROLLER1, de-assign the two disks we “borrowed” from CONTROLLER2:
CONTROLLER1&gt; options disk.auto_assign off
CONTROLLER1&gt; disk assign  –s unowned –f
CONTROLLER1&gt; disk assign  –s unowned –f
These will be the same two disk IDs you worked with in “Freeing up disks” step 5

4)      You are now done with CONTROLLER1.  You will switch to CONTROLLER2 for the remainder of the procedure.  First, we assign the two “borrowed” disks back to CONTROLLER2
CONTROLLER2&gt; disk assign  -o CONTROLLER2
CONTROLLER2&gt; disk assign  -o CONTROLLER2 

5)      Then, to wrap up we convert CONTROLLER2’s aggregate back to RAID_DP:
CONTROLLER2&gt; aggr options  raidtype raid_dp

All done!  Of course, if we want to replace CONTROLLER2’s disks as well, we simply migrate all of CONTROLLER2’s production volumes over to CONTROLLER1 and repeat the procedure above, except that this time, we transpose CONTROLLER1 and CONTROLLER2.
