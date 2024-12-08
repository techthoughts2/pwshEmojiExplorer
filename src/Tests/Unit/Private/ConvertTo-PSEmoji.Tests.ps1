BeforeDiscovery {
    Set-Location -Path $PSScriptRoot
    $ModuleName = 'pwshEmojiExplorer'
    $PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
    #if the module is already in memory, remove it
    Get-Module $ModuleName -ErrorAction SilentlyContinue | Remove-Module -Force
    Import-Module $PathToManifest -Force
}

InModuleScope 'pwshEmojiExplorer' {

    Describe 'ConvertTo-PSEmoji' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'

            . $PSScriptRoot\..\..\asset\emojiTestData.ps1
        } #before_all

        BeforeEach {

        } #before_each

        Context 'Error' {

            It 'should not throw an error if the custom object is malformed' {
                { ConvertTo-PSEmoji -CustomObject $badCustomObject } | Should -Not -Throw
            } #it

            It 'shoulld have null values if the custom object is malformed' {
                $emoji = ConvertTo-PSEmoji -CustomObject $badCustomObject
                $emoji.Group | Should -BeNullOrEmpty
                $emoji.Subgroup | Should -BeNullOrEmpty
                $emoji.HexCodePoint | Should -BeNullOrEmpty
                $emoji.Status | Should -BeNullOrEmpty
                $emoji.Name | Should -BeNullOrEmpty
                $emoji.Version | Should -BeNullOrEmpty
                $emoji.Description | Should -BeNullOrEmpty
                $emoji.ShortCode | Should -BeNullOrEmpty
                $emoji.HexCodePointArray | Should -BeNullOrEmpty
                $emoji.UnicodeStandard | Should -BeNullOrEmpty
                $emoji.HTMLEntityFormat | Should -BeNullOrEmpty
                $emoji.pwshEscapedFormat | Should -BeNullOrEmpty
                $emoji.Decimal | Should -BeNullOrEmpty
            } #it

            It 'should throw an error if the custom object is not the expected type' {
                { ConvertTo-PSEmoji -CustomObject $badDataTypeCustomObject } | Should -Throw
            } #it

        } #context_Error

        Context 'Success' {

            It 'should return the expected object type' {
                # https://github.com/pester/Pester/issues/1315
                (ConvertTo-PSEmoji -CustomObject $customObject).GetType().Name | Should -Be 'PSEmoji'
            } #it

            It 'should return the expected values' {
                $emoji = ConvertTo-PSEmoji -CustomObject $customObject
                $emoji.Group | Should -BeExactly 'Smileys & Emotion'
                $emoji.Subgroup | Should -BeExactly 'face-smiling'
                $emoji.HexCodePoint | Should -BeExactly '1F600'
                $emoji.Status | Should -BeExactly 'fully-qualified'
                $emoji.Name | Should -BeExactly '😀'
                $emoji.Version | Should -BeExactly 'E1.0'
                $emoji.Description | Should -BeExactly 'grinning face'
                $emoji.ShortCode | Should -BeExactly ':grinning_face:'
                $emoji.HexCodePointArray | Should -BeExactly @('1F600')
                $emoji.UnicodeStandard | Should -BeExactly 'Unicode 6.0'
                $emoji.HTMLEntityFormat | Should -BeExactly '&#x1F600;'
                $emoji.pwshEscapedFormat | Should -BeExactly '`u{1F600}'
                $emoji.Decimal | Should -BeExactly @('128512')
            } #it

        } #context_Success

    } #describe_ConvertTo-PSEmoji

} #inModule
