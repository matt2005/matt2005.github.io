---
layout: post
title: "VMware ESX Imagebuilder"
date: 2012-09-20 12:35
author: matt2005
comments: true
tags: [old blog, VMware]
---
# HP Esxi Imagebuilder

Here are some instructions to build a esxi image using imagebuilder

## Instructions

1. Install VMware PowerCli
2. Run the following in an elevated powershell prompt

```powershell
# Add ESXi 5 Base Software Depot
Add-EsxSoftwareDepot -DepotUrl C:\Install\ESXi\ESXi500-201111001.zip
# Add ESXi 5 update 01 Software Depot
Add-EsxSoftwareDepot -DepotUrl C:\Install\ESXi\update-from-esxi5.0-5.0_update01.zip
# Add HP's Online Depot to get access to all of HP's Software Packages
Add-EsxSoftwareDepot http://vibsdepot.hp.com/index.xml
# Add HP Bundle
Add-EsxSoftwareDepot -DepotUrl C:\Install\ESXi\hp-esxi5.0uX-bundle-1.1.2-4.zip
# Add HP Smart Array
Add-EsxSoftwareDepot -DepotUrl C:\Install\ESXi\hpsa-500-5.0.0-offline_bundle-537239.zip
# Vars used to set the ESXi image profile name, basically just a time stamped name
$DATESTAMP=get-date -Format yyy.M.d
$PROFILEAME="ESXi5U1-HP_$DATESTAMP"
# Sort the image profiles from VMware's online depot to get the latest image profile
$ImageProfiles = Get-EsxImageProfile | Where-Object {$_.name -like "*standard*"} | Sort-Object "ModifiedTime" -Descending
# Create a copy of the latest image profile from VMware's online depot
IF ($ImageProfile -gt "1"){New-EsxImageProfile -CloneProfile $imageprofiles[0] -name $PROFILEAME}
IF ($ImageProfile -le "1"){New-EsxImageProfile -CloneProfile $imageprofiles -name $PROFILEAME}

# Add the HP related packages to the our new image profile
Get-EsxSoftwarePackage -vendor "Hewlett-Packard" | Add-EsxSoftwarePackage -ImageProfile $PROFILEAME
Get-EsxSoftwarePackage -vendor "hp" | Add-EsxSoftwarePackage -ImageProfile $PROFILEAME
# Add qlogic driver
Add-EsxSoftwareDepot -DepotUrl C:\Install\ESXi\qla2xxx-911.k1.1-offline_bundle-531155.zip
Add-EsxSoftwarePackage -ImageProfile $PROFILEAME -SoftwarePackage "scsi-qla2xxx 911.k1.1-19vmw.500.0.0.472560"
# Add Broadcom driver
Add-EsxSoftwareDepot -DepotUrl C:\Install\ESXi\tg3-3.120h.v50.2-offline_bundle-547149.zip
Add-EsxSoftwarePackage -ImageProfile $PROFILEAME -SoftwarePackage net-tg3
# Export the image profile to a bundle file
Export-EsxImageProfile -ImageProfile $PROFILEAME -ExportToBundle -FilePath C:\Install\ESXi\$PROFILEAME.zip
# Export the image profile to an ISO image
Export-EsxImageProfile -ImageProfile $PROFILEAME -ExportToISO -FilePath C:\Install\ESXi\$PROFILEAME.iso</div>
```

# Extra Notes

## HP Online Depot

```powershell
Add-EsxSoftwareDepot -DepotUrl http://vibsdepot.hp.com/index.xml
```
