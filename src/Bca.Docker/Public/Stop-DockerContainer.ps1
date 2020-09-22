function Stop-DockerContainer
{
    <#
        .SYNOPSIS
            Stops a Docker container.
        .DESCRIPTION
            Stops a Docker container.
        .PARAMETER Name
            An array of strings containing the name(s) of the container(s) to stop.
            This parameter accepts wildcard character ('*').
        .PARAMETER Id
            An array of strings containing the id(s) of the container(s) to stop.
            This can be the shorten or full id.
            This parameter accepts wildcard character ('*').
        .PARAMETER Container
            An array of pscustomobjects containing the containers to stop.
        .PARAMETER ComputerName
            An array of string containing the computer(s) where the containers are hosted.
        .PARAMETER Force
            A switch specifying whether or not to force the action.
        .INPUTS
            System.Management.Automation.PSCustomObject
            You can pipe a value for the containers to this cmdlet.
        .OUTPUTS
            System.Management.Automation.PSCustomObject
            Returns a PSCustomObject containing the containers.
        .EXAMPLE
            Stop-DockerContainer -Name MyDocker -ComputerName MyHostServer

            Description
            -----------
            This example will stop the container named 'MyDocker' on computer 'MyHostServer'.
        .EXAMPLE
            Get-DockerContainer | Stop-DockerContainer

            Description
            -----------
            This example will stop all containers hosted on the current computer.
        .NOTES
            If the Container parameter is used, and the status in the object already corresponds to the desired one, no action would be taken unless Force parameter is used.
        .LINK
            Start-DockerContainer
    #>
    [CmdLetBinding(DefaultParameterSetName = "FromName")]
    param(
        [Parameter(ParameterSetName = "FromContainer", Mandatory = $true, ValueFromPipeline = $true)]
        [pscustomobject[]] $Container,
        [Parameter(ParameterSetName = "FromName", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromId", Mandatory = $false)]
        [string[]] $ComputerName = $env:COMPUTERNAME,
        [Parameter(ParameterSetName = "FromName", Mandatory = $false)]
        [string[]] $Name = "",
        [Parameter(ParameterSetName = "FromId", Mandatory = $false)]
        [string[]] $Id = "",
        [Parameter(ParameterSetName = "FromContainer", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromId", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromName", Mandatory = $false)]
        [switch] $Force
    )
    
    begin { Write-Debug ($script:LocalizedData.Global.Debug.Entering -f $PSCmdlet.MyInvocation.MyCommand) }
    process
    {
        try { Control-DockerContainer @PSBoundParameters -Action "Stop" }
        catch { Write-Error $_ }
    }
    end { Write-Debug ($script:LocalizedData.Global.Debug.Leaving -f $PSCmdlet.MyInvocation.MyCommand) }
}