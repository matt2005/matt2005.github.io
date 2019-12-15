---
layout: post
title: A Good Module
date: 2019-12-15
tags: [PowerShell,PSScriptAnalyzer,Plaster,Invoke-Build,Pester,Jenkins]
---

# Background

Over the last few years I've build a module pipeline using Plaster, Invoke-Build, PSScriptAnalyzer, Pester and Jenkins. Here is my Plaster template [PlasterTemplateRepo]

Recently I've been slowly pulling out various parts of the module in to separate repos as I found I was updating several modules with the sames files when I changed the base module.

I know I can just re-plaster the template over the top but I was looking for a solution to make this a automated step as part of the pipeline.

# Plaster Template overview

The plaster template was written to create a standard module structure, it has grown over several years and it still growing.

Each module is built using a Plaster template.

Each Module pulls a repository that contains a set of tests to ensure that the module has all the basic requirements for a good module.

## A 'Good' Module

I've defined a good module as:

* Code Coverage > 60%
* Has at least 1 public function
* Must pass PSScriptAnalyzer
* Each public function must have help
* Each public function must have an example
* Every parameter must exist in help
* Every file must be UTF-8

# Generic Test Suite

I have defined this 'Generic Test Suite' in a set of Pester tests which are run before any other test in the pipeline.

The 'Generic Test Suite' is not included in each module but are pulled from the repository each time it is build, this enabled me to fix tests and add new ones without having to update every module.

The downfall to this approach is that I may add a test that causes some modules to fail on the next build.

I have decided that this is the expected outcome as I will only be using the Generic Test Suite for tests that are required to meet the Good Module requirements as detailed above.

## Tests

Here is the [GenericTestSuiteRepo] for all the tests.


```powershell
# To Be Added
````

[PlasterTemplateRepo]: https://github.com/matt2005/PlasterTemplate
[GenericTestSuiteRepo]: https://github.com/matt2005/GenericTestSuite
