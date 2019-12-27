---
layout: post
title: "Imperva DB monitoring"
date: 2017-01-06 12:11
author: matt2005
comments: true
tags: [old blog, needs content checking Imperva, Security, SSL, Windows]
---
<p style="margin:0;font-family:Calibri;font-size:11pt;">Imperva Db monitor cannot decrypt data</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"></p>
<p style="margin:0;font-family:Calibri;font-size:11pt;">The below is required as Imperva cannot decrypt ECDH or DH Algorithms</p>
<p style="margin:0;font-family:Calibri;font-size:11pt;"> The below is to be run on the SQL server</p>

<pre style="margin:0;font-family:Calibri;font-size:11pt;">Powershell to disable DH, ECDH

# Disable Diffie-Hellman and ECDH

md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\ECDH"

Set-ItemProperty -Path "HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\ECDH" -Name Enabled -Value 0 -Force

md "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\Diffie-Hellman"

Set-ItemProperty -Path "HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\Diffie-Hellman" -Name Enabled -Value 0

 

# Cipher Suite Order, this may be overridden by group policy

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002" -Name "Functions" -value "TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_3DES_EDE_CBC_SHA"</pre>
