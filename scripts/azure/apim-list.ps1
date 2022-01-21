[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $s,
    [Parameter()]
    [String]
    $g,
    [Parameter()]
    [String]
    $n
)

#az login
az account set --subscription $s

$result = az apim api list -g $g -n $n | ConvertFrom-Json

$apiList = @()

foreach ($item in $result) {

    $thisApi = [PSCustomObject]@{
        Name     = $item.name
        DisplayName = $item.displayName
        ApiVersion = $item.apiVersion
        ApiRevision = $item.apiRevision
        ServiceUrl = $item.serviceUrl
        Protocols = $item.protocols[0]
    }
    $apiList += $thisApi
}

$apiList | Export-CSV "./apiList-$g-$n.csv"

