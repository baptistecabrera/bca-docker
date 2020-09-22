# Start-DockerContainer

Type: Function

Module: [Bca.Docker](../ReadMe.md)

Starts a Docker container.
## Description
Starts a Docker container.
## Syntax
### FromName (default)
```powershell
Start-DockerContainer [-ComputerName <string[]>] [-Name <string[]>] [-Force] [<CommonParameters>]
```
### FromContainer
```powershell
Start-DockerContainer -Container <psobject[]> [-Force] [<CommonParameters>]
```
### FromId
```powershell
Start-DockerContainer [-ComputerName <string[]>] [-Id <string[]>] [-Force] [<CommonParameters>]
```
## Examples
### Example 1
```powershell
Start-DockerContainer -Name MyDocker -ComputerName MyHostServer
```
This example will start the container named 'MyDocker' on computer 'MyHostServer'.
### Example 2
```powershell
Get-DockerContainer | Start-DockerContainer
```
This example will start all containers hosted on the current computer.
## Parameters
### `-Container`
An array of pscustomobjects containing the containers to start.

| | |
|:-|:-|
|Type:|PSObject[]|
|Parameter sets:|FromContainer|
|Position:|Named|
|Required:|True|
|Accepts pipepline input:|True|

### `-ComputerName`
An array of string containing the computer(s) where the containers are hosted.

| | |
|:-|:-|
|Type:|String[]|
|Default value:|$env:COMPUTERNAME|
|Parameter sets:|FromId, FromName|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Name`
An array of strings containing the name(s) of the container(s) to start.
This parameter accepts wildcard character ('*').

| | |
|:-|:-|
|Type:|String[]|
|Parameter sets:|FromName|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Id`
An array of strings containing the id(s) of the container(s) to start.
This can be the shorten or full id.
This parameter accepts wildcard character ('*').

| | |
|:-|:-|
|Type:|String[]|
|Parameter sets:|FromId|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Force`
A switch specifying whether or not to force the action.

| | |
|:-|:-|
|Type:|SwitchParameter|
|Default value:|False|
|Parameter sets:|FromName, FromId, FromContainer|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

## Inputs
**System.Management.Automation.PSCustomObject**

You can pipe a value for the containers to this cmdlet.
## Outputs
**System.Management.Automation.PSCustomObject**

Returns a PSCustomObject containing the containers.
## Notes
If the Container parameter is used, and the status in the object already corresponds to the desired one, no action would be taken unless Force parameter is used.
## Related Links
- [Stop-DockerContainer](Stop-DockerContainer.md)
