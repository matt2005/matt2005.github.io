---
layout: post
title: SSRS Subscription Auth Error
date: 2015-12-23 16:14
author: matt2005
comments: true
tags: [old blog, Uncategorized]
---
I recently moved some SSRS subscriptions between domains, there is a oneway trust between them, however when publishing a report to the desination domain using a user in the source domain the subscription errors with the following.

library!WindowsService_0!182c!12/23/2015-10:34:13:: e ERROR: Throwing Microsoft.ReportingServices.Diagnostics.Utilities.ServerConfigurationErrorException: AuthzInitializeContextFromSid: Win32 error: 5; possible reason - service account doesn't have rights to check domain user SIDs., Microsoft.ReportingServices.Diagnostics.Utilities.ServerConfigurationErrorException: The report server has encountered a configuration error. ;

This is happens because SSRS needs to verify the subscription owner's access to the report prior to generating and sending it. This error occurrs when you choose Windows  File Share or Send e-Mail option. As the source domain didn't trust the destination domain that it why this failed.

However a fix bit of SQL to fix up the Subscription owner was all that was needed.

The SQL below will set the owner to be "NT Authority\System" to all subscriptions
<div>

<span style="color:#0000ff;font-size:small;">Use</span><span style="font-size:small;"> ReportServer</span>
Go
<span style="color:#0000ff;font-size:small;">Declare</span><span style="font-size:small;"> @System </span><span style="color:#0000ff;font-size:small;">as</span> <span style="color:#0000ff;font-size:small;">varchar </span><span style="color:#808080;font-size:small;">(</span><span style="font-size:small;">200</span><span style="color:#808080;font-size:small;">)
</span><span style="color:#0000ff;font-size:small;">Select</span><span style="font-size:small;"> @System</span><span style="color:#808080;font-size:small;">=(</span><span style="color:#0000ff;font-size:small;">Select</span><span style="font-size:small;"> UserId </span><span style="color:#0000ff;font-size:small;">from</span><span style="font-size:small;"> Users </span><span style="color:#0000ff;font-size:small;">where</span><span style="font-size:small;"> UserName</span><span style="color:#808080;font-size:small;">=</span> <span style="color:#ff0000;font-size:small;">'NT AUTHORITY\SYSTEM'</span><span style="color:#808080;font-size:small;">)
</span><span style="color:#0000ff;font-size:small;">--Select</span> <span style="color:#808080;font-size:small;">*</span> <span style="color:#0000ff;font-size:small;">from</span><span style="font-size:small;"> dbo</span><span style="color:#808080;font-size:small;">.</span><span style="font-size:small;">Subscriptions </span><span style="color:#0000ff;font-size:small;">where</span><span style="font-size:small;"> OwnerID </span><span style="color:#808080;font-size:small;">&lt;&gt;</span><span style="font-size:small;"> @System
</span><span style="color:#0000ff;font-size:small;">Update</span><span style="font-size:small;"> dbo</span><span style="color:#808080;font-size:small;">.</span><span style="font-size:small;">Subscriptions </span><span style="color:#0000ff;font-size:small;">set</span><span style="font-size:small;"> OwnerID</span><span style="color:#808080;font-size:small;">=</span><span style="font-size:small;">@System </span><span style="color:#0000ff;font-size:small;">where</span><span style="font-size:small;"> OwnerID </span><span style="color:#808080;font-size:small;">&lt;&gt;</span><span style="font-size:small;"> @System</span>

</div>
I hope this can help others :)

&nbsp;
