---
layout: post
title: "SQL Fails to start after SSL cert install"
date: 2017-01-06 12:19
author: matt2005
comments: true
tags: [old blog, needs content checking Nessus, Security, Self-signed Certificate, SQL, SSL, Windows]
---
<p style="line-height:15pt;font-family:Arial;font-size:10.5pt;color:#333333;margin:0 0 6pt;">I came into this issue when i was resolving Nessus Vulnerability.</p>

<h2 class="vuln-title" title="Plugin Name: SSL Self-Signed Certificate, Plugin ID: 57582">SSL Self-Signed Certificate (57582)</h2>
<p style="line-height:15pt;font-family:Arial;font-size:10.5pt;color:#333333;margin:0 0 6pt;">I generated a proper cert using the webserver templatye for my internal CA and used the FQDN as the Subject. Imported the cert and applied it via SQL configuration manager, then restarted SQL. Sometimes it started but failed to accept connections, other is wouldn't start.</p>
<p style="line-height:15pt;font-family:Arial;font-size:10.5pt;color:#333333;margin:0 0 6pt;"><span style="background:white;">Windows could not start the SQL Server (%</span><span style="font-style:italic;background:white;">sqlserverninstancename</span><span style="background:white;">%) on Local Computer. For more information, review the System Event Log. If this is a non-Microsoft service, contact the service vendor, and refer to service-specific error code - 2146885628</span></p>

<ol style="margin-left:.375in;direction:ltr;unicode-bidi:embed;margin-top:0;margin-bottom:0;font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;" type="1">
	<li style="margin-top:0;margin-bottom:0;vertical-align:middle;line-height:13pt;color:#333333;" value="1"><span style="font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;background:white;">First we need to find the name of the service account used by the instance of SQL Server. It will probably be something like ‘SQLServerMSSQLUser$[Computer_Name]$[Instance_Name]‘.</span></li>
</ol>
<ol style="margin-left:.375in;direction:ltr;unicode-bidi:embed;margin-top:0;margin-bottom:0;font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;" type="1">
	<li style="margin-top:0;margin-bottom:0;vertical-align:middle;line-height:13pt;color:#333333;" value="2"><span style="font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;background:white;">One way to do this is to navigate to the installation directory or your SQL Instance. By default SQL Server is installed at C:\Program Files\Microsoft SQL Server\MSSQL10_50.InstanceName.</span></li>
	<li style="margin-top:0;margin-bottom:0;vertical-align:middle;line-height:13pt;color:#333333;"><span style="font-family:Arial;font-size:10.5pt;background:white;">Right click on the MSSQL folder and click Properties.</span></li>
</ol>
<ol style="margin-left:.375in;direction:ltr;unicode-bidi:embed;margin-top:0;margin-bottom:0;font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;" type="1">
	<li style="margin-top:0;margin-bottom:0;vertical-align:middle;line-height:13pt;color:#333333;" value="4"><span style="font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;background:white;">Click the Security tab and write down the user in the Group or user names window that matches the pattern of ‘SQLServerMSSQLUser$[Computer_Name]$[Instance_Name]‘.</span></li>
	<li style="margin-top:0;margin-bottom:0;vertical-align:middle;line-height:13pt;color:#333333;"><span style="font-family:Arial;font-size:10.5pt;background:white;">Now, open the Microsoft Management Console (MMC) by click Start -&gt; Run, entering mmc and pressing Enter.</span></li>
	<li style="margin-top:0;margin-bottom:0;vertical-align:middle;line-height:13pt;color:#333333;"><span style="font-family:Arial;font-size:10.5pt;background:white;">Add the Certificates snap-in by clicking File -&gt; Add/Remove Snap-in… and double clicking the Certificates item (Note: Select computer account and Local computer in the two pages on the wizard that appears.</span></li>
	<li style="margin-top:0;margin-bottom:0;vertical-align:middle;line-height:13pt;color:#333333;"><span style="font-family:Arial;font-size:10.5pt;background:white;">Click Ok.</span></li>
</ol>
<ol style="margin-left:.375in;direction:ltr;unicode-bidi:embed;margin-top:0;margin-bottom:0;font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;" type="1">
	<li style="margin-top:0;margin-bottom:0;vertical-align:middle;line-height:13pt;color:#333333;" value="8"><span style="font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;background:white;">Expand Certificates (Local Computer) -&gt; Personal -&gt; Certificates and find the SSL certificate you imported.</span></li>
</ol>
<ol style="margin-left:.375in;direction:ltr;unicode-bidi:embed;margin-top:0;margin-bottom:0;font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;" type="1">
	<li style="margin-top:0;margin-bottom:0;vertical-align:middle;line-height:13pt;color:#333333;" value="9"><span style="font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;background:white;">Right click on the imported certificate (the one you selected in the SQL Server Configuration Manager) and click All Tasks -&gt; Manage Private Keys…</span></li>
</ol>
<ol style="margin-left:.375in;direction:ltr;unicode-bidi:embed;margin-top:0;margin-bottom:0;font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;" type="1">
	<li style="margin-top:0;margin-bottom:0;vertical-align:middle;line-height:13pt;color:#333333;" value="10"><span style="font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;background:white;">Click the Add… button under the Group or user names list box.</span></li>
</ol>
<ol style="margin-left:.375in;direction:ltr;unicode-bidi:embed;margin-top:0;margin-bottom:0;font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;" type="1">
	<li style="margin-top:0;margin-bottom:0;vertical-align:middle;line-height:13pt;color:#333333;" value="11"><span style="font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;background:white;">Enter the SQL service account name that you copied in step 4 and click OK.</span></li>
</ol>
<ol style="margin-left:.375in;direction:ltr;unicode-bidi:embed;margin-top:0;margin-bottom:0;font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;" type="1">
	<li style="margin-top:0;margin-bottom:0;vertical-align:middle;line-height:13pt;color:#333333;" value="12"><span style="font-family:Arial;font-size:10.5pt;font-weight:normal;font-style:normal;background:white;">By default the service account will be given both Full control and Read permissions but it only needs to be able to Read the private key. Uncheck the Allow Full Control option.</span></li>
	<li style="margin-top:0;margin-bottom:0;vertical-align:middle;line-height:13pt;color:#333333;"><span style="font-family:Arial;font-size:10.5pt;background:white;">Click OK.</span></li>
	<li style="margin-top:0;margin-bottom:0;vertical-align:middle;line-height:13pt;color:#333333;"><span style="font-family:Arial;font-size:10.5pt;background:white;">Close the MMC and restart the SQL service.</span></li>
</ol>
