---
layout: post
title: My Raspberry PI Setup
date: 2012-09-12 23:14
author: matt2005
comments: true
tags: [old blog, Raspberry PI]
---
<code>
apt-get update
apt-get upgrade
apt-get dist-upgrade
apt-get install git-core wget ca-certificates binutils -y
wget http://goo.gl/1BOfJ -O /usr/bin/rpi-update &amp;&amp; chmod +x /usr/bin/rpi-update
rpi-update 
nano /boot/config.txt
</code>
Add the following in to the file for 128MB GPU if 256MB Pi or 256MB GPU for 512MB Pi
<code>
gpu_mem_256=128
gpu_mem_512=256
</code>
<code>
echo "CONF_SWAPSIZE=1024" &gt; /etc/dphys-swapfile
dphys-swapfile setup
dphys-swapfile swapon
apt-get install preload -y
apt-get autoremove
sed -i 's/vm.swappiness=1/vm.swappiness=10/g'  /etc/sysctl.conf
sed -i 's/vm.min_free_kbytes = 8192/vm.min_free_kbytes=32768/g'  /etc/sysctl.conf
sed -i 's/sortstrategy = 3/sortstrategy = 0/g'  /etc/preload.conf
apt-get install tightvncserver -y
vncserver :1 -geometry 1024x600 -depth 16 -pixelformat rgb565
nano /etc/profile
</code>
----------add startx to end of file
<code>
crontab -e
</code>
----------add following line
<code>
@reboot su -c "vncserver :1 -geometry 1024x600 -depth 16 -pixelformat rgb565" pi
</code>
<code>
wget https://github.com/rg3/youtube-dl/raw/2012.02.27/youtube-dl
chmod +x youtube-dl
cp youtube-dl /usr/bin/youtube-dl
sudo apt-get install python-setuptools -y
wget http://pypi.python.org/packages/source/w/whitey/whitey-0.1.tar.gz
tar -zxvf whitey-0.1.tar.gz
nano ./whitey-0.1/src/yt/__init__.py
</code>
--------------edit 'mplayer and switches to omxplayer
<code>
cd whitey-0.1/
sudo python setup.py install
sed -i 's/PLAYER_CORE_DVDPLAYER/PLAYER_CORE_AUTO'
sudo git clone git://git.infradead.org/get_iplayer.git
cd get_iplayer
sudo chmod 777 get_iplayer
sudo apt-get install libwww-perl rtmpdump flvstreamer ffmpeg -y
#create /usr/bin.get_iplayer
sudo mkdir /usr/bin/get_iplayer
#copy to /usr/bin/get_iplayer
sudo cp -Rv * /usr/bin/get_iplayer/
# set default type to tv &amp; radio
/usr/bin/get_iplayer/get_iplayer --prefs-add --type=tv,radio
# set cache expiry to 1 hour
/usr/bin/get_iplayer/get_iplayer --add-prefs --expiry=3600
# set output directory
/usr/bin/get_iplayer/get_iplayer --prefs-add --output="/media/iplayer"
# set specific output directory for radio
/usr/bin/get_iplayer/get_iplayer --prefs-add --outputradio="/media/iplayer/radio"
# you can also set specific output directory for tv with
/usr/bin/get_iplayer/get_iplayer --prefs-add --outputtv="/media/iplayer/tv"
# set to use sub-directories
/usr/bin/get_iplayer/get_iplayer --prefs-add --subdir
# set file name format
/usr/bin/get_iplayer/get_iplayer --prefs-add --file-prefix="---"
# set to search future schedule
/usr/bin/get_iplayer/get_iplayer --add-prefs --refresh-future
# set to exclude cbebbies and cbbc from refresh
/usr/bin/get_iplayer/get_iplayer --add-prefs --refresh-exclude="cbeebies,cbbc,CBBC"
# set to download thumbnail
/usr/bin/get_iplayer/get_iplayer --add-prefs --thumbnail
# set to download metadata
/usr/bin/get_iplayer/get_iplayer --add-prefs --metadata=generic
# symlink for get_iplayer
cd /usr/bin
ln -s /usr/bin/get_iplayer/get_iplayer iplayer
# create cron.4hourly
mkdir /etc/cron.4hourly
chmod 755 /etc/cron.4hourly
</code>
-----------------/etc/cron.4hourly/iplayer_pvr---------------
<code>
#!/bin/sh
/usr/bin/get_iplayer/get_iplayer --pvr
</code>
-------------------------------------------------------------
<code>
chmod 755 /etc/cron.4hourly/iplayer_pvr
</code>
-----------------/etc/cron.daily/iplayer_refresh_feeds-------
<code>
#!/bin/sh
/usr/bin/get_iplayer/get_iplayer --type=tv,radio --refresh-future --refresh
</code>
-------------------------------------------------------------
<code>
chmod 755 /etc/cron.daily/iplayer_refresh_feeds
</code>
-----------------/etc/cron.daily/iplayer_update_metadata-----
<code>
#!/bin/sh
/usr/bin/get_iplayer/get_iplayer  --thumbnail-only --history
/usr/bin/get_iplayer/get_iplayer --metadata-only --metadata=generic --history
</code>
-------------------------------------------------------------
<code>
chmod 755 /etc/cron.daily/iplayer_update_metadata
</code>
<code>
# create cron.nightly
mkdir /etc/cron.nightly
chmod 755 /etc/cron.nightly
</code>
-----------------/etc/cron.nightly/iplayer_cleanup_partial_downloads-------
<code>
#!/bin/sh
find /media/iplayer/tv -name *.partial.mp4.flv -exec rm -v {} \;
</code>
-------------------------------------------------------------
<code>
chmod 755 /etc/cron.nightly/iplayer_cleanup_partial_downloads
</code>
add the following to /etc/crontab
-----------------------------------
<code>
40 0,4,8,10,14,18,22 * * * root test -x /usr/sbin/anacron || ( cd / &amp;&amp; run-parts --report /etc/cron.4hourly )
</code>
-----------------------------------
<code>
apt-get install libpcre3 -y
apt-get purge omxplayer -y
wget http://omxplayer.sconde.net/builds/omxplayer_0.2.1~git20120812~231c08b4_armhf.deb
dpkg -i omxplayer_0.2.1~git20120812~231c08b4_armhf.deb
apt-get install minidlna -y
apt-get install ntfs-3g -y
blkid
mkdir -p /media/HardDrive
chmod 755 /media/HardDrive
nano /etc/fstab
nano /etc/minidlna.conf
</code>
----Add
<code>
media_dir=/media
# Change db_dir so that the database is saved across reboots
db_dir=/var/lib/minidlna
# Uncomment log_dir for now in case we hit problems
log_dir=/var/log
</code>
-----------------------------
<code>
cupdate-rc.d minidlna defaults
service minidlna start
</code>
if you need to edit minidlna.conf after saving run
<code>
service minidlna force-reload
</code>
to test 4hourly run
<code>run-parts --verbose /etc/cron.4hourly</code>
