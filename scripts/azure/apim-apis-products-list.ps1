param(
    [Parameter(Mandatory=$true )][string]$subscription="tiberna_airs",
    [Parameter(Mandatory=$true )][string]$resourceGroup="tiberna-rg",
    [Parameter(Mandatory=$true )][string]$apim="tiberna-apim"
)

function ArrayToHash($a)
{
    $hash = @{}
    $a | ForEach-Object { $hash[$_.apiId] = $_ }
    return $hash
}

#az login

az account set --subscription $subscription

$productList = az apim product list -g $resourceGroup -n $apim --query "[].{ productId:name, prodName:displayName }" | ConvertFrom-Json

#Write-Host "Products count: $($productList.Length)"

$apiList = az apim api list -g $resourceGroup -n $apim --query "[].{ apiId:name, apiName:displayName }" --top 10000 | ConvertFrom-Json

#Write-Host "APIs count: $($apiList.Length)"

$apiHash = ArrayToHash($apiList)

$productList | ForEach-Object {
    $prod = $_

    $retList = az apim product api list --resource-group $resourceGroup  --service-name $apim  --product-id $prod.productId --query "[].{ apiId:name, apiName:displayName }" | ConvertFrom-Json

    $retList | ForEach-Object {
        Write-Host $apiHash[$_.apiId]
        if (!$apiHash[$_.apiId].products) {
            $empty = [System.Collections.ArrayList]::new()
            Add-Member -InputObject $apiHash[$_.apiId] -NotePropertyName "products" -NotePropertyValue $empty
        }

        [void]$apiHash[$_.apiId].products.Add($prod.prodName)

    }
}

$fileContent = "API ID, API Name, Products`r`n";

$apiHash.Keys | ForEach-Object {
    $api = $apiHash[$_]

    $line = "$($api.apiId), "
    $line += "$($api.apiName), "
    $api.products | ForEach-Object {
        $line += "$_;"
    }
    $line= $line.Substring(0,$line.Length-1)
    $line += "`r`n"
    $fileContent += $line
}

$fileContent | Out-File -FilePath ./api-list.csv