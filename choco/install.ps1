$isInMsCorp = $ENV:USERDNSDOMAIN -like "*.microsoft.com"

#
# Step 1: Install the Choco if not yet
#
if (!(Test-Path "$ENV:ChocolateyInstall\bin\choco.exe")){
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    $ENV:Path = "$ENV:ALLUSERSPROFILE\chocolatey\bin;$ENV:Path"
}

#
# Step 2: Update sources
#

# liushi@microsoft
if ($isInMsCorp){
    Write-Host "Try to add source for MS corp as this machine is joined to MS domain."
    if (Test-Path "\\stcsuz\root\users\liushi\choco\packages"){
        choco source add -n=liushi -s="\\stcsuz\root\users\liushi\choco\packages" --priority=20
    }
}

# ddrr
choco source add -n=ddrr -s="http://nuget.ddrr.org/api/odata" --priority=10


#
# Step 3: Install packages
#

# Install the packages defined in default config file in MS corp.
if ($isInMsCorp){
    if (Test-Path "\\stcsuz\root\users\liushi\choco\default.config"){
        choco install "\\stcsuz\root\users\liushi\choco\default.config" -y
    }
}

# Install my very basic packages
choco install ddrr.SetupEnv -y
