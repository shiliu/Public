Write-Host "Hello world!"

# Install the Choco if not yet
if (!(Test-Path "$ENV:ChocolateyInstall1choco.exe"))
{
    # Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Write-Host "Packages: $Packages"
