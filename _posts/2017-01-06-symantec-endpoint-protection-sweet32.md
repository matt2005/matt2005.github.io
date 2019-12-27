---
layout: post
title: "Symantec Endpoint Protection - Sweet32"
date: 2017-01-06 12:28
author: matt2005
comments: true
tags: [old blog, needs content checking Nessus, Security, SWEET32, Symantec Endpoint Protection]
---
<p style="margin:0;font-family:Calibri;font-size:11pt;">To resolve Nessus vulnerabilities below</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">42873 SSL Medium Strength Cipher Suites Supported</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">94437 SSL 64-bit Block Size Cipher Suites Supported (SWEET32)</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">Edit the following files</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">"C:\Program Files (x86)\Symantec\Symantec Endpoint Protection Manager\apache\conf\ssl\ssl.conf"</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">"C:\Program Files (x86)\Symantec\Symantec Endpoint Protection Manager\apache\conf\ssl\sslForClients.conf"</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">From:</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">SSLCipherSuite HIGH:!MEDIUM:!LOW:!aNULL:!eNULL:3DES:!RC4</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">To:</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">SSLCipherSuite  <span style="font-weight:bold;">HIGH:!aNULL:!MD5:!3DES:!CAMELLIA:!AES128</span></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">Edit</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">"C:\Program Files (x86)\Symantec\Symantec Endpoint Protection Manager\tomcat\conf\server.xml"</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">Edit SSLCipherSuite to</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">HIGH:!aNULL:!MD5:!3DES:!CAMELLIA:!AES128</p>
