<#
.SYNOPSIS
    Converts a custom object to a PSEmoji object.
.DESCRIPTION
    The ConvertTo-PSEmoji function takes a custom object as input and converts it to a PSEmoji object.
.EXAMPLE
    $customObject = [PSCustomObject]@{
        Group             = 'Smileys & Emotion'
        Subgroup          = 'face-smiling'
        HexCodePoint      = '1F600'
        Status            = 'fully-qualified'
        Name              = '😀'
        Version           = 'E1.0'
        Description       = 'grinning face'
        ShortCode         = ':grinning_face:'
        HexCodePointArray = @('1F600')
        UnicodeStandard   = 'Unicode 6.0'
        HTMLEntityFormat  = '&#x1F600;'
        pwshEscapedFormat = '`u{1F600}'
        Decimal           = @('128512')
    }
    $emoji = ConvertTo-PSEmoji -CustomObject $customObject

    This example shows how to convert a custom object to a PSEmoji object.
.EXAMPLE
    [PSEmoji]$emoji = ConvertTo-PSEmoji -CustomObject $customObject s

    This example shows how to convert a custom object to a PSEmoji object.
.PARAMETER CustomObject
    The custom object to be converted. This object should have properties that match the properties of the PSEmoji class.
.INPUTS
    PSCustomObject
.OUTPUTS
    PSEmoji
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
    The properties of the custom object should match the properties of the PSEmoji class.
.COMPONENT
    pwshEmojiExplorer
#>
function ConvertTo-PSEmoji {
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Custom object to be converted to a PSEmoji object.')]
        [PSCustomObject]$CustomObject
    )

    $emoji = [PSEmoji]::new(
        $CustomObject.Group,
        $CustomObject.Subgroup,
        $CustomObject.HexCodePoint,
        $CustomObject.Status,
        $CustomObject.Name,
        $CustomObject.Version,
        $CustomObject.Description,
        $CustomObject.ShortCode,
        $CustomObject.HexCodePointArray,
        $CustomObject.UnicodeStandard,
        $CustomObject.HTMLEntityFormat,
        $CustomObject.pwshEscapedFormat,
        $CustomObject.Decimal
    )

    return $emoji
} #ConvertTo-PSEmoji
