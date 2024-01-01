<#
.SYNOPSIS
    Converts an emoji to a string of its hexadecimal code points.
.DESCRIPTION
    The Convert-EmojiToHexCodePoint function translates a given emoji character into its corresponding hexadecimal code points. This function is particularly useful for handling emojis that consist of surrogate pairs in Unicode, ensuring accurate conversion of complex emojis into their full hexadecimal representations.
.EXAMPLE
    $Emoji = "🐸"
    $searchCriteria = Convert-EmojiToHexCodePoint -Emoji $Emoji
    $searchCriteria

    Converts the frog emoji into its hexadecimal representation '1F438'.
.PARAMETER Emoji
    Specifies the emoji character to be converted.
.OUTPUTS
    System.String
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    pwshEmojiExplorer
#>
function Convert-EmojiToHexCodePoint {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Emoji
    )

    $charArray = $Emoji.ToCharArray()
    $codePoints = [System.Collections.ArrayList]@()

    for ($i = 0; $i -lt $charArray.Length; $i++) {
        $codePoint = [Char]::ConvertToUtf32($Emoji, $i)
        [void]$codePoints.Add("{0:X}" -f $codePoint)

        # If this character is a high surrogate, skip the next character
        if ([Char]::IsHighSurrogate($charArray[$i])) {
            $i++
        }
    }

    return $codePoints -join ' '
} # Convert-EmojiToHexCodePoint
