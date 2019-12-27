---
layout: post
title: "Gitlab Nessus Vulnerabilities - Sweet32, CRIME"
date: 2017-01-06 12:22
author: matt2005
comments: true
tags: [old blog, needs content checking CRIME, GIT, GITLAB, Nessus, Security, SSL, SWEET32]
---
<p style="margin:0;font-family:Calibri;font-size:11pt;">To resolve Nessus Vulnerabilities</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">20007 SSL Version 2 and 3 Protocol Detection</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">42873 SSL Medium Strength Cipher Suites Supported</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">62565 Transport Layer Security (TLS) Protocol CRIME Vulnerability</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">94437 SSL 64-bit Block Size Cipher Suites Supported (SWEET32)</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:'Courier New';font-size:11pt;">nano /etc/gitlab/gitlab.rb</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">Edit the file to show the below</p>
<p style="margin:0;font-family:'Courier New';font-size:11pt;">nginx['ssl_ciphers']="HIGH:!aNULL:!MD5:!3DES"</p>
<p style="margin:0;font-family:'Courier New';font-size:11pt;">nginx['ssl_prefer_server_ciphers'] = "on"</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">Then run reconfig</p>
<p style="margin:0;font-family:'Courier New';font-size:11pt;">sudo gitlab-ctl reconfigure</p>
