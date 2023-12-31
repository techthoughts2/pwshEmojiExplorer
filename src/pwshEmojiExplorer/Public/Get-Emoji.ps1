<#
.SYNOPSIS
    Retrieves a specific emoji or a list of emojis based on various search criteria.
.DESCRIPTION
    The Get-Emoji function allows users to retrieve emojis by specifying one or more search criteria such as Emoji, Group, SubGroup, ShortCode, HexCodePoint, Decimal, or a general SearchTerm. The function supports both exact and relaxed search terms. Exact search terms provide quick and efficient results, while relaxed search terms perform a more comprehensive search across relevant fields.
.EXAMPLE
    Get-Emoji -Emoji '😀'

    Retrieves the emoji specified by the direct emoji character.
.EXAMPLE
    Get-Emoji -Group 'Food & Drink'

    Retrieves all emojis under the exact 'Food & Drink' group.
.EXAMPLE
    Get-Emoji -Group 'food'

    Performs a relaxed search and retrieves all emojis in groups containing the word 'food'.
.EXAMPLE
    Get-Emoji -SubGroup 'food-vegetable'

    Retrieves all emojis under the exact 'food-vegetable' subgroup.
.EXAMPLE
    Get-Emoji -SubGroup 'vegetable'

    Performs a relaxed search and retrieves all emojis in subgroups containing the word 'vegetable'.
.EXAMPLE
    Get-Emoji -ShortCode ':smiling_face_with_hearts:'

    Retrieves the emoji with the exact shortcode ':smiling_face_with_hearts:'.
.EXAMPLE
    Get-Emoji -ShortCode 'smiling'

    Performs a relaxed search and retrieves all emojis with shortcodes containing 'smiling'.
.EXAMPLE
    Get-Emoji -HexCodePoint '1F600'

    Retrieves the emoji with the hexadecimal code point '1F600'.
.EXAMPLE
    Get-Emoji -Decimal 128512

    Retrieves the emoji with the exact decimal code '128512'.
.EXAMPLE
    Get-Emoji -Decimal '127812', '8205', '129003'

    Retrieves emojis that match all the specified decimal codes.
.EXAMPLE
    Get-Emoji -SearchTerm 'fork'

    Performs a general search and retrieves all emojis where 'fork' is found in the group, subgroup, or description.
.EXAMPLE
    Get-Emoji -SearchTerm 'plane' -IncludeAll

    Performs a general search and retrieves all emojis where 'plane' is found in the group, subgroup, or description. Includes all emojis in the output, regardless of their qualification status.
.EXAMPLE
    .EXAMPLE
    Get-Emoji -SearchTerm 'fork' | Where-Object {$_.Group -eq 'Food & Drink'}

    This example shows how to retrieve all emojis with 'fork' in their group, subgroup, or description, and then filters the results to include only those in the 'Food & Drink' group.
.PARAMETER Emoji
    Specifies the emoji character to retrieve. Use an exact emoji character for a direct match.
.PARAMETER Group
    Specifies the group of emojis to retrieve.
.PARAMETER SubGroup
    Specifies the subgroup of emojis to retrieve.
.PARAMETER ShortCode
    Specifies the shortcode of the emoji to retrieve.
.PARAMETER HexCodePoint
    Specifies the hexadecimal code point of the emoji to retrieve.
.PARAMETER Decimal
    Specifies the decimal code of the emoji to retrieve.
.PARAMETER SearchTerm
    Specifies a general search term to find emojis. Searches across group, subgroup, and description fields using a relaxed search approach.
.PARAMETER IncludeAll
    Includes all emojis in the output, regardless of their qualification status. By default, only 'fully-qualified' emojis are returned.
.OUTPUTS
    PSEmoji
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
    Qualification levels:
        - Fully-qualified — a complete, standard emoji
        - Minimally-qualified — a basic form of an emoji, often lacking detail
        - Unqualified — a raw, unrefined form of an emoji

    This function uses the Public data set from the Unicode Data Files and adheres to the Unicode Terms of Use:
        https://www.unicode.org/copyright.html
        https://www.unicode.org/license.txt
.COMPONENT
    pwshEmojiExplorer
.LINK
    https://pwshEmojiExplorer.readthedocs.io/en/latest/Get-Emoji/
.LINK
    https://www.unicode.org/license.txt
#>
function Get-Emoji {
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = 'Name',
            HelpMessage = 'Specifies the emoji character to retrieve. Use an exact emoji character for a direct match')]
        # validate to contain only letters
        [ValidatePattern('\p{So}|\p{Cs}')]
        [string]$Emoji,

        [Parameter(ParameterSetName = 'Group',
            HelpMessage = 'Specifies the group of emojis to retrieve')]
        [ArgumentCompleter({ GroupArgumentCompleter @args })]
        [string]$Group,

        [Parameter(ParameterSetName = 'SubGroup',
            HelpMessage = 'Specifies the subgroup of emojis to retrieve')]
        [ArgumentCompleter({ SubgroupArgumentCompleter @args })]
        [string]$SubGroup,

        [Parameter(ParameterSetName = 'ShortCode',
            HelpMessage = 'Specifies the shortcode of the emoji to retrieve')]
        [ArgumentCompleter({ ShortCodeCompleter @args })]
        [string]$ShortCode,

        [Parameter(ParameterSetName = 'Hex',
            HelpMessage = 'Specifies the hexadecimal code point of the emoji to retrieve')]
        [ValidatePattern('^[0-9A-Fa-f]{4,6}( [0-9A-Fa-f]{4,6})*$')]
        [string]$HexCodePoint,

        [Parameter(ParameterSetName = 'Decimal',
            HelpMessage = 'Specifies the decimal code point of the emoji to retrieve')]
        # [ValidatePattern('^\d+(\s*,\s*\d+){0,4}$')]
        [ValidatePattern('^\d+$')]
        [string[]]$Decimal,

        [Parameter(ParameterSetName = 'Search',
            HelpMessage = 'Enter a search term to find in the group, subgroup, or description.')]
        [ValidatePattern('^[a-zA-Z0-9\s\p{P}]+$')]
        [string]$SearchTerm,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Includes all emojis in the output')]
        [switch]$IncludeAll
    )

    Write-Verbose -Message 'Verifying XML Data Set Availability...'
    if (Import-XMLDataSet) {
        Write-Verbose -Message 'Verified.'

        $dataSet = $script:glData
        # declare object array empty list
        $finalEmojiList = New-Object System.Collections.Generic.List[PSEmoji]

        if ($Emoji) {
            Write-Verbose -Message ('Searching for emoji: {0}' -f $Emoji)
            $find = $dataSet | Where-Object { $_.Name -eq $Emoji }
        }
        elseif ($Group) {
            Write-Verbose -Message ('Searching for emojis in group: {0}' -f $Group)
            if ($Group -like '*`**') {
                Write-Verbose -Message '....Processing wildcard search...'
                $find = $dataSet | Where-Object { $_.Group -like $Group }
            }
            else {
                Write-Verbose -Message '....Processing exact search...'
                $find = $dataSet | Where-Object { $_.Group -eq $Group }
                if ([string]::IsNullOrEmpty($find)) {
                    Write-Verbose -Message '........Processing relaxed search...'
                    $find = $dataSet | Where-Object { $_.Group -like "*$Group*" }
                }
            }
        }
        elseif ($SubGroup) {
            Write-Verbose -Message ('Searching for emojis in subgroup: {0}' -f $SubGroup)
            if ($SubGroup -like '*`**') {
                Write-Verbose -Message '....Processing wildcard search...'
                $find = $dataSet | Where-Object { $_.Subgroup -like $SubGroup }
            }
            else {
                Write-Verbose -Message '....Processing exact search...'
                $find = $dataSet | Where-Object { $_.Subgroup -eq $SubGroup }
                if ([string]::IsNullOrEmpty($find)) {
                    Write-Verbose -Message '........Processing relaxed search...'
                    $find = $dataSet | Where-Object { $_.Subgroup -like "*$SubGroup*" }
                }
            }
        }
        elseif ($ShortCode) {
            # need to properly escape characters in the shortcode string
            $ShortCode = $ShortCode.Replace("'", "’")
            Write-Verbose -Message ('Searching for emojis with shortcode: {0}' -f $ShortCode)
            if ($ShortCode -like '*`**') {
                Write-Verbose -Message '....Processing wildcard search...'
                $find = $dataSet | Where-Object { $_.ShortCode -like $ShortCode }
            }
            else {
                Write-Verbose -Message '....Processing exact search...'
                $find = $dataSet | Where-Object { $_.ShortCode -eq $ShortCode }
                if ([string]::IsNullOrEmpty($find)) {
                    Write-Verbose -Message '........Processing relaxed search...'
                    $find = $dataSet | Where-Object { $_.ShortCode -like "*$ShortCode*" }
                }
            }
        }
        elseif ($HexCodePoint) {
            Write-Verbose -Message ('Searching for emojis with hex code point: {0}' -f $HexCodePoint)
            Write-Verbose -Message '....Processing exact search...'
            $find = $dataSet | Where-Object { $_.HexCodePoint -eq $HexCodePoint }
            if ([string]::IsNullOrEmpty($find)) {
                Write-Verbose -Message '........Processing relaxed search...'
                $find = $dataSet | Where-Object { $_.HexCodePoint -like "*$HexCodePoint*" }
            }
        }
        elseif ($Decimal) {
            Write-Verbose -Message ('Searching for emojis with decimal: {0}' -f $Decimal)
            Write-Verbose -Message '....Processing exact search...'

            $decimalCount = $Decimal | Measure-Object | Select-Object -ExpandProperty Count

            # Initialize the list with emojis that match the first decimal number
            $emojiList = $dataSet | Where-Object { $_.Decimal -contains $Decimal[0] }
            Write-Debug -Message ('Found {0} emojis with the first decimal number.' -f $emojiList.Count)

            if ($emojiList) {

                if ($decimalCount -eq 1) {
                    Write-Debug -Message 'Only one decimal number was provided.'
                    # special case where there is only one decimal number
                    $find = $emojiList | Where-Object { $_.Decimal.Count -eq 1 }
                }
                else {
                    Write-Debug -Message 'Multiple decimal numbers were provided.'
                    # For each additional decimal number, further refine the list
                    foreach ($dec in $Decimal[1..($Decimal.Length - 1)]) {
                        $emojiList = $emojiList | Where-Object { $_.Decimal -contains $dec }
                    }
                    $find = $emojiList
                }
                Write-Debug -Message ('Find now contains {0} emojis with the decimal numbers.' -f $find.Count)
            }
            else {
                Write-Debug -Message 'No emojis found with the first decimal number.'
            }

        }
        elseif ($SearchTerm) {
            Write-Verbose -Message ('Searching for emojis with search term: {0}' -f $SearchTerm)
            Write-Verbose -Message '....Processing general wildcard search...'
            $find = $dataSet | Where-Object { $_.Group -like "*$SearchTerm*" -or $_.Subgroup -like "*$SearchTerm*" -or $_.Description -like "*$SearchTerm*" }
        }
    } #if_Import-XMLDataSet
    else {
        Write-Warning -Message 'pwshEmojiExplorer was unable to source the required data set file.'
        Write-Warning -Message 'Ensure you have an active internet connection'
        return
    } #else_Import-XMLDataSet

    Write-Debug -Message ('Found {0} emojis' -f $find.Count)

    if ($IncludeAll -eq $false) {
        $results = $find | Where-Object { $_.Status -eq 'fully-qualified' }
    }
    else {
        $results = $find
    }

    if ($results) {
        $results | ForEach-Object {
            $convertedEmoji = $null
            try {
                [PSEmoji]$convertedEmoji = ConvertTo-PSEmoji -CustomObject $_
            }
            catch {
                Write-Warning -Message ('Unable to convert the custom object {0} to a PSEmoji object.' -f $_.Description)
            }

            [void]$finalEmojiList.Add($convertedEmoji)
        }
    }

    Write-Debug -Message ('Results: {0}' -f $results.Count)

    return $finalEmojiList
} #Get-Emoji
