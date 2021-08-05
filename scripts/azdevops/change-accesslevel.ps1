param(
    [Parameter(Mandatory=$false )][string]$org="https://dev.azure.com/dummy",
    [Parameter(Mandatory=$false )][string]$dateToCheck="2020/10/31"
)
az devops login --org $org

$users =az devops user list --org $org --query "items[].{ id:id, lastAccessedDate:lastAccessedDate, name:user.displayName }" --top 10000 | ConvertFrom-Json

Write-Host "Users count: " + $users.Length

$baseDate = [datetime]$dateToCheck

For ($i=0; $i -le $users.Length; $i++) {
    $u = $users[$i];

    if ($u.lastAccessedDate -ne $null) {
        $thisDate = [datetime]$u.lastAccessedDate

        if ($thisDate -lt $baseDate) {
            Write-Host "Change access: $($u.name) , LastAccess: $($u.lastAccessedDate)";
            az devops user update --org $org --license-type stakeholder --user $u.id
        }
    }
}
