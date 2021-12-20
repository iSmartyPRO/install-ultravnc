$WebClient = New-Object System.Net.WebClient
<#
// Local Config file
$config = [Object](Get-Content ".\config.json" | ConvertFrom-Json)
#>


<# Web Config #>
$config = $WebClient.DownloadString('https://example.com/installs/ultravnc/config.json') | ConvertFrom-Json

Function downloadFiles {
  if(!(Test-Path $config.installFolder)){
    New-Item -Path $config.installFolder -ItemType Directory | Out-Null
    Write-Host "Created Folder" + $config.installFolder -ForegroundColor Green
    $WebClient.DownloadFile((-join($config.uri, "/", $config.setupFile)), (-join($config.installFolder, "\", $config.setupFIle)))
    $WebClient.DownloadFile((-join($config.uri, "/", $config.silentinstall)), (-join($config.installFolder, "\", $config.silentinstall)))
    $WebClient.DownloadFile((-join($config.uri, "/", $config.customConfig)), (-join($config.installFolder, "\", $config.customConfig)))
    $WebClient.DownloadFile((-join($config.uri, "/", $config.regFile)), (-join($config.installFolder, "\", $config.regFile)))
  }
}

Function installIt {
    $silentFile = (-join($config.installFolder, "\", $config.silentinstall))
    Start-Process ($config.installFolder + "\" + $config.setupFIle) -Args "/verysilent /loadinf='$($silentFile)'" -Wait -NoNewWindow
    Write-Host "Installed UltraVNC" -ForegroundColor Green
}

Function customizeIt {
  $customConfig = (-join($config.installFolder, "\", $config.customConfig))
  $regConfig = (-join($config.installFolder, "\", $config.regfile))
  Copy-Item $customConfig $config.setupFolder -Force
  reg import $regConfig
  Write-Host "UltraVNC is customized" -ForegroundColor Green
}

Function openFirewall {
  netsh advfirewall firewall add rule name=winvnc.exe dir=in
}

Function serviceIt {
  cd $config.setupFolder
  Start-Process ".\winvnc.exe" -Args "-install" -Wait -NoNewWindow
  Write-Host "UltraVNC Service is Started" -ForegroundColor Green
}

Function cleanIt {
  Remove-Item $config.installFolder -Recurse
  Write-Host "UltraVNC Temporary Install Folder is removed!!!" -ForegroundColor Green
}

Function isInstalled {
  $result = [PSCustomObject]@{
    installed = $False
    sameVersion = $False
  }
  if((Test-Path -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Ultravnc2_is1)) {
    $regUvnc = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Ultravnc2_is1
    $result.installed = $true
    if($regUvnc.DisplayVersion -eq $config.DisplayVersion) {
      $result.sameVersion = $true
    }
  }
  return $result
}

$isInstalled = isInstalled

if(!$isInstalled.installed -AND !$isInstalled.sameVersion){
  downloadFiles
  installIt
  customizeIt
  serviceIt
  cleanIt
} else {
  Write-Host "Ultra VNC is installed and same version" -ForegroundColor Yellow
}