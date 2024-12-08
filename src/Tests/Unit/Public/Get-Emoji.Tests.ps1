BeforeDiscovery {
    Set-Location -Path $PSScriptRoot
    $ModuleName = 'pwshEmojiExplorer'
    $PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
    #if the module is already in memory, remove it
    Get-Module $ModuleName -ErrorAction SilentlyContinue | Remove-Module -Force
    Import-Module $PathToManifest -Force
}

InModuleScope 'pwshEmojiExplorer' {

    Describe 'Get-Emoji Public Function Tests' -Tag Unit {

        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            . $PSScriptRoot\..\..\asset\emojiTestData.ps1
            $script:glData = $emojiTestData
        } #beforeAll

        Context 'Error' {

            It 'should return null when the data set is not available' {
                Mock -CommandName 'Import-XMLDataSet' -MockWith {
                    return $false
                } #endMock
                Get-Emoji -Emoji '😀' | Should -BeNullOrEmpty
            } #it

            It 'should return null if the data set contains objects with incorrect data types' {
                Mock -CommandName 'Import-XMLDataSet' -MockWith {
                    return $true
                } #endMock
                Mock -CommandName 'ConvertTo-PSEmoji' -MockWith {
                    throw 'fake error'
                } #endMock
                Get-Emoji -Decimal 128512 | Should -BeNullOrEmpty
            } #it

        } #context_Error

        Context 'Success' {

            BeforeEach {
                Mock -CommandName 'Import-XMLDataSet' -MockWith {
                    return $true
                } #endMock
                Mock -CommandName 'ConvertTo-PSEmoji' -MockWith {
                    $testEmoji
                } #endMock
            } #beforeEach

            It 'should import the xml data set' {
                Get-Emoji -Group 'Food & Drink'
                Should -Invoke -CommandName 'Import-XMLDataSet' -Exactly -Times 1 -Scope 'It'
            } #it

            It 'should return the expected object type' {
                # https://github.com/pester/Pester/issues/1315
                $emojis = Get-Emoji -SubGroup 'food-vegetable'
                ($emojis[0]).GetType().Name | Should -Be 'PSEmoji'
            } #it

            It 'should convert the expected number of objects for HexCodePoint' {
                Get-Emoji -HexCodePoint '1F600'
                Should -Invoke -CommandName 'ConvertTo-PSEmoji' -Exactly -Times 1 -Scope 'It'
            } #it

            Context 'Results Counts - exact' {

                It 'should return the expected number of objects for Emoji' {
                    (Get-Emoji -Emoji '😀').Count | Should -Be 1
                } #it

                It 'should return the expected number of objects for Group' {
                    (Get-Emoji -Group 'Food & Drink').Count | Should -Be 8
                } #it

                It 'should return the expected number of objects for SubGroup' {
                    (Get-Emoji -SubGroup 'food-vegetable').Count | Should -Be 3
                } #it

                It 'should return the expected number of objects for ShortCode' {
                    (Get-Emoji -ShortCode ':smiling_face_with_hearts:').Count | Should -Be 1
                } #it

                It 'should return the expected number of objects for HexCodePoint' {
                    (Get-Emoji -HexCodePoint '1F600').Count | Should -Be 1
                } #it

                It 'should return the expected number of objects for Decimal' {
                    (Get-Emoji -Decimal 128512).Count | Should -Be 1
                } #it

                It 'should return the expected number of objects for Decimal with multiple decimal values' {
                    (Get-Emoji -Decimal '127812', '8205', '129003').Count | Should -Be 1
                } #it

                It 'should return no objects if no decimal values are found' {
                    (Get-Emoji -Decimal '123456').Count | Should -Be 0
                } #it

                It 'should return the expected number of objects for SearchTerm' {
                    (Get-Emoji -SearchTerm 'fork').Count | Should -Be 2
                } #it

                It 'should return the expected number of objects for SearchTerm with IncludeAll' {
                    (Get-Emoji -SearchTerm 'fork' -IncludeAll).Count | Should -Be 3
                } #it

            } #context_exact_ResultCounts

            Context 'Results Counts - relaxed' {

                It 'should return the expected number of objects for wildcard Group' {
                    (Get-Emoji -Group '*food*').Count | Should -Be 8
                } #it

                It 'should return the expected number of objects for general Group' {
                    (Get-Emoji -Group 'food').Count | Should -Be 8
                } #it

                It 'should return the expected number of objects for wildcard SubGroup' {
                    (Get-Emoji -SubGroup '*vegetable*').Count | Should -Be 3
                } #it

                It 'should return the expected number of objects for general SubGroup' {
                    (Get-Emoji -SubGroup 'vegetable').Count | Should -Be 3
                } #it

                It 'should return the expected number of objects for wildcard ShortCode' {
                    (Get-Emoji -ShortCode '*smiling*').Count | Should -Be 1
                } #it

                It 'should return the expected number of objects for general ShortCode' {
                    (Get-Emoji -ShortCode 'smiling').Count | Should -Be 1
                } #it

                It 'should return the expected number of objects for general HexCodePoint' {
                    (Get-Emoji -HexCodePoint '1F7E9').Count | Should -Be 1
                } #it

            } #context_range_ResultCounts

        } #context_Success

    } #describe_Get-Emoji

} #inModule
