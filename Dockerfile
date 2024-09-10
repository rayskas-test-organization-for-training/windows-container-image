FROM mcr.microsoft.com/windows/servercore:ltsc2019

WORKDIR /actions-runner

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';$ProgressPreference='silentlyContinue';"]

RUN Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.319.1/actions-runner-win-arm64-2.319.1.zip -OutFile actions-runner-win-arm64-2.319.1.zip

RUN Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory('actions-runner-win-arm64-2.319.1.zip', $PWD)

RUN Invoke-WebRequest -Uri 'https://aka.ms/install-powershell.ps1' -OutFile install-powershell.ps1; ./install-powershell.ps1 -AddToPath

RUN $securityProtocolSettingsOriginal = [System.Net.ServicePointManager]::SecurityProtocol
RUN [System.Net.ServicePointManager]::SecurityProtocol = 3072 -bor 768 -bor 192 -bor 48
RUN Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
RUN [System.Net.ServicePointManager]::SecurityProtocol = $securityProtocolSettingsOriginal

RUN choco install -y \
    git \
    gh \
    powershell-core \
    azure-cli

#FROM mcr.microsoft.com/windows/servercore:ltsc2019
#SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';$ProgressPreference='silentlyContinue';"]
#WORKDIR /actions-runner
#RUN Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.319.1/actions-runner-win-x64-2.319.1.zip -OutFile actions-runner-win-x64-2.319.1.zip
#RUN Expand-Archive -Path $pwd/actions-runner-win-x64-2.319.1.zip -DestinationPath C:/actions-runner
#RUN winget install --id Microsoft.PowerShell --source winget
#RUN powershell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
#RUN powershell choco install git.install --params "'/GitAndUnixToolsOnPath'" -y
#RUN powershell choco feature enable -n allowGlobalConfirmation
