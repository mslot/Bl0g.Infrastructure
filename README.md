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

## Run local
To run the platform local, you need to clone all projects down, to a single folder. Name all projects after the repo.

Remember to run docker-compose build first!!

### Bl0g.Migrations
If you want to run the migrations project for it self add a appsettings.local.json to Bl0g.Migrations.Console. An example could be:

	{
	  "CONNECTION_STRING": "Server=[database ip or docker name];User Id=sa;Password=[password];Connection Timeout=60",
	  "DATABASE_NAME": "Bl0g"
	}

Set the username and password to what you applied when running the SetUpDockerInfrastructure.ps1.

If you want to run it in a docker instance, remember to set 

	<PropertyGroup>
   		<DockerfileRunArguments>--network bl0g_network</DockerfileRunArguments>
	</PropertyGroup>

in the Bl0g.Migrations.Console csproj file. This network is created by the docker-compose file.

If you want to run it as a normal console application, apply the docker host ip.

### docker-compose
Cd into Bl0g.Infrastructure\tools\local and run SetUpDockerInfrastructure.ps1. Apply same username, database name and password. This script will create two connectionstring that is passed to docker-compose to do migrations and setup of the database:

1. CREATE_DATABASE_CONNECTION_STRING
2. CONNECTION_STRING

1) is without the database name. 2) is with database name.

Both SQL connection strings has a timeout for 30 seconds.

It also passes on the database name, so it can create it. 

For now, the migrations project only supports MSSQL Server. Moreover it assumes that the database of the SQL compliant server can be created with:

	CREATE Database '[name]'

*REMEMBER* that the setup script is only a help. You can do your own if needed.

Please be aware that the User Id should always be sa because of how MSSQL is setup in docker. Remember username and password.

### browse your site
Go to https://localhost:6000 and see the site.

REMEMBER, if you run "docker system prune", it will delete your database, so use this only for test.

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