# Get-DockerContainer

Type: Function

Module: [Bca.Docker](../ReadMe.md)

Gets a Docker container.
## Description
Gets a Docker container.
## Syntax
### FromName (default)
```powershell
Get-DockerContainer [-ComputerName <string[]>] [-Name <string[]>] [-IncludeExtendedProperties] [-Credential <pscredential>] [-Authentication <AuthenticationMechanism>] [<CommonParameters>]
```
### FromId
```powershell
Get-DockerContainer [-ComputerName <string[]>] [-Id <string[]>] [-IncludeExtendedProperties] [-Credential <pscredential>] [-Authentication <AuthenticationMechanism>] [<CommonParameters>]
```
## Examples
### Example 1
```powershell
Get-DockerContainer -Name MyDocker* -ComputerName MyHostServer01, MyHostServer02
```
This example will get the containers whose name match 'MyDocker*' on computers 'MyHostServer01' and 'MyHostServer02'.
### Example 2
```powershell
Get-DockerContainer -Id 97590b5306b9, 4f657b6d8066b87455303c591873b0739aa14f589cd56365a46a256f726c6be0 -ComputerName MyHostServer
```
This example will get the containers with IDs '97590b5306b9' and '4f657b6d8066b87455303c591873b0739aa14f589cd56365a46a256f726c6be0' on computer 'MyHostServer'.
## Parameters
### `-ComputerName`
Am array of string containing the computer(s) where the containers are hosted.

| | |
|:-|:-|
|Type:|String[]|
|Aliases|Cn|
|Default value:|`$env:COMPUTERNAME`|
|Parameter sets:|FromId, FromName|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Name`
An array of strings containing the name(s) of the container(s) to get.
This parameter accepts wildcard character ('*').

| | |
|:-|:-|
|Type:|String[]|
|Parameter sets:|FromName|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Id`
An array of strings containing the id(s) of the container(s) to get.
This can be the shorten or full id.
This parameter accepts wildcard character ('*').

| | |
|:-|:-|
|Type:|String[]|
|Parameter sets:|FromId|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-IncludeExtendedProperties`
A switch specifying whether or not to retrieve extended properties.

| | |
|:-|:-|
|Type:|SwitchParameter|
|Default value:|`False`|
|Parameter sets:|FromName, FromId|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Credential`
A PSCredential used to connect to the host.

| | |
|:-|:-|
|Type:|PSCredential|
|Parameter sets:|FromName, FromId|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Authentication`
An AuthenticationMechanism that will be used to authenticate the user's credentials

| | |
|:-|:-|
|Type:|AuthenticationMechanism|
|Default value:|`Default`|
|Parameter sets:|FromName, FromId|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|
|Validation (ValidValues):|Basic, Default, Credssp, Digest, Kerberos, Negotiate, NegotiateWithImplicitCredential|

### `-<CommonParameters>`
This command supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable.
For more information, see [about_CommonParameters](https:/go.microsoft.com/fwlink/?LinkID=113216).
## Outputs

**System.Management.Automation.PSCustomObject**

Returns a PSCustomObject containing the containers.
## Notes
Extended properties correspond to a docker container inspect command.
