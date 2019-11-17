$command = Read-Host "build,up,down (press enter for docker-compose up)"

if(!$command)
{
  $command = "up";
}

if(!$env:CONTENT_API) # if this is set we don't want to ask user again
{
  $content_api = Read-Host "Content API endpoint (press enter for http://localhost:8000"

 if(!$content_api)
 {
     $content_api = "http://localhost:8000"
 }
 
 Set-Content ..\..\..\Bl0g.SPA.WebApp\src\Bl0g.SPA.WebApp\Bl0g.SPA.WebApp\config.json 
 '{
     "apis": [
       {
         "type": "content",
         "url": "{CONTENT_API}"
       }
     ]
   }
 '

 # The content api endpoint has to be known for the SPA
 $config = '..\..\..\Bl0g.SPA.WebApp\src\Bl0g.SPA.WebApp\Bl0g.SPA.WebApp\config.json'
(Get-Content $config -Raw).Replace('{CONTENT_API}', $content_api) |
  Set-Content $config

# Set environment variables
$env:CONTENT_API=$content_api;

} else {
  Write-Host "Content API isn't set"
}

if($command -eq "build")
{
  docker-compose build
}

if($command -eq "up")
{
  docker-compose up
}

if($command -eq "down")
{
  docker-compose down
}