param (
    [string]$database_username = $( Read-Host "Database user (press enter for default sa)"),
    [string]$database_name = $( Read-Host "Database name (press enter for default Bl0g)"),
    [Security.SecureString]$database_password = $( Read-Host -AsSecureString "Database password" )
 )

 if(!$database_username)
 {
     $database_username="sa";
 }
 if(!$database_name) 
 {
     $database_name="Bl0g";
 }
 
 # I know this is bad practice but my powershell Foo isn't that good, and I don't what else to do
 $database_password_decrypted = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($database_password))

# this creates a network that is used when spinning up individual containers when testing in Visual Studio.
# projects interacting with fx storage, should have this
#
#<PropertyGroup>
#   <DockerfileRunArguments>--network bl0g_network</DockerfileRunArguments>
#</PropertyGroup>
#
# in their csproj. Also remember to start Azurite:
#
#    docker run -p 10000:10000 -p 10001:10001 --network bl0g_network --name azure_storage mcr.microsoft.com/azure-storage/azurite azurite --blobHost 0.0.0.0 --queueHost 0.0.0.0 
# 
# and remember to point it to the network (as it is done above)

# docker network create bl0g_network

# Default storage system used by azure functions.
# To read more about it, visit: https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azurite
#
# Unomment out if you have no preference for test storage:
# docker run -p 10000:10000 -p 10001:10001 --network test --name azure_storage mcr.microsoft.com/azure-storage/azurite azurite --blobHost 0.0.0.0 --queueHost 0.0.0.0 
#
# This creates a container named azure_storage for other azure functions to use. Remember to start it after system reboot.

# Now we want to run start all docker containers locally.
# First we run the docker-compose up.

 $env:DATABASE_PASSWORD=$database_password_decrypted;$env:DATABASE_USER=$database_username;$env:DATABASE_NAME=$database_name;docker-compose up

# Be aware of the fact that MSSQL takes a bit to start, so for the connectionstring for the migrations, configure it with a long timeout (30 sec default).
# Be aware that the connection string for migrations is a connectionstring without the database name in it. This is appended to the connectionstring after the creation of the database.