# Introduction 
This is the infrastructure to my blog project.

More to come when the basic AKS and Cloudflare is integrated.

## Still early alpha
I know this is still early alpha so I have NOT attached a KeyVault to contain password, keys etc. I will do that when this become more stable, but for now I need to have a slim setup, so changes can propagate quickly.

# Getting Started

Supported providers:

1. Azure

# Azure installation
The first cloud provider I want this to run on is Azure. There should be implemented other providers in the future. I have chosen Azure because it is the provider I am most experienced with.

### Before deploying first time
Two things needs to be set up:

1. SSH key
2. Service Principal in Azure

#### SSH generate key
Generate the ssh key, if you don't have one yet

	ssh-keygen -t rsa -b 2048 

Cluster.SshRSAPublicKey should be set to the pubkey.

#### Service Principal
Remember to create a service principal

	az ad sp create-for-rbac --skip-assignment

Output is of the line

	{
	  "appId": "8b1ede42-d407-46c2-a1bc-6b213b04295f",
	  "displayName": "azure-cli-2019-04-19-21-42-11",
	  "name": "http://azure-cli-2019-04-19-21-42-11",
	  "password": "27e5ac58-81b0-46c1-bd87-85b4ef622682",
	  "tenant": "73f978cf-87f2-41bf-92ab-2e7ce012db57"
	}

Cluster.ServicePrincipalClientId should be set to appId and Cluster.ServicePrincipalClientSecret to password. This principal is valid for one year.

TODO: describe
1.	Software dependencies
2.	Latest releases
3.	API references

# Build, Deploy and Test

## Azure DevOps build
This is build through the tools/azureDevops/azure-pipelines.yml.

Two artifacts is produced:

1. bl0g.infrastructure.arm
2. bl0g.infrastructure.kubernetes.mainfests

One variable has to be set:

1. Build.ARM.Source.Path - where do the ARM templates reside? - could be set to: src/Bl0g.Infrastructure.Azure/Bl0g.Infrastructure.Azure

This variable has to be defined in a library called Bl0g.Infrastructure.Build.

## Release
There is no release script, and I am not going to write one. These things can be released in 1000 of ways. I want this to be as open as possible.

Disclaimer: I tried to do this, but the yaml release is not feature rich enough to do so. The things i did became to cumbersome. I therefore rely on the release designer in Azure DevOps. 

# Contribute
TODO: Explain how other users and developers can contribute to make code better. We need better code!