[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $s
)

if ($s) {
    #az login
    az account set --subscription $s
}


$appsList = az ad app list --show-mine --query "[].appId" | ConvertFrom-Json

foreach ($item in $appsList) {
    Write-Host "Delete app: $item"
    az ad app delete --id $item
}


$appsList = az ad app list --show-mine --query "[].objectId" | ConvertFrom-Json

foreach ($item in $appsList) {
    Write-Host "Delete app: $item"
    az rest --method DELETE --url "https://graph.microsoft.com/v1.0/applications/$item"
}

