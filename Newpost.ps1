[cmdletbinding()]
param(
    [string]$path = "$pwd\_draft\",
	[string]$title,
	[string[]]$tags
)
$date=(Get-Date -Format "yyyy-MM-dd")
$template = @'
---
layout: post
title: {0}
date: {1}
tags: [{2}]
---
'@ 

$output = $template -f $title, $date, ($tags -join ',')
$file = ('{0}\{1}.md' -f $path,$('{0}-{1}' -f $date,$($title -replace ' ','-'))).tolower()
$output | Set-Content -Path $file 