<#
.SYNOPSIS
    Retrieves all emojis.
.DESCRIPTION
    The Get-AllEmoji function retrieves a comprehensive list of emojis. By default, the function returns only 'fully-qualified' emojis, which are the most common and widely supported versions. If you need to include 'minimally-qualified' and 'unqualified' emojis, which might not be as widely supported or are variations of the standard emojis, use the IncludeAll switch.
.EXAMPLE
    Get-AllEmoji

    Retrieves all 'fully-qualified' emojis.
.EXAMPLE
    Get-AllEmoji -IncludeAll

    Retrieves all emojis, including both 'fully-qualified' and 'minimally-qualified'/'unqualified' emojis.
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
    https://pwshEmojiExplorer.readthedocs.io/en/latest/Get-AllEmoji/
.LINK
    https://www.unicode.org/license.txt
#>
function Get-AllEmoji {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false,
            HelpMessage = 'Includes all emojis in the output')]
        [switch]$IncludeAll
    )
    Write-Verbose -Message 'Verifying XML Data Set Availability...'
    if (Import-XMLDataSet) {
        Write-Verbose -Message 'Verified.'

        $dataSet = $script:glData

        Write-Verbose -Message 'Retrieving all emojis...'
        # declare object array empty list
        $emojiList = New-Object System.Collections.Generic.List[PSEmoji]
        $dataSet | ForEach-Object {
            $emoji = $null
            try {
                [PSEmoji]$emoji = ConvertTo-PSEmoji -CustomObject $_
            }
            catch {
                Write-Warning -Message ('Unable to convert the custom object {0} to a PSEmoji object.' -f $_.Description)
            }

            [void]$emojiList.Add($emoji)
        }

        Write-Debug -Message ('{0} emojis retrieved.' -f $emojiList.Count)

        if ($IncludeAll -eq $false) {
            $results = $emojiList | Where-Object { $_.Status -eq 'fully-qualified' }
        }
        else {
            $results = $emojiList
        }

        Write-Debug -Message ('{0} emojis returned.' -f $results.Count)

    } #if_Import-XMLDataSet
    else {
        Write-Warning -Message 'pwshEmojiExplorer was unable to source the required data set file.'
        Write-Warning -Message 'Ensure you have an active internet connection'
        return
    } #else_Import-XMLDataSet

    return $results
} #Get-AllEmoji
