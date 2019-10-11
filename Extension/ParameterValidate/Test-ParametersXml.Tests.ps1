param (
    $Path
)
Describe "Testing Parameters.xml against their web or app config files" {

    foreach ($File in (Get-ChildItem -Path $Path -Filter parameters.xml -Recurse)) {

        Context "Testing $($File.Directory.Basename) parameters and config file" {

            $ParameterContent = [xml](Get-Content -Path $File.FullName -Raw)
            $ConfigFile = Get-ChildItem -Path $File.Directory.FullName -Filter *.config | Where-Object Name -match '^app\.config$|^web\.config$'
            $ConfigContent = [xml](Get-Content -Path $ConfigFile.FullName)

            foreach ($Parameter in $ParameterContent.Parameters.parameter.Where({$_.ParameterEntry.Scope -match 'Web\.|app\.'})) {
                It "Should have a parameter to be replaced by $($Parameter.Name) in $($ConfigFile.Directory.BaseName) $($ConfigFile.Name)" {
                    foreach ($entry in $Parameter.ParameterEntry) {
                        $ConfigContent.SelectSingleNode(($Entry.Match -replace '\/text\(\)')) | Should -Not -BeNullOrEmpty
                    }
                }
            }

            foreach ($Parameter in $ParameterContent.Parameters.parameter.Where({$_.ParameterEntry.Scope -notmatch 'Web\.|app\.' -and $_.ParameterEntry.Match -notmatch '\/@\w+$'})) {
                $ConfigFile = Get-ChildItem -Path $File.Directory.FullName -Filter $Parameter.ParameterEntry.Scope.replace('\', '')
                $ConfigContent = [xml](Get-Content -Path $ConfigFile.FullName)

                It "Should have a parameter to be replaced by $($Parameter.Name) in $($ConfigFile.Directory.BaseName) $($ConfigFile.Name)" {
                    foreach ($entry in $Parameter.ParameterEntry) {
                        $ConfigContent.SelectSingleNode(($Entry.Match -replace '\/text\(\)')) | Should -Not -BeNullOrEmpty
                    }
                }
            }
        }
    }
}
