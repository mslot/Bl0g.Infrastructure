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
Quick intro:

1. Cd into Bl0g.Infrastructure\tools\local
2. apply .env file
3. Run InfraCtrl.ps1

For a more indept intro, read the two secions below, Bl0g.Migrations and docker-compose.

### Bl0g.Migrations
If you want to run the migrations project for it self add a appsettings.local.json to Bl0g.Migrations.Console. An example could be:

	{
	  "CONNECTION_STRING": "Server=[database ip or docker name];User Id=sa;Password=[password];Connection Timeout=60;Database=Bl0g",
	  "CREATE_DATABASE_CONNECTION_STRING": "Server=[database ip or docker name];User Id=sa;Password=[password];Connection Timeout=60",
	  "DATABASE_NAME": "Bl0g"
	}

Set the username and password to what you applied when running the SetUpDockerInfrastructure.ps1.

If you want to run it in a docker instance, remember to set this in the csproj file:

	<PropertyGroup>
   		<DockerfileRunArguments>--network bl0g_network</DockerfileRunArguments>
	</PropertyGroup>

This has been set in the in the Bl0g.Migrations.Console csproj file. If you want another network, then remember to change it before running it from Visual Studio. This network is created by the docker-compose file.

If you want to run it as a normal console application, apply the docker host ip.

### docker-compose
Cd into Bl0g.Infrastructure\tools\local and apply some environment variables, either by your commandline directly, or by an .env file. A .env file could look like this:

	STORAGE_CONNECTION_STRING=DefaultEndpointsProtocol=https;AccountName=[name];AccountKey=[key];EndpointSuffix=core.windows.net
	ENVIRONMENT=LOCAL
	CREATE_DATABASE_CONNECTION_STRING=Server=database;User Id=sa;Password=MySuperSecretPassword123@;Connection Timeout=30
	DATABASE_CONNECTION_STRING=Server=database;User Id=sa;Password=MySuperSecretPassword123@;Connection Timeout=30;	Database=Bl0g
	DATABASE_IDENTIFIER=SqlServer2016
	DATABASE_PASSWORD=MySuperSecretPassword123@
	DATABASE_NAME=Bl0g

Now you can run InfraCtrl.ps1 which asks for a question, what the uri of content api is, copy the config into the SPA and runs docker-compose up, if nothing else is specified. It only sets the content api once pr terminal session (it uses an environment variable to check if config has already been copied).

Remember some variables is duplicated into the connection strings. There is two connection strings

1. CREATE_DATABASE_CONNECTION_STRING
2. CONNECTION_STRING

1) is without the database name. 2) is with database name.

The first us used to create the database if not present. Number two is used to apply the migrations.

Both SQL connection strings needs a decent timeout, i always set it to 30 seconds, because the database has to be spun up and ready. Even though the migrations depends on the database in docker-compose, this isn't strictly true. It only means the database needs to be started, BEFORE the migrations. It doesn't wait for the database container to be ready.

For now, the migrations project only supports MSSQL Server. Moreover it assumes that the database of the SQL compliant server can be created with:

	CREATE Database '[name]'

#### Add another database
The DATABASE_IDENTIFIER environment variable in the migrations service should match the identifier column in the list provided by FluentMigrator: https://fluentmigrator.github.io/articles/multi-db-support.html (look under Supported databases). For now I have only added support for SqlServer2016, but it should be pretty esasy to extend this if other types of databases is needed.

The only caveat is that the migrations project uses SQL to create the database if not present. This part should be updated if the database that is switched doesn't support the flavor of the create statement. I am certain that the database check is pretty SqlServer specific and needs to be changed if database is changed. This should be pretty straight forward to do, I think. The relevant code is in the Bl0g.Migrations.Console project. I have also added an exception that throws if the identifier doesnt container "SqlServer" for the database creation part.

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
