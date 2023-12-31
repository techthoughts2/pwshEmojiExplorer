<#
.SYNOPSIS
    Enhances text by adding emojis based on key words.
.DESCRIPTION
    The Add-EmojiToText function is designed to enrich your text with emojis by identifying key words and appending relevant emojis. It scans the input text for words that can be associated with emojis and inserts an emoji next to each identified word. This function employs a "best effort" approach to match words with emojis, providing a fun and light-hearted way to spruce up messages or texts. Note that the function's ability to find and match emojis is based on simple logic, and it may not always find a perfect match for every word.
.EXAMPLE
    $sampleText = "Spending the day debugging some code and optimizing algorithms. Later, planning a virtual meeting with my team to discuss cloud computing and data security. Can't forget to update my blog on the latest AI trends. In the evening, it's time to unwind with a sci-fi movie and maybe some online gaming. Proud to be a part of the ever-evolving digital era!"
    $enhancedText = Add-EmojiToText -Text $sampleText
    Write-Output $enhancedText

    This example demonstrates how Add-EmojiToText can be used to add a playful touch to a given text by inserting emojis. Emojis related to words like 'cloud', 'AI', 'movie', and 'time' are added next to the corresponding words in the text.
.EXAMPLE
    $sampleText = "I am going to the airport tomorrow to fly on a plane to Spain. Before I take off I'm going to eat some food. I've heard they have good restaurants at the terminal. Hopefully they have something spicy. You know how much I like hot food! I'm so excited to see you! Can't wait to see you! Love you!"
    Add-EmojiToText -Text $sampleText

    This example demonstrates how Add-EmojiToText can be used to add a playful touch to a given text by inserting emojis. Emojis related to words like 'airport', 'plane', 'Spain', and 'food' are added next to the corresponding words in the text.
.EXAMPLE
    $sampleText = "Morning coffee, followed by a workout and a quick check of the news. Work involves writing code, attending meetings, and brainstorming. Lunchtime is for catching up on social media. The evening is for relaxation, maybe with some music, a good book, or a movie. Ending the night by setting the alarm and dreaming about the beach."
    $enhancedText = Add-EmojiToText -Text $sampleText -Replace
    Write-Output $enhancedText

    This example demonstrates how Add-EmojiToText can be used to transform a text into a fun, emoji-centric version by replacing key words with their corresponding emojis. The -Replace switch is used to substitute these everyday activities and concepts with relevant emojis, creating an engaging and visually expressive rendition of the text. This playful transformation is perfect for adding a bit of whimsy to messages or social media posts.
.PARAMETER Text
    Specifies the text to be processed by the function.
.PARAMETER Replace
    Specifies whether the function should replace the word with the emoji or add the emoji after the word. The default value is $false, which means that the emoji is added after the word. If the value is set to $true, the word is replaced with the emoji.
.OUTPUTS
    System.String
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
    This function is experimental and intended for casual use to add a fun element to text processing.

    This function uses the Public data set from the Unicode Data Files and adheres to the Unicode Terms of Use:
        https://www.unicode.org/copyright.html
        https://www.unicode.org/license.txt
.COMPONENT
    pwshEmojiExplorer
.LINK
    https://pwshEmojiExplorer.readthedocs.io/en/latest/Add-EmojiToText/
.LINK
    https://www.unicode.org/license.txt
#>
function Add-EmojiToText {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'The text to process')]
        [ValidateNotNullOrEmpty()]
        [string]$Text,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Replace the word with the emoji instead of adding the emoji after the word')]
        [switch]$Replace
    )

    Write-Verbose -Message 'Processing text...'

    $words = $Text -split ' '

    # Process each word
    $processedWords = foreach ($word in $words) {
        # ____________________________
        # resets
        $emoji = $null
        $key = $null
        $emojiObj = $null
        # ____________________________
        if ($word -notin $stopWords) {
            $key = $word -replace '[^\w\s]', '' # Remove punctuation for matching
            $emojiObj = Get-Emoji -SearchTerm $key
            if ($emojiObj) {
                $emoji = $emojiObj[0].Name
            }
            if ($emoji) {
                Write-Debug -Message ('{0} -> {1}' -f $key, $emoji)
                if ($Replace -eq $true) {
                    $word = "$emoji"
                }
                else {
                    $word = "$word $emoji" # Add the emoji after the word
                }
                $word
            }
            else {
                $word
            }
        }
        else {
            $word
        }
    } #foreach_word

    # Reconstruct the text
    $processedText = $processedWords -join ' '

    return $processedText
} #Add-EmojiToText
