#Минимальный код для использования скрипта PowerShell
$WebClient = New-Object System.Net.WebClient
$Script = $WebClient.DownloadString('https://raw.githubusercontent.com/iSmartyPRO/install-ultravnc/main/installUVNC.ps1')
$ScriptBlock = [Scriptblock]::Create($Script)
Invoke-Command -ScriptBlock $ScriptBlock