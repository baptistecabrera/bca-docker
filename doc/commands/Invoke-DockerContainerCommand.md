# Invoke-DockerContainerCommand

Type: Function

Module: [Bca.Docker](../ReadMe.md)

Invokes a command inside a Docker container.
## Description
Invokes a command inside a Docker container.
## Syntax
### FromContainerObjectAndExpression
```powershell
Invoke-DockerContainerCommand -Container <psobject[]> -Expression <string> [-RunAsAdministrator] [-AsJob] [-JobName <string>] [-Credential <pscredential>] [-Authentication <AuthenticationMechanism>] [-AuthenticationOn <string[]>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```
### FromContainerObjectAndFilePath
```powershell
Invoke-DockerContainerCommand -Container <psobject[]> -FilePath <string> [-ArgumentList <Object[]>] [-RunAsAdministrator] [-AsJob] [-JobName <string>] [-Credential <pscredential>] [-Authentication <AuthenticationMechanism>] [-AuthenticationOn <string[]>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```
### FromContainerObjectAndScriptBlock
```powershell
Invoke-DockerContainerCommand -Container <psobject[]> -ScriptBlock <scriptblock> [-ArgumentList <Object[]>] [-RunAsAdministrator] [-AsJob] [-JobName <string>] [-Credential <pscredential>] [-Authentication <AuthenticationMechanism>] [-AuthenticationOn <string[]>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```
### FromContainerObjectAndCommand
```powershell
Invoke-DockerContainerCommand -Container <psobject[]> -Command <string[]> [-ArgumentList <Object[]>] [-RunAsAdministrator] [-AsJob] [-JobName <string>] [-Credential <pscredential>] [-Authentication <AuthenticationMechanism>] [-AuthenticationOn <string[]>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```
### FromContainerIdAndExpression
```powershell
Invoke-DockerContainerCommand -ContainerId <string> -Expression <string> [-ComputerName <string>] [-RunAsAdministrator] [-AsJob] [-JobName <string>] [-Credential <pscredential>] [-Authentication <AuthenticationMechanism>] [-AuthenticationOn <string[]>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```
### FromContainerIdAndFilePath
```powershell
Invoke-DockerContainerCommand -ContainerId <string> -FilePath <string> [-ComputerName <string>] [-ArgumentList <Object[]>] [-RunAsAdministrator] [-AsJob] [-JobName <string>] [-Credential <pscredential>] [-Authentication <AuthenticationMechanism>] [-AuthenticationOn <string[]>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```
### FromContainerIdAndScriptBlock
```powershell
Invoke-DockerContainerCommand -ContainerId <string> -ScriptBlock <scriptblock> [-ComputerName <string>] [-ArgumentList <Object[]>] [-RunAsAdministrator] [-AsJob] [-JobName <string>] [-Credential <pscredential>] [-Authentication <AuthenticationMechanism>] [-AuthenticationOn <string[]>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```
### FromContainerIdAndCommand
```powershell
Invoke-DockerContainerCommand -ContainerId <string> -Command <string[]> [-ComputerName <string>] [-ArgumentList <Object[]>] [-RunAsAdministrator] [-AsJob] [-JobName <string>] [-Credential <pscredential>] [-Authentication <AuthenticationMechanism>] [-AuthenticationOn <string[]>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```
## Examples
### Example 1
```powershell
Invoke-DockerContainerCommand -Command "Get-Service -Name MyService" -ContainerId 4f657b6d8066b87455303c591873b0739aa14f589cd56365a46a256f726c6be0 -ComputerName MyHostServer
```
This example will get the service MyService in the container with id '4f657b6d8066b87455303c591873b0739aa14f589cd56365a46a256f726c6be0' on computer 'MyHostServer'.
### Example 2
```powershell
Get-DockerContainer | Invoke-DockerContainerCommand -ScriptBlock {
param([string] $ServiceName)

    Get-Service -Name $ServiceName | Stop-Service
    [...]
    Get-Service -Name $ServiceName | Start-Service
} -ArgumentList "MyService"

```
This example will get all containers hosted on the current computer, stop the service MyService, do some processing and start the service on each of them.
### Example 3
```powershell
Get-ChildItem
Directory: C:\Script

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       2020-09-02   8:56 AM           4579 BackEndScript.ps1
-a----       2020-09-02  11:25 AM           5979 FrontEndScript.ps1

Get-DockerContainer -Name "*BackEnd" -ComputerName MyHostServer -Credential DOMAIN\MyUser -Authentication CredSSP | Invoke-DockerContainerCommand -FilePath C:\Scripts\BackEndScript.ps1 -ArgumentList $Arg0, $Arg1 -RunAsAdministrator -RunAsJob -Credential DOMAIN\MyUser -Authentication CredSSP -AuthenticationOn Host, Docker

```
This example will get all containers that match "*BackEnd" on computer MyHostServer, using DOMAIN\MyUser with CredSSP on both the host server and the container, and run the script C:\Scripts\BackEndScript.ps1 as administrator and as a job in each container.
## Parameters
### `-Container`
An array of pscustomobjects containing the container(s) where the command will be run.

| | |
|:-|:-|
|Type:|PSObject[]|
|Parameter sets:|FromContainerObjectAndExpression, FromContainerObjectAndFilePath, FromContainerObjectAndScriptBlock, FromContainerObjectAndCommand|
|Position:|Named|
|Required:|True|
|Accepts pipepline input:|True|

### `-ContainerId`
An array of strings containing the full id(s) (64 characters) of the container(s) where the command will be run.

| | |
|:-|:-|
|Type:|String|
|Parameter sets:|FromContainerIdAndExpression, FromContainerIdAndFilePath, FromContainerIdAndScriptBlock, FromContainerIdAndCommand|
|Position:|Named|
|Required:|True|
|Accepts pipepline input:|False|
|Validation (MaxLength):|64|
|Validation (MinLength):|64|

### `-ComputerName`
An array of string containing the computer(s) where the containers are hosted.

| | |
|:-|:-|
|Type:|String|
|Aliases|Cn|
|Default value:|`$env:COMPUTERNAME`|
|Parameter sets:|FromContainerIdAndExpression, FromContainerIdAndFilePath, FromContainerIdAndScriptBlock, FromContainerIdAndCommand|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Command`
An array of string containing the command(s) to run in the container.

| | |
|:-|:-|
|Type:|String[]|
|Parameter sets:|FromContainerIdAndCommand, FromContainerObjectAndCommand|
|Position:|Named|
|Required:|True|
|Accepts pipepline input:|False|

### `-FilePath`
A string containing the path of a local powershell script to run in the container.

| | |
|:-|:-|
|Type:|String|
|Aliases|PSPath|
|Parameter sets:|FromContainerIdAndFilePath, FromContainerObjectAndFilePath|
|Position:|Named|
|Required:|True|
|Accepts pipepline input:|False|
|Validation (ScriptBlock):|` Test-Path $_ `|

### `-Expression`
A string containing the expression to run in the container.

| | |
|:-|:-|
|Type:|String|
|Parameter sets:|FromContainerIdAndExpression, FromContainerObjectAndExpression|
|Position:|Named|
|Required:|True|
|Accepts pipepline input:|False|

### `-ScriptBlock`
An script block describing the command(s) to run in the container.

| | |
|:-|:-|
|Type:|ScriptBlock|
|Parameter sets:|FromContainerIdAndScriptBlock, FromContainerObjectAndScriptBlock|
|Position:|Named|
|Required:|True|
|Accepts pipepline input:|False|

### `-ArgumentList`
An array of object specifying the arguments - local variables or values - to pass to the command, script or script block.
The param keyword lists the local variables that are used in the command. ArgumentList supplies the values of the variables, in the order that they're listed.

| | |
|:-|:-|
|Type:|Object[]|
|Aliases|Args|
|Parameter sets:|FromContainerIdAndFilePath, FromContainerIdAndScriptBlock, FromContainerIdAndCommand, FromContainerObjectAndFilePath, FromContainerObjectAndScriptBlock, FromContainerObjectAndCommand|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-RunAsAdministrator`
A switch sepcifying wheter or not this cmdlet invokes a command as an Administrator.

| | |
|:-|:-|
|Type:|SwitchParameter|
|Default value:|`False`|
|Parameter sets:|FromContainerIdAndExpression, FromContainerIdAndFilePath, FromContainerIdAndScriptBlock, FromContainerIdAndCommand, FromContainerObjectAndExpression, FromContainerObjectAndFilePath, FromContainerObjectAndScriptBlock, FromContainerObjectAndCommand|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-AsJob`
A switch specifying whether or not to run the command as a background job in the container.

| | |
|:-|:-|
|Type:|SwitchParameter|
|Default value:|`False`|
|Parameter sets:|FromContainerIdAndExpression, FromContainerIdAndFilePath, FromContainerIdAndScriptBlock, FromContainerIdAndCommand, FromContainerObjectAndExpression, FromContainerObjectAndFilePath, FromContainerObjectAndScriptBlock, FromContainerObjectAndCommand|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-JobName`
A string the name of the job if the command is run as a background job in the container. By default, jobs are named Job<n>, where <n> is an ordinal number.
If you use the JobName parameter in a command, the command is run as a job, and Invoke-DockerContainerCommand returns a job object, even if you do not include AsJob in the command.

| | |
|:-|:-|
|Type:|String|
|Parameter sets:|FromContainerIdAndExpression, FromContainerIdAndFilePath, FromContainerIdAndScriptBlock, FromContainerIdAndCommand, FromContainerObjectAndExpression, FromContainerObjectAndFilePath, FromContainerObjectAndScriptBlock, FromContainerObjectAndCommand|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Credential`
A PSCredential used to connect to the host.

| | |
|:-|:-|
|Type:|PSCredential|
|Parameter sets:|FromContainerIdAndExpression, FromContainerIdAndFilePath, FromContainerIdAndScriptBlock, FromContainerIdAndCommand, FromContainerObjectAndExpression, FromContainerObjectAndFilePath, FromContainerObjectAndScriptBlock, FromContainerObjectAndCommand|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Authentication`
An AuthenticationMechanism that will be used to authenticate the user's credentials.

| | |
|:-|:-|
|Type:|AuthenticationMechanism|
|Default value:|`Default`|
|Parameter sets:|FromContainerIdAndExpression, FromContainerIdAndFilePath, FromContainerIdAndScriptBlock, FromContainerIdAndCommand, FromContainerObjectAndExpression, FromContainerObjectAndFilePath, FromContainerObjectAndScriptBlock, FromContainerObjectAndCommand|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|
|Validation (ValidValues):|Basic, Default, Credssp, Digest, Kerberos, Negotiate, NegotiateWithImplicitCredential|

### `-AuthenticationOn`
An array of string specifying whether to use Credential and Authentication on the host, the container or both.

| | |
|:-|:-|
|Type:|String[]|
|Default value:|`Host`|
|Parameter sets:|FromContainerIdAndExpression, FromContainerIdAndFilePath, FromContainerIdAndScriptBlock, FromContainerIdAndCommand, FromContainerObjectAndExpression, FromContainerObjectAndFilePath, FromContainerObjectAndScriptBlock, FromContainerObjectAndCommand|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|
|Validation (ValidValues):|Host, Container|

### `-Force`
A switch specifying whether or not to force the action.

| | |
|:-|:-|
|Type:|SwitchParameter|
|Default value:|`False`|
|Parameter sets:|FromContainerIdAndExpression, FromContainerIdAndFilePath, FromContainerIdAndScriptBlock, FromContainerIdAndCommand, FromContainerObjectAndExpression, FromContainerObjectAndFilePath, FromContainerObjectAndScriptBlock, FromContainerObjectAndCommand|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-WhatIf`
This command supports the WhatIf parameter to simulate the action before executing it.
### `-Confirm`
This command supports the Confirm parameter to require a user confirmation before executing it.
### `-<CommonParameters>`
This command supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable.
For more information, see [about_CommonParameters](https:/go.microsoft.com/fwlink/?LinkID=113216).
## Inputs

**System.Management.Automation.PSCustomObject**

You can pipe a value for the containers to this cmdlet.
## Outputs

**System.Management.Automation.PSRemotingJob, or the output of the invoked command**

This cmdlet returns a job object, if you use the AsJob parameter. Otherwise, it returns the output of the invoked command, which is the value of the ScriptBlock parameter.
## Related Links
- Invoke-Command
