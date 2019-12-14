---
layout: post
title: Windows 2012 - RDP password change even when NLA is enabled
date: 2017-01-06 12:05
author: matt2005
comments: true
tags: [old blog, needs content checking NLA, RDP, Windows, Windows 2012]
---
<p style="margin:0;font-family:Calibri;font-size:11pt;">If NLA is enabled on 2012 and your password expires you will be unable to login</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">To be able to reset your password add the following to default.rdp in your user profile\documents folder</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">Sometimes you try to open a remote desktop connection to a machine only to get an error message that "the password has expired".</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"><img class="alignnone size-full wp-image-111" src="/img/2017/01/rdperror.png" alt="rdperror" width="480" height="107" /></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">Add the following setting to your .rdp file ("C:\Users\&lt;User&gt;\Documents\Default.rdp" if you aren't using a specific one).</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">enablecredsspsupport:i:0</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">Then run mstsc and connect you'll be able to change the password</p>
