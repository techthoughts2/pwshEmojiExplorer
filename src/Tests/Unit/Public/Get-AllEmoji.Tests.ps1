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

    Describe 'Get-AllEmoji Public Function Tests' -Tag Unit {

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
                Get-AllEmoji | Should -BeNullOrEmpty
            } #it

            It 'should return null if the data set contains objects with incorrect data types' {
                Mock -CommandName 'Import-XMLDataSet' -MockWith {
                    return $true
                } #endMock
                Mock -CommandName 'ConvertTo-PSEmoji' -MockWith {
                    throw 'fake error'
                } #endMock
                Get-AllEmoji | Should -BeNullOrEmpty
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
                Get-AllEmoji
                Should -Invoke -CommandName 'Import-XMLDataSet' -Exactly -Times 1 -Scope 'It'
            } #it

            It 'should return the expected object type' {
                # https://github.com/pester/Pester/issues/1315
                $emojis = Get-AllEmoji
                ($emojis[0]).GetType().Name | Should -Be 'PSEmoji'
            } #it

            It 'should convert the expected number of objects' {
                Get-AllEmoji
                Should -Invoke -CommandName 'ConvertTo-PSEmoji' -Exactly -Times 11 -Scope 'It'
            } #it

            It 'should return the expected number of objects' {
                (Get-AllEmoji).Count | Should -Be 11
            } #it

            It 'should return the expected number of objects if only unqualified objects are in the dataset' {
                Mock -CommandName 'ConvertTo-PSEmoji' -MockWith {
                    $testEmoji2
                } #endMock
                (Get-AllEmoji).Count | Should -Be 0
            } #it

            It 'should return the expected number of objects when IncludeAll is specified' {
                Mock -CommandName 'ConvertTo-PSEmoji' -MockWith {
                    $testEmoji2
                } #endMock
                (Get-AllEmoji -IncludeAll).Count | Should -Be 11
            } #it

        } #context_Success

    } #describe_Get-AllEmoji

} #inModule
