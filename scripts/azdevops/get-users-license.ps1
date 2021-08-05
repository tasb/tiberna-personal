param(
    [Parameter(Mandatory=$false )][string]$org="https://dev.azure.com/dummy"
)
az devops login --org $org

$users = az devops user list --org $org --query "items[].{ name:user.displayName, license: accessLevel.licenseDisplayName }" --top 10000 | ConvertFrom-Json

Write-Host "Users count: $($users.Length)"

$fileContent = "User, License`r`n";

For ($i=0; $i -le $users.Length; $i++) {
    $u = $users[$i];

    if ($u.name) {
        $fileContent += "$($u.name), $($u.license)`r`n";
    }
}
$fileContent | Out-File -FilePath ./usersLicense.csv
