---
layout: post
title: "A Good Module"
date: 2019-12-15
tags: [PowerShell,PSScriptAnalyzer,Plaster,Invoke-Build,PSDepend,Pester,Jenkins,DRAFT]
---

DRAFT - Not complete - in progress
# Background

Over the last few years I've build a module pipeline using Plaster, Invoke-Build, PSDepend, PSScriptAnalyzer, Pester and Jenkins. 

Recently I've been slowly pulling out various parts of the module in to separate repos as I found I was updating several modules with the sames files when I changed the base module.

I know I can just re-plaster the template over the top but I was looking for a solution to make this a automated step as part of the pipeline.

This post will detail the Generic Test Suite part of the plaster template.

# A 'Good' Module

I've defined a good module as:

* Code Coverage > 60%
* Has at least 1 public function
* Must pass PSScriptAnalyzer
* Each public function must have help
* Each public function must have an example
* Every parameter must exist in help
* Every file must be UTF-8

# Plaster Template Overview

Plaster is a template-based file and project generator written in PowerShell.

For more details see [Plaster]

## Plaster Template details

The plaster template was written to create a standard module structure, it has grown over several years and it still growing.

Each module is built using a Plaster template.

Each Module pulls a repository that contains a set of tests to ensure that the module has all the basic requirements for a good module.

[PlasterTemplateRepo]

# Generic Test Suite

I have defined this 'Generic Test Suite' in a set of Pester tests which are run before any other test in the pipeline.

The 'Generic Test Suite' is not included in each module but are pulled from the repository each time it is build, this enabled me to fix tests and add new ones without having to update every module.

The downfall to this approach is that I may add a test that causes some modules to fail on the next build.

I have decided that this is the expected outcome as I will only be using the Generic Test Suite for tests that are required to meet the Good Module requirements as detailed above.

## Tests

Here is the [GenericTestSuiteRepo] for all the generic tests.

These tests check the following:

* File Encoding is UTF-8
* Public Functions have Help
* Module Manifest is valid
* Exports are correct
* Files are Signed


# PSDepend

This is a simple PowerShell dependency handler. You might loosely compare it to bundle install in the Ruby world or pip install -r requirements.txt in the Python world.

PSDepend allows you to write simple requirements.psd1 files that describe what dependencies you need, which you can invoke with Invoke-PSDepend

For more details see [PSDepend]

# Invoke-Build

Invoke-Build is a build and test automation tool.
For more details see [Invoke-Build]

## Invoke-Build Tasks

# Jenkins Pipeline

For more details see [Jenkins]

## Stages

### Clean

This stage prepares the environment. It uses PSDepend to install requirements to the artifact folder in the repo.

### Analyse

This stage runs PSScriptAnalyzer

### BuildPS1M

This Stage builds the separated ps1 files into a single PSM1

### Test

This Stage first runs the Generic test suite then it will run the tests for the module functions.

### Archive

This stage archives the build artifact and test results to Jenkins

### Publish

This Stage publishes the PowerShell module to the nuget repository.

# VScode

I've added vscode tasks to assist with local development.
Each Pipeline Stage is mapped to a VScode task.

This to run the tests locally all I need to do is ctrl+p and type:

```shell
task test
```

## Tasks


[Invoke-Build]: https://github.com/nightroman/Invoke-Build
[PSDepend]: https://github.com/RamblingCookieMonster/PSDepend
[Plaster]: https://github.com/PowerShell/Plaster
[Jenkins]: https://jenkins.io
[PlasterTemplateRepo]: https://github.com/matt2005/PlasterTemplate
[GenericTestSuiteRepo]: https://github.com/matt2005/GenericTestSuite

