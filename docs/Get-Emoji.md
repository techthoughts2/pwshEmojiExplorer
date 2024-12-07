---
external help file: pwshEmojiExplorer-help.xml
Module Name: pwshEmojiExplorer
online version: https://pwshEmojiExplorer.readthedocs.io/en/latest/Get-Emoji/
schema: 2.0.0
---

# Get-Emoji

## SYNOPSIS
Retrieves a specific emoji or a list of emojis based on various search criteria.

## SYNTAX

### Name
```
Get-Emoji [-Emoji <String>] [-IncludeAll] [<CommonParameters>]
```

### Group
```
Get-Emoji [-Group <String>] [-IncludeAll] [<CommonParameters>]
```

### SubGroup
```
Get-Emoji [-SubGroup <String>] [-IncludeAll] [<CommonParameters>]
```

### ShortCode
```
Get-Emoji [-ShortCode <String>] [-IncludeAll] [<CommonParameters>]
```

### Hex
```
Get-Emoji [-HexCodePoint <String>] [-IncludeAll] [<CommonParameters>]
```

### Decimal
```
Get-Emoji [-Decimal <String[]>] [-IncludeAll] [<CommonParameters>]
```

### Search
```
Get-Emoji [-SearchTerm <String>] [-IncludeAll] [<CommonParameters>]
```

## DESCRIPTION
The Get-Emoji function allows users to retrieve emojis by specifying one or more search criteria such as Emoji, Group, SubGroup, ShortCode, HexCodePoint, Decimal, or a general SearchTerm.
The function supports both exact and relaxed search terms.
Exact search terms provide quick and efficient results, while relaxed search terms perform a more comprehensive search across relevant fields.

## EXAMPLES

### EXAMPLE 1
```
Get-Emoji -Emoji '😀'
```

Retrieves the emoji specified by the direct emoji character.

### EXAMPLE 2
```
Get-Emoji -Group 'Food & Drink'
```

Retrieves all emojis under the exact 'Food & Drink' group.

### EXAMPLE 3
```
Get-Emoji -Group 'food'
```

Performs a relaxed search and retrieves all emojis in groups containing the word 'food'.

### EXAMPLE 4
```
Get-Emoji -SubGroup 'food-vegetable'
```

Retrieves all emojis under the exact 'food-vegetable' subgroup.

### EXAMPLE 5
```
Get-Emoji -SubGroup 'vegetable'
```

Performs a relaxed search and retrieves all emojis in subgroups containing the word 'vegetable'.

### EXAMPLE 6
```
Get-Emoji -ShortCode ':smiling_face_with_hearts:'
```

Retrieves the emoji with the exact shortcode ':smiling_face_with_hearts:'.

### EXAMPLE 7
```
Get-Emoji -ShortCode 'smiling'
```

Performs a relaxed search and retrieves all emojis with shortcode containing 'smiling'.

### EXAMPLE 8
```
Get-Emoji -HexCodePoint '1F600'
```

Retrieves the emoji with the hexadecimal code point '1F600'.

### EXAMPLE 9
```
Get-Emoji -Decimal 128512
```

Retrieves the emoji with the exact decimal code '128512'.

### EXAMPLE 10
```
Get-Emoji -Decimal '127812', '8205', '129003'
```

Retrieves emojis that match all the specified decimal codes.

### EXAMPLE 11
```
Get-Emoji -SearchTerm 'fork'
```

Performs a general search and retrieves all emojis where 'fork' is found in the group, subgroup, or description.

### EXAMPLE 12
```
Get-Emoji -SearchTerm 'plane' -IncludeAll
```

Performs a general search and retrieves all emojis where 'plane' is found in the group, subgroup, or description.
Includes all emojis in the output, regardless of their qualification status.

### EXAMPLE 13
```

```

### EXAMPLE 14
```
Get-Emoji -SearchTerm 'fork' | Where-Object {$_.Group -eq 'Food & Drink'}
```

This example shows how to retrieve all emojis with 'fork' in their group, subgroup, or description, and then filters the results to include only those in the 'Food & Drink' group.

## PARAMETERS

### -Emoji
Specifies the emoji character to retrieve.
Use an exact emoji character for a direct match.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Group
Specifies the group of emojis to retrieve.

```yaml
Type: String
Parameter Sets: Group
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubGroup
Specifies the subgroup of emojis to retrieve.

```yaml
Type: String
Parameter Sets: SubGroup
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShortCode
Specifies the shortcode of the emoji to retrieve.

```yaml
Type: String
Parameter Sets: ShortCode
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HexCodePoint
Specifies the hexadecimal code point of the emoji to retrieve.

```yaml
Type: String
Parameter Sets: Hex
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Decimal
Specifies the decimal code of the emoji to retrieve.

```yaml
Type: String[]
Parameter Sets: Decimal
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchTerm
Specifies a general search term to find emojis.
Searches across group, subgroup, and description fields using a relaxed search approach.

```yaml
Type: String
Parameter Sets: Search
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -Verbose, -WarningAction, -WarningVariable, and -ProgressAction. 
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

[https://pwshEmojiExplorer.readthedocs.io/en/latest/Get-Emoji/](https://pwshEmojiExplorer.readthedocs.io/en/latest/Get-Emoji/)

[https://www.unicode.org/license.txt](https://www.unicode.org/license.txt)
