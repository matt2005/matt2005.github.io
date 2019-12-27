---
layout: post
title: "PowerCLI Remove not connected LUN's"
date: 2013-01-21 15:41
author: matt2005
comments: true
tags: [old blog, VMware]
---
Quick post, will update later

```powershell
#################################################
# Add Vmware Powercli snapin
If ((Get-PSSnapin "VMware.VimAutomation.Core" -ErrorAction SilentlyContinue) -eq $null) {
Add-PSSnapin "VMware.VimAutomation.Core"
}
#################################################
# Set Powercli Certification policy
Set-powercliconfiguration -InvalidCertificateAction Ignore -Confirm:$false | out-null
#################################################
#Connect to VIserver
$VIserver="MATTVISERVER"
Write-host "Connecting to $VIServer"
$server = Connect-VIServer -Server $VIServer -Protocol https
#################################################
# ESX Host
$vmhost="MATTESXHOST"
#################################################
# Connect to esxcli for $vmhost
$esxcli=get-esxcli -vmhost $vmhost
# List storage devices that are status not connected
$detached=$esxcli.storage.core.device.List() | where {$_.Status -eq "not connected" -and $_.Vendor -eq "NETAPP"}
Foreach ($lun in $detached) {
$device_id=$lun.Device
# Force device to be administratively offline
$esxcli.storage.core.device.set($device_id,"IsOffline",$null,"off")
# Force device to be administratively online
$esxcli.storage.core.device.set($device_id,"IsOffline",$null,"on")
# Rescan All HBA's
Get-VMHostStorage -VMHost $vmhost -RescanAllHBA
}
```
