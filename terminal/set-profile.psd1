oh-my-posh init pwsh --config "https://raw.githubusercontent.com/tasb/tiberna-personal/main/terminal/terminal.json"  | Invoke-Expression
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows