#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'pwshEmojiExplorer'
#-------------------------------------------------------------------------
#if the module is already in memory, remove it
Get-Module $ModuleName | Remove-Module -Force
$PathToManifest = [System.IO.Path]::Combine('..', '..', 'Artifacts', "$ModuleName.psd1")
#-------------------------------------------------------------------------
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------
Describe 'Integration Tests' -Tag Integration {

    Context 'Add-EmojiToText' {

        It 'should transform text with emoji' {
            $result = Add-EmojiToText -Text 'World!'
            $result | Should -Be 'World! 🗺️'
        } #it

        It 'should not transform text without emoji' {
            $result = Add-EmojiToText -Text 'and'
            $result | Should -Be 'and'
        } #it

        It 'should replace the word with the emoji when the -Replace switch is used' {
            $result = Add-EmojiToText -Text 'World' -Replace
            $result | Should -Be '🗺️'
        } #it

    } #context_add-emojitotext

    Context 'Get-AllEmoji' {

        It 'should return all emoji' {
            # https://github.com/pester/Pester/issues/1315
            $emojis = Get-AllEmoji
            ($emojis[0]).GetType().Name | Should -Be 'PSEmoji'
            $emojis.Count | Should -BeGreaterThan 3000
        } #it

    } #context_get-allemoji

    Context 'Get-Emoji' {

        Context 'Standard' {

            It 'should return the expected object type' {
                # https://github.com/pester/Pester/issues/1315
                $emoji = Get-Emoji -Emoji '😀'
                ($emoji).GetType().Name | Should -Be 'PSEmoji'
            } #it

            It 'should return the expected results for Emoji' {
                $emoji = Get-Emoji -Emoji '😀'
                $emoji.Name | Should -BeExactly '😀'
            } #it

            It 'should return the expected results for Group' {
                $emoji = Get-Emoji -Group 'Food & Drink'
                $emoji.Count | Should -BeGreaterThan 100
            } #it

            It 'should return the expected results for SubGroup' {
                $emoji = Get-Emoji -SubGroup 'food-vegetable'
                $emoji.Count | Should -BeGreaterThan 10
            } #it

            It 'should return the expected results for ShortCode' {
                $emoji = Get-Emoji -ShortCode ':grinning_face:'
                $emoji.Name | Should -BeExactly '😀'
            } #it

            It 'should return the expected results for HexCodePoint' {
                $emoji = Get-Emoji -HexCodePoint '1F600'
                $emoji.Name | Should -BeExactly '😀'
            } #it

            It 'should return the expected results for HexCodePoint with multiple hex values' {
                $emoji = Get-Emoji -HexCodePoint '1F344 200D 1F7EB'
                $emoji.Name | Should -BeExactly '🍄‍🟫'
            } #it

            It 'should return the expected results for Decimal' {
                $emoji = Get-Emoji -Decimal 128512
                $emoji.Name | Should -BeExactly '😀'
            } #it

            It 'should return the expected results for Decimal with multiple decimal values' {
                $emoji = Get-Emoji -Decimal '127812', '8205', '129003'
                $emoji.Name | Should -BeExactly '🍄‍🟫'
            } #it

            It 'should return the expected results for SearchTerm' {
                $emoji = Get-Emoji -SearchTerm 'grin'
                $emoji.Count | Should -BeGreaterThan 2
            } #it
        } #context_standard

        Context 'Relaxed' {

            It 'should return the expected results for Group for a partial match' {
                $emoji = Get-Emoji -Group 'food'
                $emoji.Count | Should -BeGreaterThan 100
            } #it

            It 'should return the expected results for Group for a walidcard match' {
                $emoji = Get-Emoji -Group '*food*'
                $emoji.Count | Should -BeGreaterThan 100
            } #it

            It 'should return the expected results for SubGroup for a partial match' {
                $emoji = Get-Emoji -SubGroup 'vegetable'
                $emoji.Count | Should -BeGreaterThan 10
            } #it

            It 'should return the expected results for SubGroup for a wildcard match' {
                $emoji = Get-Emoji -SubGroup '*vegetable*'
                $emoji.Count | Should -BeGreaterThan 10
            } #it

            It 'should return the expected results for ShortCode for a partial match' {
                $emoji = Get-Emoji -ShortCode 'grinning'
                $emoji.Count | Should -BeGreaterThan 1
            } #it

            It 'should return the expected results for ShortCode for a wildcard match' {
                $emoji = Get-Emoji -ShortCode '*grinning*'
                $emoji.Count | Should -BeGreaterThan 1
            } #it

        } #context_relaxed

    } #context_get-emoji

} #describe_integration_tests
