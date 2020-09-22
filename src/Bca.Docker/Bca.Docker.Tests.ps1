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