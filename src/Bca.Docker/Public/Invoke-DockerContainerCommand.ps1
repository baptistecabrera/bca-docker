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
        .PARAMETER RunAsAdministrator
            A switch sepcifying wheter or not this cmdlet invokes a command as an Administrator.
        .PARAMETER AsJob
            A switch specifying whether or not to run the command as a background job in the container.
        .PARAMETER JobName
            A string the name of the job if the command is run as a background job in the container. By default, jobs are named Job<n>, where <n> is an ordinal number.
            If you use the JobName parameter in a command, the command is run as a job, and Invoke-DockerContainerCommand returns a job object, even if you do not include AsJob in the command.
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
                Get-Service -Name MyService | Stop-Service
                [...]
                Get-Service -Name MyService | Start-Service
            }

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

            Get-DockerContainer -Name "*BackEnd" -ComputerName MyHostServer | Invoke-DockerContainerCommand -FilePath C:\Scripts\BackEndScript.ps1 -RunAsAdministrator -RunAsJob

            Description
            -----------
            This example will get all containers that match "*BackEnd" on computer MyHostServer and run the script C:\Scripts\BackEndScript.ps1 as administrator and as a job in each container.
        .NOTES
        .LINK
    #>
    [CmdLetBinding()]
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
        [string] $ComputerName = $env:COMPUTERNAME,
        [Parameter(ParameterSetName = "FromContainerObjectAndCommand", Mandatory = $true)]
        [Parameter(ParameterSetName = "FromContainerIdAndCommand", Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]] $Command,
        [Parameter(ParameterSetName = "FromContainerObjectAndFilePath", Mandatory = $true)]
        [Parameter(ParameterSetName = "FromContainerIdAndFilePath", Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ } )]
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
        [string] $JobName
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
    }
    process
    {
        $Container | ForEach-Object {
            $CurrentContainer = $_
            try 
            {
                $Params = $PSBoundParameters
                if ($Params.Container) { $Params.Remove("Container") | Out-Null }
                $Params.ContainerId = $CurrentContainer.FullId
                if ($Params.FilePath) { $Params.FilePath = Get-Content $Params.FilePath }
                Invoke-Command -ComputerName $CurrentContainer.ComputerName -ScriptBlock {
                    try
                    {
                        $Params = $using:Params
                        if ($Params.Expression)
                        {
                            $Params.Add("Command", "Invoke-Expression `"$($Params.Expression)`"")
                            $Params.Remove("Expression") | Out-Null
                        }
                        if ($Params.FilePath)
                        {
                            $FilePath = (Join-Path $env:TEMP ("{0}.ps1" -f (New-Guid).ToString()))
                            $Params.FilePath | Set-Content $FilePath
                            $Params.FilePath = $FilePath
                        }
                        if ($Params.Command) { $Params.Command = [scriptblock]::Create($Params.Command -join ";") }
                        if ($Params.ScriptBlock) { $Params.ScriptBlock = [scriptblock]::Create($Params.ScriptBlock) }

                        Invoke-Command @Params     
                    }
                    catch
                    {
                        Write-Error $_
                    }
                    finally 
                    {
                        if ($Params.FilePath) { Remove-Item $Params.FilePath -Force -ErrorAction SilentlyContinue }
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