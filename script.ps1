#PowerShell Script for manual launch on local computer
$WebClient = New-Object System.Net.WebClient
$Script = $WebClient.DownloadString('https://example.com/installs/ultravnc/installUVNC.ps1')
$ScriptBlock = [Scriptblock]::Create($Script)
Invoke-Command -ScriptBlock $ScriptBlock