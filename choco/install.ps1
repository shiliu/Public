$isInMsCorp = Test-Path "\\stcsuz"
$curUserName = $ENV:USERNAME

function Check-Url
{
    param(
        [Parameter(Position=0)]
        [string] $Url
    )

    try {
        $request = [Net.WebRequest]::Create($Url)
        $request.Timeout = 2000
        return $([int]$request.GetResponse().Statuscode -eq 200)
    }
    Catch {
        return $false
    }
}

#
# Step 1: Install the Choco if not yet
#
if (!(Test-Path "$ENV:ChocolateyInstall\bin\choco.exe")){
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    $ENV:Path = "$ENV:ALLUSERSPROFILE\chocolatey\bin;$ENV:Path"
}
Write-Host ""


#
# Step 2: Basic setup
#
choco source add -n=ddrr -s="http://nuget.ddrr.org/api/odata" --priority=10
choco install AutoProfile -y
Write-Host ""


#
# Step 3: Do customized setup for current user
#
$userSetupUrl = "https://raw.githubusercontent.com/shiliu/Public/master/choco/users/$curUserName.ps1"
if (Check-Url $userSetupUrl) {
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString($userSetupUrl))
    Write-Host "Global customized setup script for current user '$curUserName' has been invoked." -ForegroundColor Green
}
else {
    Write-Host "There is no global customized setup script for current user '$curUserName'." -ForegroundColor Yellow
}
Write-Host ""


#
# Step 4: Do customized setup for current user for microsoft corp network accessible machine
#
if ($ENV:USERDNSDOMAIN -like "*.microsoft.com"){
    # Add corp source for current user
    $corpUserSetupPath = "\\stcsuz\root\users\$curUserName\choco\setup.ps1"
    if (Test-Path $corpUserSetupPath){
        . "$corpUserSetupPath"
        Write-Host "Customized setup script for current microsoft domain user '$curUserName' has been invoked." -ForegroundColor Green
    }
    else {
        Write-Host "There is no customized setup script for current microsoft domain user '$curUserName'." -ForegroundColor Yellow
    }
}
