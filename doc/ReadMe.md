# Bca.Docker `0.3.0`
Tags: `container` `docker` `Linux` `MacOS` `Windows`

Minimum PowerShell version: `5.1`

PowerShell module to manage Docker containers.

## Commands
- [Get-DockerContainer](commands/Get-DockerContainer.md)
- [Invoke-DockerContainerCommand](commands/Invoke-DockerContainerCommand.md)
- [Start-DockerContainer](commands/Start-DockerContainer.md)
- [Stop-DockerContainer](commands/Stop-DockerContainer.md)

## Release Notes
0.3.0:
- Invoke-DockerContainerCommand:
  - Added support for ArgumentList parameter;
  - Added AuthenticationOn parameter that allows to specify whether to use Credential and Authentication paramaters on the host, container or both.

0.2.0:
- Added ShouldProcess support on some functions;
- Added support for Authentication and Credential parameters.

0.1.0:
- Get-DockerContainer: function to retrieve docker informations;
- Invoke-DockerContainerCommand: function to execute a command, script or script block in a docker container;
- Start-DockerContainer/Stop-DockerConatainer: functions to start or stop a docke container;
- Supports Windows, Linux and MacOS;
- Supports English and French language.
---
[Bca.Docker](https://github.com/baptistecabrera/bca-docker)
