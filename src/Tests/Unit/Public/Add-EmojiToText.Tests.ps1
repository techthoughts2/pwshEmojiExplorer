BeforeDiscovery {
    Set-Location -Path $PSScriptRoot
    $ModuleName = 'pwshEmojiExplorer'
    $PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
    #if the module is already in memory, remove it
    Get-Module $ModuleName -ErrorAction SilentlyContinue | Remove-Module -Force
    Import-Module $PathToManifest -Force
}

InModuleScope 'pwshEmojiExplorer' {

    Describe 'Add-EmojiToText Public Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            . $PSScriptRoot\..\..\asset\emojiTestData.ps1
            $script:glData = $emojiTestData
        } #beforeAll
        # Context 'Error' {

        # } #context_Error
        Context 'Success' {

            BeforeEach {
                Mock -CommandName 'Get-Emoji' -MockWith {
                    [PSCustomObject]@{
                        Group        = 'Travel & Places'
                        Subgroup     = 'place-map'
                        HexCodePoint = '1F5FA FE0F'
                        Status       = 'fully-qualified'
                        Name         = '🗺️'
                    }
                } #endMock
            } #beforeEach

            It 'Adds an emoji to the text' {
                $result = Add-EmojiToText -Text "World!"
                $result | Should -Be "World! 🗺️"
            } #it

            It 'Returns the original text when no emoji is provided' {
                Mock -CommandName 'Get-Emoji' -MockWith { }
                $result = Add-EmojiToText -Text "Hello, world!"
                $result | Should -Be "Hello, world!"
            } #it

            It 'should replace the word with the emoji when the -Replace switch is used' {
                $result = Add-EmojiToText -Text "World" -Replace
                $result | Should -Be "🗺️"
            } #it

            It 'should not try to add emojis for stop words' {
                Mock -CommandName 'Get-Emoji' -MockWith { }
                Add-EmojiToText -Text "and"
                Should -Invoke -CommandName 'Get-Emoji' -Exactly -Times 0 -Scope 'It'
            } #it

        } #context_Success

    } #describe_Add-EmojiToText

} #inModule
