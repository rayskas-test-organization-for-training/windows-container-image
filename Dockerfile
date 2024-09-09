FROM mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';$ProgressPreference='silentlyContinue';"]

# Install GitHub Runner
WORKDIR /actions-runner
RUN Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.319.1/actions-runner-win-x64-2.319.1.zip -OutFile actions-runner-win-x64-2.319.1.zip
RUN Expand-Archive -Path $pwd/actions-runner-win-x64-2.319.1.zip -DestinationPath C:/actions-runner


# Install latest PowerShell
RUN Invoke-WebRequest -Uri 'https://aka.ms/install-powershell.ps1' -OutFile install-powershell.ps1; ./install-powershell.ps1 -AddToPath

ADD entrypoint.ps1 entrypoint.ps1

CMD [ "pwsh", ".\\entrypoint.ps1"]
