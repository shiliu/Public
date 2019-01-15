# Public

## Install choco with basic setup (Run in powershell as administrator)
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/shiliu/Public/master/choco/install.ps1'))
```

## Install env with cmdlet like below in a new powershell console
```powershell
Setup-BasicEnv
```
