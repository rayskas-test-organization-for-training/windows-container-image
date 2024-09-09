FROM mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';$ProgressPreference='silentlyContinue';"]

ARG RUNNER_VERSION=2.319.1

# Install latest PowerShell
RUN Invoke-WebRequest -Uri 'https://aka.ms/install-powershell.ps1' -OutFile install-powershell.ps1; ./install-powershell.ps1 -AddToPath

# Install GitHub Runner
RUN mkdir \actions-runner ; cd \actions-runner
RUN Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v$env:RUNNER_VERSION/actions-runner-win-x64-$env:RUNNER_VERSION.zip
RUN Add-Type -AssemblyName System.IO.Compression.FileSystem ;
RUN [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD\actions-runner-win-x64-2.319.1.zip", "$PWD")

ADD entrypoint.ps1 entrypoint.ps1

CMD [ "pwsh", ".\\entrypoint.ps1"]
