# ansible-molecule-drivers
Molecule drivers for cloud providers

Currently the list of included drivers is the following:
* AWS
* EPC
* WINRM

## AWS

AWS driver playbooks are set to be used in AWS environment for molecule tests executed by gitlab-runner. 

They support only scenarios for Linux instances accessed through SSH. 

Gitlab-runner with tag `aws` required to run these tests.

## WINRM

WINRM driver playbooks are set to be used in AWS environment for the same purpose as above for Windows instances.

But they use another connection transport - WinRM, thus separate driver is required to run molecule tests. 

You need molecule not earlier than version 2.20 to be able to run such tests.

Gitlab-runner with tag `aws` required to run these tests.

## EPC

EPC driver playbooks are required to run molecule test within EPAM Cloud using internal EPC cloud modules. 

These tests can be run only using private gitlab-runner with tag `delegated`.
