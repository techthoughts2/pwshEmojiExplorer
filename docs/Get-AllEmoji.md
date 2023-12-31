---
external help file: pwshEmojiExplorer-help.xml
Module Name: pwshEmojiExplorer
online version: https://pwshEmojiExplorer.readthedocs.io/en/latest/Get-AllEmoji/
schema: 2.0.0
---

# Get-AllEmoji

## SYNOPSIS
Retrieves all emojis.

## SYNTAX

```
Get-AllEmoji [-IncludeAll] [<CommonParameters>]
```

## DESCRIPTION
The Get-AllEmoji function retrieves a comprehensive list of emojis.
By default, the function returns only 'fully-qualified' emojis, which are the most common and widely supported versions.
If you need to include 'minimally-qualified' and 'unqualified' emojis, which might not be as widely supported or are variations of the standard emojis, use the IncludeAll switch.

## EXAMPLES

### EXAMPLE 1
```
Get-AllEmoji
```

Retrieves all 'fully-qualified' emojis.

### EXAMPLE 2
```
Get-AllEmoji -IncludeAll
```

Retrieves all emojis, including both 'fully-qualified' and 'minimally-qualified'/'unqualified' emojis.

## PARAMETERS

### -IncludeAll
Includes all emojis in the output, regardless of their qualification status.
By default, only 'fully-qualified' emojis are returned.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSEmoji
## NOTES
Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
Qualification levels:
    - Fully-qualified - a complete, standard emoji
    - Minimally-qualified - a basic form of an emoji, often lacking detail
    - Unqualified - a raw, unrefined form of an emoji

This function uses the Public data set from the Unicode Data Files and adheres to the Unicode Terms of Use:
    https://www.unicode.org/copyright.html
    https://www.unicode.org/license.txt

## RELATED LINKS

[https://pwshEmojiExplorer.readthedocs.io/en/latest/Get-AllEmoji/](https://pwshEmojiExplorer.readthedocs.io/en/latest/Get-AllEmoji/)

[https://www.unicode.org/license.txt](https://www.unicode.org/license.txt)

