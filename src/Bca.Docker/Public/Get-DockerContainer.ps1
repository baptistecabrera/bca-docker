function Get-DockerContainer
{
    <#
        .SYNOPSIS
            Gets a Docker container.
        .DESCRIPTION
            Gets a Docker container.
        .PARAMETER Name
            An array of strings containing the name(s) of the container(s) to get.
            This parameter accepts wildcard character ('*').
        .PARAMETER Id
            An array of strings containing the id(s) of the container(s) to get.
            This can be the shorten or full id.
            This parameter accepts wildcard character ('*').
        .PARAMETER ComputerName
            Am array of string containing the computer(s) where the containers are hosted.
        .PARAMETER IncludeExtendedProperties
            A switch specifying whether or not to retrieve extended properties.
        .PARAMETER Credential
            A PSCredential used to connect to the host.
        .PARAMETER Authentication
            An AuthenticationMechanism that will be used to authenticate the user's credentials
        .OUTPUTS
            System.Management.Automation.PSCustomObject
            Returns a PSCustomObject containing the containers.
        .EXAMPLE
            Get-DockerContainer -Name MyDocker* -ComputerName MyHostServer01, MyHostServer02

            Description
            -----------
            This example will get the containers whose name match 'MyDocker*' on computers 'MyHostServer01' and 'MyHostServer02'.
        .EXAMPLE
            Get-DockerContainer -Id 97590b5306b9, 4f657b6d8066b87455303c591873b0739aa14f589cd56365a46a256f726c6be0 -ComputerName MyHostServer

            Description
            -----------
            This example will get the containers with IDs '97590b5306b9' and '4f657b6d8066b87455303c591873b0739aa14f589cd56365a46a256f726c6be0' on computer 'MyHostServer'.
        .NOTES
            Extended properties correspond to a docker container inspect command.
    #>
    [CmdLetBinding(DefaultParameterSetName = "FromName")]
    param(
        [Parameter(ParameterSetName = "FromName", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromId", Mandatory = $false)]
        [Alias("Cn")]
        [string[]] $ComputerName = $env:COMPUTERNAME,
        [Parameter(ParameterSetName = "FromName", Mandatory = $false)]
        [string[]] $Name = "",
        [Parameter(ParameterSetName = "FromId", Mandatory = $false)]
        [string[]] $Id = "",
        [Parameter(ParameterSetName = "FromId", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromName", Mandatory = $false)]
        [switch] $IncludeExtendedProperties,
        [Parameter(ParameterSetName = "FromId", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromName", Mandatory = $false)]
        [pscredential] $Credential,
        [Parameter(ParameterSetName = "FromId", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromName", Mandatory = $false)]
        [ValidateSet("Basic", "Default", "Credssp", "Digest", "Kerberos", "Negotiate", "NegotiateWithImplicitCredential")]
        [System.Management.Automation.Runspaces.AuthenticationMechanism] $Authentication = "Default"
    )

    Write-Debug ($script:LocalizedData.Global.Debug.Entering -f $PSCmdlet.MyInvocation.MyCommand)
    try 
    {
        $ComputerName | ForEach-Object { 
            $CurrentComputerName = $_
            $Parameters = @{
                ComputerName = $CurrentComputerName
            }
            if ($PSBoundParameters.Credential) { $Parameters.Add("Credential", $Credential) }
            if ($PSBoundParameters.Authentication) { $Parameters.Add("Authentication", $Authentication) }
            Invoke-Command @Parameters -ScriptBlock { Invoke-Expression "docker ps -a --no-trunc" } | Where-Object { ($_ -notlike "CONTAINER ID*") } | ForEach-Object {
                $CurrentContainer = New-Object -TypeName PsObject
                $ContainerProperties = $_ -split "  " | Where-Object { $_ } | ForEach-Object {
                    if ($_.StartsWith(" ")) { $_ = $_.SubString(1) }
                    $_
                }
                $CurrentContainer | Add-Member -MemberType NoteProperty -Name Id -Value $ContainerProperties[0].SubString(0, 12) -PassThru | Out-Null
                $CurrentContainer | Add-Member -MemberType NoteProperty -Name FullId -Value $ContainerProperties[0] -PassThru | Out-Null
                $CurrentContainer | Add-Member -MemberType NoteProperty -Name Name -Value $ContainerProperties[$ContainerProperties.Count - 1] -PassThru | Out-Null
                $CurrentContainer | Add-Member -MemberType NoteProperty -Name Command -Value ($ContainerProperties | Where-Object { $_ -like """*""" }) -PassThru | Out-Null
                $CommandIndex = [array]::IndexOf($ContainerProperties, $CurrentContainer.Command)
                if ($ContainerProperties[$CommandIndex - 1] -ne $CurrentContainer.LongId) { $CurrentContainer | Add-Member -MemberType NoteProperty -Name Image -Value $ContainerProperties[$CommandIndex -1] -PassThru | Out-Null }
                $CurrentContainer | Add-Member -MemberType NoteProperty -Name Created -Value $ContainerProperties[$CommandIndex + 1] -PassThru | Out-Null
                $CurrentContainer | Add-Member -MemberType NoteProperty -Name Status -Value $ContainerProperties[$CommandIndex + 2].Split(" ")[0] -PassThru | Out-Null
                $CurrentContainer | Add-Member -MemberType NoteProperty -Name FullStatus -Value $ContainerProperties[$CommandIndex + 2] -PassThru | Out-Null
                if ($ContainerProperties[$CommandIndex + 3] -ne $CurrentContainer.Name) { $Port = $ContainerProperties[$CommandIndex + 3] }
                $CurrentContainer | Add-Member -MemberType NoteProperty -Name Port -Value $Port -PassThru | Out-Null
                $CurrentContainer | Add-Member -MemberType NoteProperty -Name ComputerName -Value $CurrentComputerName -PassThru | Out-Null
                if ((!$Name -and !$Id) -or ($Name -and (($CurrentContainer.Name -in $Name) -or ($CurrentContainer.Name -like $Name))) -or ($Id -and (($CurrentContainer.Id -in $Id) -or ($CurrentContainer.FullId -in $Id) -or ($CurrentContainer.Id -like $Id) -or ($CurrentContainer.FullId -like $Id)))) 
                {
                    if ($IncludeExtendedProperties)
                    {
                        $ExtendedProperties = Invoke-Command @Parameters -ScriptBlock {
                            param([string] $ContainerId)
                            Invoke-Expression "docker inspect $ContainerId"
                        } -ArgumentList $CurrentContainer.Id 
                        $ExtendedProperties = $ExtendedProperties | ConvertFrom-Json
                        if ($ExtendedProperties.Created) { $ExtendedProperties | Add-Member -MemberType NoteProperty -Name Created -Value (Get-Date $ExtendedProperties.Created) -PassThru -Force | Out-Null }
                        if ($ExtendedProperties.State.StartedAt) { $ExtendedProperties.State | Add-Member -MemberType NoteProperty -Name StartedAt -Value (Get-Date $ExtendedProperties.State.StartedAt) -PassThru -Force | Out-Null }
                        if ($ExtendedProperties.State.FinishedAt) { $ExtendedProperties.State | Add-Member -MemberType NoteProperty -Name FinishedAt -Value (Get-Date $ExtendedProperties.State.FinishedAt) -PassThru -Force | Out-Null }
                        if ($ExtendedProperties.Config.Labels.'com.docker.compose.version') { $ExtendedProperties.Config.Labels | Add-Member -MemberType NoteProperty -Name 'com.docker.compose.version' -Value ([version]($ExtendedProperties.Config.Labels.'com.docker.compose.version')) -PassThru -Force | Out-Null }
                        $CurrentContainer | Add-Member -MemberType NoteProperty -Name ExtendedProperties -Value $ExtendedProperties  -PassThru | Out-Null
                    }
                    $CurrentContainer
                }
            }
        }
    }
    catch
    {
        Write-Error $_
    }
    finally
    {
        Write-Debug ($script:LocalizedData.Global.Debug.Leaving -f $PSCmdlet.MyInvocation.MyCommand)
    }
}