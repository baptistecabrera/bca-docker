function Invoke-DockerContainerCommand
{
    <#
        .SYNOPSIS
            Invokes a command inside a Docker container.
        .DESCRIPTION
            Invokes a command inside a Docker container.
        .PARAMETER ContainerId
            An array of strings containing the full id(s) (64 characters) of the container(s) where the command will be run.
        .PARAMETER Container
            An array of pscustomobjects containing the container(s) where the command will be run.
        .PARAMETER ComputerName
            An array of string containing the computer(s) where the containers are hosted.
        .PARAMETER Command
            An array of string containing the command(s) to run in the container.
        .PARAMETER Expression
            A string containing the expression to run in the container.
        .PARAMETER ScriptBlock
            An script block describing the command(s) to run in the container.
        .PARAMETER FilePath
            A string containing the path of a local powershell script to run in the container.
        .PARAMETER ArgumentList
            An array of object specifying the arguments - local variables or values - to pass to the command, script or script block.
            The param keyword lists the local variables that are used in the command. ArgumentList supplies the values of the variables, in the order that they're listed.
        .PARAMETER RunAsAdministrator
            A switch sepcifying wheter or not this cmdlet invokes a command as an Administrator.
        .PARAMETER AsJob
            A switch specifying whether or not to run the command as a background job in the container.
        .PARAMETER JobName
            A string the name of the job if the command is run as a background job in the container. By default, jobs are named Job<n>, where <n> is an ordinal number.
            If you use the JobName parameter in a command, the command is run as a job, and Invoke-DockerContainerCommand returns a job object, even if you do not include AsJob in the command.
        .PARAMETER Credential
            A PSCredential used to connect to the host.
        .PARAMETER Authentication
            An AuthenticationMechanism that will be used to authenticate the user's credentials.
        .PARAMETER AuthenticationOn
            An array of string specifying whether to use Credential and Authentication on the host, the container or both.
        .PARAMETER Force
            A switch specifying whether or not to force the action.
        .INPUTS
            System.Management.Automation.PSCustomObject
            You can pipe a value for the containers to this cmdlet.
        .OUTPUTS
            System.Management.Automation.PSRemotingJob, or the output of the invoked command
            This cmdlet returns a job object, if you use the AsJob parameter. Otherwise, it returns the output of the invoked command, which is the value of the ScriptBlock parameter.
        .EXAMPLE
            Invoke-DockerContainerCommand -Command "Get-Service -Name MyService" -ContainerId 4f657b6d8066b87455303c591873b0739aa14f589cd56365a46a256f726c6be0 -ComputerName MyHostServer

            Description
            -----------
            This example will get the service MyService in the container with id '4f657b6d8066b87455303c591873b0739aa14f589cd56365a46a256f726c6be0' on computer 'MyHostServer'.
        .EXAMPLE
            Get-DockerContainer | Invoke-DockerContainerCommand -ScriptBlock {
                param([string] $ServiceName)

                Get-Service -Name $ServiceName | Stop-Service
                [...]
                Get-Service -Name $ServiceName | Start-Service
            } -ArgumentList "MyService"

            Description
            -----------
            This example will get all containers hosted on the current computer, stop the service MyService, do some processing and start the service on each of them.
        .EXAMPLE
            Get-ChildItem
                Directory: C:\Script

            Mode                LastWriteTime         Length Name
            ----                -------------         ------ ----
            -a----       2020-09-02   8:56 AM           4579 BackEndScript.ps1
            -a----       2020-09-02  11:25 AM           5979 FrontEndScript.ps1

            Get-DockerContainer -Name "*BackEnd" -ComputerName MyHostServer -Credential DOMAIN\MyUser -Authentication CredSSP | Invoke-DockerContainerCommand -FilePath C:\Scripts\BackEndScript.ps1 -ArgumentList $Arg0, $Arg1 -RunAsAdministrator -RunAsJob -Credential DOMAIN\MyUser -Authentication CredSSP -AuthenticationOn Host, Docker

            Description
            -----------
            This example will get all containers that match "*BackEnd" on computer MyHostServer, using DOMAIN\MyUser with CredSSP on both the host server and the container, and run the script C:\Scripts\BackEndScript.ps1 as administrator and as a job in each container.
        .NOTES
        .LINK
            Invoke-Command
    #>
    [CmdLetBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(ParameterSetName = "FromContainerObjectAndCommand", Mandatory = $true, ValueFromPipeline = $true)]
        [Parameter(ParameterSetName = "FromContainerObjectAndScriptBlock", Mandatory = $true, ValueFromPipeline = $true)]
        [Parameter(ParameterSetName = "FromContainerObjectAndFilePath", Mandatory = $true, ValueFromPipeline = $true)]
        [Parameter(ParameterSetName = "FromContainerObjectAndExpression", Mandatory = $true, ValueFromPipeline = $true)]
        [pscustomobject[]] $Container,
        [Parameter(ParameterSetName = "FromContainerIdAndCommand", Mandatory = $true)]
        [Parameter(ParameterSetName = "FromContainerIdAndScriptBlock", Mandatory = $true)]
        [Parameter(ParameterSetName = "FromContainerIdAndFilePath", Mandatory = $true)]
        [Parameter(ParameterSetName = "FromContainerIdAndExpression", Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(64, 64)]
        [string] $ContainerId,
        [Parameter(ParameterSetName = "FromContainerIdAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndExpression", Mandatory = $false)]
        [Alias("Cn")]
        [string] $ComputerName = $env:COMPUTERNAME,
        [Parameter(ParameterSetName = "FromContainerObjectAndCommand", Mandatory = $true)]
        [Parameter(ParameterSetName = "FromContainerIdAndCommand", Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]] $Command,
        [Parameter(ParameterSetName = "FromContainerObjectAndFilePath", Mandatory = $true)]
        [Parameter(ParameterSetName = "FromContainerIdAndFilePath", Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ } )]
        [Alias("PSPath")]
        [string] $FilePath,
        [Parameter(ParameterSetName = "FromContainerObjectAndExpression", Mandatory = $true)]
        [Parameter(ParameterSetName = "FromContainerIdAndExpression", Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Expression,
        [Parameter(ParameterSetName = "FromContainerObjectAndScriptBlock", Mandatory = $true)]
        [Parameter(ParameterSetName = "FromContainerIdAndScriptBlock", Mandatory = $true)]
        [scriptblock] $ScriptBlock,
        [Parameter(ParameterSetName = "FromContainerObjectAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndFilePath", Mandatory = $false)]
        [Alias("Args")]
        [object[]] $ArgumentList,
        [Parameter(ParameterSetName = "FromContainerObjectAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndExpression", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndExpression", Mandatory = $false)]
        [switch] $RunAsAdministrator,
        [Parameter(ParameterSetName = "FromContainerObjectAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndExpression", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndExpression", Mandatory = $false)]
        [switch] $AsJob,
        [Parameter(ParameterSetName = "FromContainerObjectAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndExpression", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndExpression", Mandatory = $false)]
        [string] $JobName,
        [Parameter(ParameterSetName = "FromContainerObjectAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndExpression", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndExpression", Mandatory = $false)]
        [pscredential] $Credential,
        [Parameter(ParameterSetName = "FromContainerObjectAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndExpression", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndExpression", Mandatory = $false)]
        [ValidateSet("Basic", "Default", "Credssp", "Digest", "Kerberos", "Negotiate", "NegotiateWithImplicitCredential")]
        [System.Management.Automation.Runspaces.AuthenticationMechanism] $Authentication = "Default",
        [Parameter(ParameterSetName = "FromContainerObjectAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndExpression", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndExpression", Mandatory = $false)]
        [ValidateSet("Host", "Container")]
        [string[]] $AuthenticationOn = "Host",
        [Parameter(ParameterSetName = "FromContainerObjectAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerObjectAndExpression", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndCommand", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndScriptBlock", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndFilePath", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromContainerIdAndExpression", Mandatory = $false)]
        [switch] $Force
    )

    begin
    {
        Write-Debug ($script:LocalizedData.Global.Debug.Entering -f $PSCmdlet.MyInvocation.MyCommand)
        if ($PSCmdlet.ParameterSetName -match "FromContainerId")
        {
            $Container = New-Object -TypeName PSCustomObject @{
                FullId = $ContainerId;
                ComputerName = $ComputerName
            }
            $PSBoundParameters.Remove("ContainerId") | Out-Null
            if ($PSBoundParameters.ComputerName) { $PSBoundParameters.Remove("ComputerName") | Out-Null }
        }
        if ($PSBoundParameters.Force) { $PSBoundParameters.Remove("Force") | Out-Null }
        if ($PSBoundParameters.AuthenticationOn) { $PSBoundParameters.Remove("AuthenticationOn") | Out-Null }
    }
    process
    {
        $Container | ForEach-Object {
            $CurrentContainer = $_
            try 
            {
                $HostParameters = @{
                    ComputerName = $CurrentContainer.ComputerName
                }
                if ($AuthenticationOn -contains "Host")
                {
                    if ($PSBoundParameters.Credential) { $HostParameters.Add("Credential", $Credential) }
                    if ($PSBoundParameters.Authentication) { $HostParameters.Add("Authentication", $Authentication) }
                }

                $ContainerParameters = $PSBoundParameters
                if ($ContainerParameters.Container) { $ContainerParameters.Remove("Container") | Out-Null }
                $ContainerParameters.ContainerId = $CurrentContainer.FullId
                if ($ContainerParameters.FilePath) { $ContainerParameters.FilePath = Get-Content $ContainerParameters.FilePath }
                if (!($AuthenticationOn -contains "Container"))
                {
                    if ($ContainerParameters.Credential) { $ContainerParameters.Remove("Credential") | Out-Null }
                    if ($ContainerParameters.Authentication) { $ContainerParameters.Remove("Authentication") | Out-Null }
                }
                if ($ContainerParameters.WhatIf) { $ContainerParameters.Remove("WhatIf") | Out-Null }
                if ($ContainerParameters.Confirm) { $ContainerParameters.Remove("Confirm") | Out-Null }
                if ($CurrentContainer.Name) { $Target = $CurrentContainer.Name }
                else { $Target = $CurrentContainer.FullId }

                if ($Force -or $PSCmdlet.ShouldProcess($Target))
                {
                    Invoke-Command @HostParameters -ScriptBlock {
                        try
                        {
                            $ContainerParameters = $using:ContainerParameters
                            if ($ContainerParameters.Expression)
                            {
                                $ContainerParameters.Add("Command", "Invoke-Expression `"$($ContainerParameters.Expression)`"")
                                $ContainerParameters.Remove("Expression") | Out-Null
                            }
                            if ($ContainerParameters.FilePath)
                            {
                                $FilePath = (Join-Path $env:TEMP ("{0}.ps1" -f (New-Guid).ToString()))
                                $ContainerParameters.FilePath | Set-Content $FilePath
                                $ContainerParameters.FilePath = $FilePath
                            }
                            if ($ContainerParameters.Command) { $ContainerParameters.Command = [scriptblock]::Create($ContainerParameters.Command -join ";") }
                            if ($ContainerParameters.ScriptBlock) { $ContainerParameters.ScriptBlock = [scriptblock]::Create($ContainerParameters.ScriptBlock) }

                            Invoke-Command @ContainerParameters     
                        }
                        catch
                        {
                            Write-Error $_
                        }
                        finally 
                        {
                            if ($ContainerParameters.FilePath) { Remove-Item $ContainerParameters.FilePath -Force -ErrorAction SilentlyContinue }
                        }
                    }
                }
            }
            catch 
            {
                Write-Error $_    
            }
        }
    }
    end
    {
        Write-Debug ($script:LocalizedData.Global.Debug.Leaving -f $PSCmdlet.MyInvocation.MyCommand)
    }
}