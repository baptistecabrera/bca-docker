function Control-DockerContainer
{
    <#
        .SYNOPSIS
            Controls a Docker container.
        .DESCRIPTION
            Controls a Docker container.
        .PARAMETER Name
            An array of strings containing the name(s) of the container(s) to control.
            This parameter accepts wildcard character ('*').
        .PARAMETER Id
            An array of strings containing the id(s) of the container(s) to control.
            This can be the shorten or full id.
            This parameter accepts wildcard character ('*').
        .PARAMETER Container
            An array of pscustomobjects containing the containers to control.
        .PARAMETER ComputerName
            An array of string containing the computer(s) where the containers are hosted.
        .PARAMETER Action
            A string containing the action to perform on the conatiner(s).
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
            Control-DockerContainer -Name MyDocker -ComputerName MyHostServer -Action Start

            Description
            -----------
            This example will start the container named 'MyDocker' on computer 'MyHostServer'.
        .EXAMPLE
            Get-DockerContainer | Control-DockerContainer -Action Stop

            Description
            -----------
            This example will stop all containers hosted on the current computer.
        .NOTES
            If the Container parameter is used, and the status in the object already corresponds to the desired one, no action would be taken unless Force parameter is used.
        .LINK
            Start-DockerContainer
        .LINK
            Stop-DockerContainer
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
        [Parameter(ParameterSetName = "FromContainer", Mandatory = $true)]
        [Parameter(ParameterSetName = "FromId", Mandatory = $true)]
        [Parameter(ParameterSetName = "FromName", Mandatory = $true)]
        [ValidateSet("Stop", "Start")]
        [string] $Action,
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

    begin
    {
        Write-Debug ($script:LocalizedData.Global.Debug.Entering -f $PSCmdlet.MyInvocation.MyCommand)
        if ($PSCmdlet.ParameterSetName -ne "FromContainer")
        {
            $Params = $PSBoundParameters
            $Params.Remove("Action") | Out-Null
            $Params.Remove("Force") | Out-Null
            $Container = Get-DockerContainer @Params
        }
        $Action = $Action.ToLower()
        if (!$Force)
        {
            $RequiredStatus = switch ($Action) {
                "stop" { "Exited" }
                "start" { "Up" }
            }
        }
    }
    process
    {
        $Container.ComputerName | Sort-Object -Unique | ForEach-Object {
            try 
            {
                $CurrentComputerName = $_
                # $Container | Where-Object { ($_.ComputerName -eq $CurrentComputerName) -and ($_.Status -eq $RequiredStatus) }
                $FilteredContainer = $Container | Where-Object { ($_.ComputerName -eq $CurrentComputerName) -and ($_.Status -ne $RequiredStatus) }
                if ($FilteredContainer)
                {
                    $Parameters = @{
                        ComputerName = $CurrentComputerName
                    }
                    if ($PSBoundParameters.Credential) { $Parameters.Add("Credential", $Credential) }
                    if ($PSBoundParameters.Authentication) { $Parameters.Add("Authentication", $Authentication) }
                    $Control = Invoke-Command @Parameters -ScriptBlock { Invoke-Expression "docker $($using:Action) $($using:FilteredContainer.Id -join ' ')" }
                    Get-DockerContainer -Id $FilteredContainer.Id -ComputerName $CurrentComputerName
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