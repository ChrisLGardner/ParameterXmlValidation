Import-Module $PSScriptRoot\ps_modules\VstsTaskSdk
Import-Module $PSScriptRoot\ps_modules\Pester

$Path = Get-VstsInput -Name Path -Require
$FailTask = Get-VstsInput -Name failTaskOnFailedTests -AsBool
$TestRunTitle = Get-VstsInput -Name testRunTitle

$PesterSplat = @{
    OutputFile = "$Env:Agent_TempDirectory\ValidateParameters.xml"
    OutputFormat = NUnitXml
    Script = @{
        Path = "$PSScriptRoot\Test-ParametersXml.Tests.ps1"
        Parameters = @{
            Path = $Path
        }
    }
    PassThru = $true
}

$Results = Invoke-Pester @PesterSplat

$TestProperties = @{
    Type = 'NUnit'
    ResultsFile = "$Env:Agent_TempDirectory\ValidateParameters.xml"
}

if ([String]::IsNullOrWhiteSpace($TestRunTitle)) {
    $TestRunTitle = "ValidateParameters.Xml - $Env:Build_DefinitionName"
}

$TestProperties.Add("RunTitle", $TestRunTitle)

$TaskMessage = & (Get-Module VstsTaskSdk) {Write-LoggingCommand -Area 'results' -Event 'publish' -Properties $TestProperties -AsOutput}

Write-Host $TaskMessage

if ($FailTask -and $Results.FailedCount -gt 0) {
    Write-TaskError -Message "One or more parameters failed to validate. Please check the Test Results or the task logs for more details"
}
