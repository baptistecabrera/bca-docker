function Start-DockerContainer
{
    <#
        .SYNOPSIS
            Starts a Docker container.
        .DESCRIPTION
            Starts a Docker container.
        .PARAMETER Name
            An array of strings containing the name(s) of the container(s) to start.
            This parameter accepts wildcard character ('*').
        .PARAMETER Id
            An array of strings containing the id(s) of the container(s) to start.
            This can be the shorten or full id.
            This parameter accepts wildcard character ('*').
        .PARAMETER Container
            An array of pscustomobjects containing the containers to start.
        .PARAMETER ComputerName
            An array of string containing the computer(s) where the containers are hosted.
        .PARAMETER Credential
            A PSCredential used to connect to the host.
        .PARAMETER Authentication
            An AuthenticationMechanism that will be used to authenticate the user's credentials
        .PARAMETER Force
            A switch specifying whether or not to force the action.
        .INPUTS
            System.Management.Automation.PSCustomObject
            You can pipe a value for the containers to this cmdlet.
        .OUTPUTS
            System.Management.Automation.PSCustomObject
            Returns a PSCustomObject containing the containers.
        .EXAMPLE
            Start-DockerContainer -Name MyDocker -ComputerName MyHostServer

            Description
            -----------
            This example will start the container named 'MyDocker' on computer 'MyHostServer'.
        .EXAMPLE
            Get-DockerContainer | Start-DockerContainer

            Description
            -----------
            This example will start all containers hosted on the current computer.
        .NOTES
            If the Container parameter is used, and the status in the object already corresponds to the desired one, no action would be taken unless Force parameter is used.
        .LINK
            Stop-DockerContainer
    #>
    [CmdLetBinding(DefaultParameterSetName = "FromName", SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(ParameterSetName = "FromContainer", Mandatory = $true, ValueFromPipeline = $true)]
        [pscustomobject[]] $Container,
        [Parameter(ParameterSetName = "FromName", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromId", Mandatory = $false)]
        [Alias("Cn")]
        [string[]] $ComputerName = $env:COMPUTERNAME,
        [Parameter(ParameterSetName = "FromName", Mandatory = $false)]
        [string[]] $Name = "",
        [Parameter(ParameterSetName = "FromId", Mandatory = $false)]
        [string[]] $Id = "",
        [Parameter(ParameterSetName = "FromContainer", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromId", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromName", Mandatory = $false)]
        [pscredential] $Credential,
        [Parameter(ParameterSetName = "FromContainer", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromId", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromName", Mandatory = $false)]
        [ValidateSet("Basic", "Default", "Credssp", "Digest", "Kerberos", "Negotiate", "NegotiateWithImplicitCredential")]
        [System.Management.Automation.Runspaces.AuthenticationMechanism] $Authentication = "Default",
        [Parameter(ParameterSetName = "FromContainer", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromId", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromName", Mandatory = $false)]
        [switch] $Force
    )
    
    begin { Write-Debug ($script:LocalizedData.Global.Debug.Entering -f $PSCmdlet.MyInvocation.MyCommand) }
    process
    {
        switch -Regex ($PSCmdlet.ParameterSetName)
        {
            "FromContainer" { $Target = $Container.Name -join ", " }
            "FromId" { $Target = $Id -join ", " }
            "FromName" { $Target = $Name -join ", " }
        }
        try { if ($Force -or $PSCmdlet.ShouldProcess($Target)) { Control-DockerContainer @PSBoundParameters -Action "Start" } }
        catch { Write-Error $_ }
    }
    end { Write-Debug ($script:LocalizedData.Global.Debug.Leaving -f $PSCmdlet.MyInvocation.MyCommand) }
}