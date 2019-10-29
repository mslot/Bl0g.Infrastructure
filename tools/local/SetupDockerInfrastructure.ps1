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

docker network create bl0g_network

# Default storage system used by azure functions.
# To read more about it, visit: https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azurite
#
# Unomment out if you have no preference for test storage:
# docker run -p 10000:10000 -p 10001:10001 --network test --name azure_storage mcr.microsoft.com/azure-storage/azurite azurite --blobHost 0.0.0.0 --queueHost 0.0.0.0 
#
# This creates a container named azure_storage for other azure functions to use. Remember to start it after system reboot.
