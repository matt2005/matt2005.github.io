---
layout: post
title: "Fix Splunk Nessus SSL Vulnerabilities"
date: 2017-01-06 12:08
author: matt2005
comments: true
tags: [old blog, needs content checking CRIME, Nessus, Security, Splunk, SSL, SWEET32]
---
<p style="margin:0;font-family:Calibri;font-size:11pt;">To Resolve the following Nessus Vulernabilites</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">20007 SSL Version 2 and 3 Protocol Detection</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">42873 SSL Medium Strength Cipher Suites Supported</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">62565 Transport Layer Security (TLS) Protocol CRIME Vulnerability</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">94437 SSL 64-bit Block Size Cipher Suites Supported (SWEET32)</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">Add the following to "C:\Program Files\SplunkUniversalForwarder\etc\system\local\server.conf"</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">[sslConfig]</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">allowSslCompression = false</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">useClientSSLCompression = false</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">sslVersions = tls1.1, tls1.2</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">sslVersionsForClient = tls1.1, tls1.2</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">cipherSuite = HIGH:!aNULL:!MD5:!3DES:!CAMELLIA:!AES128</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">Add the following to "C:\Program Files\SplunkUniversalForwarder\etc\system\local\inputs.conf"</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">[SSL]</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">cipherSuite = HIGH:!aNULL:!MD5:!3DES:!CAMELLIA:!AES128</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">allowSslCompression = false</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">useClientSSLCompression = false</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">Restart SplunkUniversalForwarder service</p>
