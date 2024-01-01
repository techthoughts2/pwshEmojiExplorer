#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'pwshEmojiExplorer'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------

InModuleScope 'pwshEmojiExplorer' {

    Describe 'Convert-EmojiToHexCodePoint' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #before_all

        BeforeEach {

        } #before_each

        # Context 'Error' {

        # } #context_Error

        Context 'Success' {

            It 'should return the expected object type' {
                # https://github.com/pester/Pester/issues/1315
                Convert-EmojiToHexCodePoint -Emoji '😀' | Should -BeOfType [System.String]
            } #it

            It 'should return the expected values' {
                $emoji = Convert-EmojiToHexCodePoint -Emoji '😀'
                $emoji | Should -BeExactly '1F600'
            } #it

        } #context_Success

    } #describe_Convert-EmojiToHexCodePoint

} #inModule
