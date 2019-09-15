# Still early alpha
I know this is still early alpha so I have NOT attached a KeyVault to contain password, keys etc. I will do that when this become more stable, but for now I need to have a slim setup, so changes can propagate quickly.

# Azure
Code for setting up the infrastructure in Azure

# Before deploying first time
## SSH generate key
Generate the ssh key, if you don't have one yet

	ssh-keygen -t rsa -b 2048 

Cluster.SshRSAPublicKey should be set to the pubkey.

## Service Principal
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
