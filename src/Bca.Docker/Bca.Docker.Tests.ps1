if (Test-Path (Join-Path $PSScriptRoot LocalizedData))
{
    $global:TestLocalizedData = Import-LocalizedData -BaseDirectory (Join-Path $PSScriptRoot LocalizedData) -ErrorAction SilentlyContinue
    if (!$?) { $global:TestLocalizedData = Import-LocalizedData -UICulture en-US -BaseDirectory (Join-Path $PSScriptRoot LocalizedData) }
}

Describe $global:TestLocalizedData.Module.Describe {
    BeforeAll {
        $ParentDirectory = Split-Path $PSScriptRoot -Parent
        $Directory = Split-Path $PSScriptRoot -Leaf

        if ([version]::TryParse($Directory, [ref]$null)) { $ModuleName = Split-Path $ParentDirectory -Leaf }
        else { $ModuleName = $Directory }
    }

    It $global:TestLocalizedData.Module.ImportModule {
        try
        {
            Import-Module (Join-Path $PSScriptRoot ("{0}.psd1" -f $ModuleName)) -Force
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }
    
    It $global:TestLocalizedData.Module.CommandCheck {
        $Commands = Get-Command -Module $ModuleName
        $Commands.Count | Should -BeGreaterThan 0
    }
}

Describe $global:TestLocalizedData.StopDocker.Describe {
    BeforeAll {
        $Credential = New-Object -TypeName System.Management.Automation.PSCredential ("User", (ConvertTo-SecureString "P4ssW0rd!" -AsPlainText -Force))

        $Server = "MyHost"
        $Servers = @("MyHost", "MyOtherHost")
        $Name = "MyContainer"
        $Names = @("MyContainer", "MyOtherCOntainer")
        $Id = "123456"
        $Ids = @("123456", "789012")
        $FullId = -join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 64  | % { [char]$_ })
        $FullIds = @(( -join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 64  | % { [char]$_ })), ( -join ((0x30..0x39) + ( 0x41..0x5A) + ( 0x61..0x7A) | Get-Random -Count 64  | % { [char]$_ })))
        $Container = New-Object -TypeName PSCustomObject @{
            FullId       = $FullId;
            Name         = $Name
            ComputerName = $Server
        }
        $Containers = @()
        $i = 0
        $FullIds | ForEach-Object {
            $CurrentContainer = New-Object -TypeName PSCustomObject @{
                FullId       = $_;
                Name         = $Names[$i]
                ComputerName = $Server
            }
            $Containers += $CurrentContainer
            $i++
        }
    }

    It $global:TestLocalizedData.StopDocker.FromName {
        try
        {
            Stop-DockerContainer -Name $Name -ComputerName $Server -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }

    It $global:TestLocalizedData.StopDocker.FromName {
        try
        {
            Stop-DockerContainer -Name $Names -ComputerName $Servers -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }

    It $global:TestLocalizedData.StopDocker.FromId {
        try
        {
            Stop-DockerContainer -Id $Id -ComputerName $Server -Credential $Credential -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }

    It $global:TestLocalizedData.StopDocker.FromId {
        try
        {
            Stop-DockerContainer -Id $Ids -ComputerName $Servers -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }

    It $global:TestLocalizedData.StopDocker.FromContainer {
        try
        {
            Stop-DockerContainer -Container $Container -Credential $Credential -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }

    It $global:TestLocalizedData.StopDocker.FromContainer {
        try
        {
            $Containers | Stop-DockerContainer -Credential $Credential -Authentication "Default" -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }
}

Describe $global:TestLocalizedData.StartDocker.Describe {
    BeforeAll {
        $CharReference = "abcdefghijklmnopqrstuvwxyz0123456789".ToCharArray() + "abcdefghijklmnopqrstuvwxyz0123456789".ToCharArray()

        $Credential = New-Object -TypeName System.Management.Automation.PSCredential ("User", (ConvertTo-SecureString "P4ssW0rd!" -AsPlainText -Force))
        $Server = "MyHost"
        $Servers = @("MyHost", "MyOtherHost")
        $Name = "MyContainer"
        $Names = @("MyContainer", "MyOtherCOntainer")
        $Id = "123456"
        $Ids = @("123456", "789012")
        $FullId = ($CharReference | Get-Random -Count 64) -join ''
        $FullIds = @((($CharReference | Get-Random -Count 64) -join ''), (($CharReference | Get-Random -Count 64) -join ''))
        $Container = New-Object -TypeName PSCustomObject @{
            FullId       = $FullId;
            Name         = $Name
            ComputerName = $Server
        }
        $Containers = @()
        $i = 0
        $FullIds | ForEach-Object {
            $CurrentContainer = New-Object -TypeName PSCustomObject @{
                FullId       = $_;
                Name         = $Names[$i]
                ComputerName = $Server
            }
            $Containers += $CurrentContainer
            $i++
        }
    }

    It $global:TestLocalizedData.StartDocker.FromName {
        try
        {
            Start-DockerContainer -Name $Name -ComputerName $Server -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }

    It $global:TestLocalizedData.StartDocker.FromName {
        try
        {
            Start-DockerContainer -Name $Names -ComputerName $Servers -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }

    It $global:TestLocalizedData.StartDocker.FromId {
        try
        {
            Start-DockerContainer -Id $Id -ComputerName $Server -Credential $Credential -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }

    It $global:TestLocalizedData.StartDocker.FromId {
        try
        {
            Start-DockerContainer -Id $Ids -ComputerName $Servers -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }

    It $global:TestLocalizedData.StartDocker.FromContainer {
        try
        {
            Start-DockerContainer -Container $Container -Credential $Credential -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }

    It $global:TestLocalizedData.StartDocker.FromContainer {
        try
        {
            $Containers | Start-DockerContainer -Credential $Credential -Authentication "Default" -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }
}

Describe $global:TestLocalizedData.InvokeCommand.Describe {
    BeforeAll {
        $CharReference = "abcdefghijklmnopqrstuvwxyz0123456789".ToCharArray() + "abcdefghijklmnopqrstuvwxyz0123456789".ToCharArray()

        $Credential = New-Object -TypeName System.Management.Automation.PSCredential ("User", (ConvertTo-SecureString "P4ssW0rd!" -AsPlainText -Force))
        $Server = "MyHost"
        $Servers = @("MyHost", "MyOtherHost")
        $Name = "MyContainer"
        $Names = @("MyContainer", "MyOtherCOntainer")
        $Id = "123456"
        $Ids = @("123456", "789012")
        $FullId = ($CharReference | Get-Random -Count 64) -join ''
        $FullIds = @((($CharReference | Get-Random -Count 64) -join ''), (($CharReference | Get-Random -Count 64) -join ''))
        $Container = New-Object -TypeName PSCustomObject @{
            FullId       = $FullId;
            Name         = $Name
            ComputerName = $Server
        }
        $Containers = @()
        $i = 0
        $FullIds | ForEach-Object {
            $CurrentContainer = New-Object -TypeName PSCustomObject @{
                FullId       = $_;
                Name         = $Names[$i]
                ComputerName = $Server
            }
            $Containers += $CurrentContainer
            $i++
        }

        $ScriptPath = Join-Path ([System.IO.Path]::GetTempPath()) "Test.ps1"
        "Write-Host 'Test" | Set-Content $ScriptPath -Force
    }

    It $global:TestLocalizedData.InvokeCommand.FromContainerCommand {
        try
        {
            Invoke-DockerContainerCommand -Container $Container -Command "Write-Host 'Test'" -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }

    It $global:TestLocalizedData.InvokeCommand.FromContainerScriptBlock {
        try
        {
            $Containers | Invoke-DockerContainerCommand -ScriptBlock { Write-Host 'Test' } -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }

    It $global:TestLocalizedData.InvokeCommand.FromIdExpression {
        try
        {
            Invoke-DockerContainerCommand -ContainerId $FullId -ComputerName $Server -Expression "Write-Host 'Test'" -Credential $Credential -AuthenticationOn Host -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }

    It $global:TestLocalizedData.InvokeCommand.FromIdScript {
        try
        {
            Invoke-DockerContainerCommand -ContainerId $FullId -ComputerName $Server -FilePath $ScriptPath -Credential $Credential -Authentication "Default" -AuthenticationOn Container -WhatIf
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }

    It $global:TestLocalizedData.InvokeCommand.FromIdExpression {
        try
        {
            Invoke-DockerContainerCommand -ContainerId $Id -ComputerName $Server -Expression "Write-Host 'Test'" -Credential $Credential -AuthenticationOn Host, Container -WhatIf -ErrorAction Stop
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $false
    }

}