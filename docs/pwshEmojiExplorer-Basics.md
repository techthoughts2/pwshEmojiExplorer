# pwshEmojiExplorer - Basics

## Getting Started with pwshEmojiExplorer

To use pwshEmojiExplorer, you first need to install it from the PowerShell Gallery using the following command:

```powershell
Install-Module -Name 'pwshEmojiExplorer' -Repository PSGallery -Scope CurrentUser
```

## Finding Emojis

pwshEmojiExplorer makes it easy to search and find emojis based on various criteria such as name, group, and more. Here are some common ways to use it:

### By Emoji Character

Find detailed information about a specific emoji by its character.

```powershell
Get-Emoji -Emoji '😀'

Group             : Smileys & Emotion
Subgroup          : face-smiling
HexCodePoint      : 1F600
Name              : 😀
Description       : grinning face
ShortCode         : :grinning_face:
HexCodePointArray : {1F600}
UnicodeStandard   : {U+1F600}
pwshEscapedFormat : `u{1F600}
Decimal           : {128512}
```

### By Group

Retrieve all emojis belonging to a specific group like 'Food & Drink'.

```powershell
Get-Emoji -Group 'Food & Drink'
```

### By Subgroup

Focus your emoji search on a specific subgroup.

```powershell
Get-Emoji -SubGroup 'food-vegetable'
```

### By Shortcode

Look for emojis using their shortcode.

```powershell
Get-Emoji -ShortCode ':smiling_face_with_hearts:'

Group             : Smileys & Emotion
Subgroup          : face-affection
HexCodePoint      : 1F970
Name              : 🥰
Description       : smiling face with hearts
ShortCode         : :smiling_face_with_hearts:
HexCodePointArray : {1F970}
UnicodeStandard   : {U+1F970}
pwshEscapedFormat : `u{1F970}
Decimal           : {129392}
```

### By Hex Code Point

Use hex code points to find emojis.

```powershell
Get-Emoji -HexCodePoint '1F363'

Group             : Food & Drink
Subgroup          : food-asian
HexCodePoint      : 1F363
Name              : 🍣
Description       : sushi
ShortCode         : :sushi:
HexCodePointArray : {1F363}
UnicodeStandard   : {U+1F363}
pwshEscapedFormat : `u{1F363}
Decimal           : {127843}
```

### By Decimal

Decimal code points can also be used for searches.

```powershell
Get-Emoji -Decimal 128523

Group             : Smileys & Emotion
Subgroup          : face-tongue
HexCodePoint      : 1F60B
Name              : 😋
Description       : face savoring food
ShortCode         : :face_savoring_food:
HexCodePointArray : {1F60B}
UnicodeStandard   : {U+1F60B}
pwshEscapedFormat : `u{1F60B}
Decimal           : {128523}
```

### General Search

Perform a broader search using a term.

```powershell
Get-Emoji -SearchTerm 'fork' | Format-Table

Name  Group                  Subgroup               ShortCode
 ----  -----                  --------               ---------
 🍽️   Food & Drink           dishware               :fork_and_knife_with_plate:
 🍴   Food & Drink           dishware               :fork_and_knife:
```

## Add Emojis to Text

Enhance your text by automatically adding emojis with the Add-EmojiToText function. This can add a playful or visually engaging element to your messages:
This function scans the text for keywords and appends relevant emojis next to them.

```powershell
$sampleText = "I am going to the airport tomorrow to fly on a plane to Spain. Before I take off I'm going to eat some food. I've heard they have good restaurants at the terminal. Hopefully they have something spicy. You know how much I like hot food! I'm so excited to see you! Can't wait to see you! Love you!"
$enhancedText = Add-EmojiToText -Text $sampleText
Write-Output $enhancedText

I am going to the airport tomorrow to fly 🦋 on a plane ✈️ to Spain. 🇪🇸 Before I take 🥡 off I'm going to eat 😅 some food. 😋 I've 😔 heard 🇭🇲 they have good restaurants at the terminal. Hopefully they have something spicy. You know how much I like hot 🥵 food! 😋 I'm so excited to see 🙈 you! 🤟 Can't wait to see 🙈 you! 🤟 Love 💌 you! 🤟
```

## Getting All Emojis

To retrieve a comprehensive list of all available emojis, use the Get-AllEmoji function. By default, it returns only 'fully-qualified' emojis:

```powershell
Get-AllEmoji
```

To include all types of emojis (including 'minimally-qualified' and 'unqualified'), use the `-IncludeAll` switch:

```powershell
Get-AllEmoji -IncludeAll
```
