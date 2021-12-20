# Автоматическая установка ULTRA VNC

### Краткое описание
Этот репозиторий предназначен для автоматизации процесса установки Ultra VNC

### С чего начать
Отредактируйте конфигурационные файлы и файл скриптов:
[x] config.json
[x] script.ps1
[x] installUVNC.ps1

#### config.json
Обновите следующие значения:
* uri, путь до файлов из этого репозитория, можно расположить на локальном веб сервере;
* installFolder, папка куда будет временно сохраняться все установочные файлы, он в конце удалиться;
остальные параметры не рекомендуется трогать

#### script.ps1
Обновите строку №3, указав URL до вашего PowerShell скрипта на вашем веб сервере

#### installUVNC.ps1
Обновите строку №9, указав URL до вашего конфигурационного файла config.json на вашем веб сервере


### PowerShell Script - GitHub Installer

Используйте этот код для автоматической установки из GitHub, рекомендуется запускать PowerShell от имени Администратора
```
#Минимальный код для использования скрипта PowerShell
$WebClient = New-Object System.Net.WebClient
$Script = $WebClient.DownloadString('https://raw.githubusercontent.com/iSmartyPRO/install-ultravnc/main/installUVNC.ps1')
$ScriptBlock = [Scriptblock]::Create($Script)
Invoke-Command -ScriptBlock $ScriptBlock
```