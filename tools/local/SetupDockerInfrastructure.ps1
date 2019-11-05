param (
    [string]$database_identifier = $( Read-Host "Database type (press enter for SqlServer)"),
    [string]$database_username = $( Read-Host "Database user (press enter for default sa)"),
    [string]$database_name = $( Read-Host "Database name (press enter for default Bl0g)"),
    [Security.SecureString]$database_password = $( Read-Host -AsSecureString "Database password" )
 )

 if(!$database_identifier)
 {
    $database_identifier="SqlServer2016";
 }
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

# Now we want to run start all docker containers locally.
# First we run the docker-compose up.

$create_database_connection_string  = "Server=database;User Id=$database_username;Password=$database_password_decrypted;Connection Timeout=30"
$connection_string                  = "Server=database;User Id=$database_username;Password=$database_password_decrypted;Connection Timeout=30;Database=$database_name"

$env:DATABASE_IDENTIFIER=$database_identifier;$env:CREATE_DATABASE_CONNECTION_STRING=$create_database_connection_string;$env:DATABASE_NAME=$database_name;$env:DATABASE_PASSWORD=$database_password_decrypted;$env:DATABASE_CONNECTION_STRING=$connection_string;docker-compose up

# Be aware of the fact that MSSQL takes a bit to start, so for the connectionstring for the migrations, configure it with a long timeout (30 sec default).
# Be aware that the connection string for migrations is a connectionstring without the database name in it. This is appended to the connectionstring after the creation of the database.