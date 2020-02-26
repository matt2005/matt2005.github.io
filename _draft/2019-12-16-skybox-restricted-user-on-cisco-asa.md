---
layout: post
title: "Skybox Restricted User on Cisco ASA"
date: 2019-12-16
tags: [Cisco,ASA,Skybox]
---

# Overview

Setup a restricted user to only allow use of specific commands by a user, this is also know as Least access principal.
This allows Skybox to work correctly and doesn't allow it to perform any additional tasks.

## Setup Privilege level

This is the main part that performs the restriction

```shell
privilege cmd level 5 mode exec command terminal
privilege show level 5 mode exec command running-config
privilege show level 5 mode exec command startup-config
privilege show level 5 mode exec command mode
privilege show level 5 mode exec command access-list
privilege show level 5 mode exec command pager
privilege show level 5 mode exec command route
privilege show level 5 mode exec command terminal
privilege show level 5 mode configure command route
```

## Setup User

This is where you assign the user to the privilege level

```shell
username restricteduser password NaNaNaNaNaN encrypted privilege 5

```

