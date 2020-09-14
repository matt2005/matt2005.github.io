---
layout: post
title: "FireEye Agent Stopped"
date: 2020-09-14
tags: [FireEye,Error: 65548,Error: 1738]
---

FireEye Agent Stopped and will not restart.

# Index

* TOC
{:toc}

# Issue

Configuration File invalid when trying the upgrade/reinstall, agent stpped and will not start and

PS C:\Program Files (x86)\FireEye\xagt> .\xagt.exe --cfg-export 'C:\Install\export.cfg'
Error: 65548

# Resolution

Need to rename C:\ProgramData\FireEye\xagt

```powershell
Move-Item "C:\ProgramData\FireEye\xagt" "xagt.old"
```

Then run  (This will error with Error 1738) but it will re-create the xagt folder

```powershell
& "C:\Program Files (x86)\FireEye\xagt\xagt.exe" --cfg-export 'C:\Install\Export.cfg'
```

Then import the config from the installation media or from an exported working configuration from another server.
```powershell
& "C:\Program Files (x86)\FireEye\xagt\xagt.exe" --cfg-import 'C:\Install\GoodConfig.cfg'
```
OR
```powershell
& "C:\Program Files (x86)\FireEye\xagt\xagt.exe" --cfg-import 'C:\Install\agent_config.json'
```