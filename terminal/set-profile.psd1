Set-Alias -Name k -Value kubectl
Set-PoshPrompt -Theme ~/terminal.json
Import-Module Posh-Git
Import-Module PSReadLine
Import-Module -Name Terminal-Icons
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows