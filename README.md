# ansible-molecule-drivers
==========================

[![License](https://img.shields.io/badge/license-Apache-green.svg?style=flat)](https://raw.githubusercontent.com/lean-delivery/ansible-molecule-drivers/master/LICENSE)
[![Build Status](https://gitlab.com/lean-delivery/ansible-molecule-drivers/badges/master/build.svg)](https://gitlab.com/lean-delivery/ansible-molecule-drivers/pipelines)

Molecule drivers for cloud providers

Currently the list of included drivers is the following:
* AWS
* AZURE
* EPC
* WINRM

## AWS

AWS driver playbooks are set to be used in AWS environment for molecule tests executed by gitlab-runner. 

They support scenarios for both Linux and Windows instances accessed through SSH or WinRM. 

Gitlab-runner with tag `aws` required to run these tests.

## AZURE

Azure driver playbooks are set to be used in Azure environment for molecule tests executed by gitlab-runner. 

They support scenarios for both Linux and Windows instances accessed through SSH or WinRM. 

Gitlab-runner with tag `azure` required to run these tests.

## WINRM (Deprecated)

WINRM driver playbooks are set to be used in AWS environment for the same purpose as above for Windows instances.

But they use another connection transport - WinRM, thus separate driver is required to run molecule tests. 

You need molecule not earlier than version 2.20 to be able to run such tests.

Gitlab-runner with tag `aws` required to run these tests.

## EPC

EPC driver playbooks are required to run molecule test within EPAM Cloud using internal EPC cloud modules. 

These tests can be run only using private gitlab-runner with tag `delegated`.
