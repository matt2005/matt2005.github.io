---
layout: post
title: "Spiceworks - SWEET32"
date: 2017-01-06 12:25
author: matt2005
comments: true
tags: [old blog, needs content checking Nessus, Security, Spiceworks, SWEET32]
---
<p style="margin:0;font-family:Calibri;font-size:11pt;">To resolve Nessus Vulnerabilities</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">42873 SSL Medium Strength Cipher Suites Supported</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">94437 SSL 64-bit Block Size Cipher Suites Supported (SWEET32)</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
Edit "C:\Program Files (x86)\Spiceworks\httpd\conf\httpd.conf"

Replace

SSLCipherSuite ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA

With

SSLCipherSuite HIGH:!aNULL:!MD5:!3DES
