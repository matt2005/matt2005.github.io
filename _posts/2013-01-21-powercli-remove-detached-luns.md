---
layout: post
title: PowerCLI Remove Detached LUN's
date: 2013-01-21 15:40
author: matt2005
comments: true
tags: [old blog, VMware]
---

Here is a quick draft post, will update later.

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
$counter = 0    # Initialize counter for progress bar
$hosts=get-vmhost
Foreach ($esxhost in $hosts)
{
$esxhostname=$esxhost.Name
Write-Progress -Activity "Connecting to ESX Host" -Status "Connecting to $esxhostname" -PercentComplete (100*($counter/$hosts.count))
$esxcli=get-esxcli -vmhost $esxhostname -ErrorAction SilentlyContinue
$detachedcounter=0
# Get storage devices that have status of off e.g. Offline/Dead
$detached=$esxcli.storage.core.device.List() | where {$_.Status -eq "off"}
IF ($detached -ne $null)
{
foreach ($device in $detached)
{
$deviceID=($device).Device
Write-Progress -Activity "Checking for Detached LUN's on $esxhostname" -Status "Checking $deviceID" -PercentComplete (50*($detachedcounter/$detached.count))
Start-sleep -s 2
$IsDetached=$null
#Check to ensure offline device is detached if so run loop
$IsDetached=$esxcli.storage.core.device.Detached.List($deviceID)
IF ($IsDetached -ne $null) {
Write-Progress -Activity "Removing Detached LUN's on $esxhostname" -Status "Removing $deviceID" -PercentComplete (100*($detachedcounter/$detached.count))
Start-sleep -s 2
Write-Host "Removing Detached LUN $deviceID from $esxhostname"
# Remove Detached device
$esxcli.storage.core.device.Detached.Remove($deviceID)
}
$detachedcounter++
}
Write-Progress -Activity "Rescanning Storage on $esxhostname" -Status "Rescanning..." -PercentComplete (150*($counter/$hosts.count))
# Rescan All HBA's on server, this is essential as the VI Client misreports the data until this has been done.
Get-VMHostStorage -VMHost $esxhostname -RescanAllHBA
Start-sleep -s 1
}
$esxhostname=$null
$counter++
}
```
