# pwshEmojiExplorer

[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1+-purple.svg)](https://github.com/PowerShell/PowerShell) [![PowerShell Gallery][psgallery-img]][psgallery-site] ![Cross Platform](https://img.shields.io/badge/platform-windows%20%7C%20macos%20%7C%20linux-lightgrey) [![License][license-badge]](LICENSE) [![Documentation Status](https://readthedocs.org/projects/pwshemojiexplorer/badge/?version=latest)](https://pwshemojiexplorer.readthedocs.io/en/latest/?badge=latest)

[psgallery-img]:   https://img.shields.io/powershellgallery/dt/pwshEmojiExplorer?label=Powershell%20Gallery&logo=powershell
[psgallery-site]:  https://www.powershellgallery.com/packages/pwshEmojiExplorer
[psgallery-v1]:    https://www.powershellgallery.com/packages/pwshEmojiExplorer/0.8.1
[license-badge]:   https://img.shields.io/github/license/techthoughts2/pwshEmojiExplorer

<p align="center">
    <img src="./docs/assets/pwshEmojiExplorer.png" alt="pwshEmojiExplorer Logo" >
</p>

Branch | Windows - PowerShell | Windows - pwsh | Linux | MacOS
--- | --- | --- | --- | --- |
main | [![Build Status Windows PowerShell main](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_Windows.yml/badge.svg?branch=main)](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_Windows.yml) | [![Build Status Windows pwsh main](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_Windows_Core.yml/badge.svg?branch=main)](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_Windows_Core.yml) | [![Build Status Linux main](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_Linux.yml/badge.svg?branch=main)](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_Linux.yml) | [![Build Status MacOS main](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_MacOS.yml/badge.svg?branch=main)](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_MacOS.yml)
Enhancements | [![Build Status Windows PowerShell Enhancements](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_Windows.yml/badge.svg?branch=Enhancements)](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_Windows.yml) | [![Build Status Windows pwsh Enhancements](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_Windows_Core.yml/badge.svg?branch=Enhancements)](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_Windows_Core.yml) | [![Build Status Linux Enhancements](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_Linux.yml/badge.svg?branch=Enhancements)](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_Linux.yml) | [![Build Status MacOS Enhancements](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_MacOS.yml/badge.svg?branch=Enhancements)](https://github.com/techthoughts2/pwshEmojiExplorer/actions/workflows/wf_MacOS.yml)

## Synopsis

pwshEmojiExplorer is a PowerShell module designed to enable users to search, discover, and retrieve emojis directly through the command line. Leveraging the extensive Unicode emoji library, the module offers a streamlined approach to exploring and integrating a vast range of emojis into various coding projects.

## Description

This PowerShell module simplifies the process of finding and using emojis by enabling direct command-line searches. It's not just about bringing emojis into PowerShell scripts; it's about providing a solution for handling emojis in various coding projects. Whether you need the HTMLEntityFormat for a web project, a Unicode representation for a text file, or the hex code for a development task, pwshEmojiExplorer provides this information quickly and efficiently. It's a tool for developers, scripters, and digital creators who seek to incorporate emojis into their work more effectively, enhancing the ease of access and use of emojis in diverse digital contexts.

## Features

- **Extensive Emoji Search**: Find emojis by name, category, code point, and more.
- **Emoji Information Retrieval**: Get detailed information about each emoji, including different representations and formats.
- **Text Enhancement**: Automatically enhance texts by adding or replacing words with emojis. Experimental, but perfect for adding a bit of fun to your scripts.
- **Unicode Compliance**: Utilizes the Public data set from the Unicode Data Files, ensuring that you are working with officially recognized emoji standards and variations.
- **Auto-updating**: Actively scans for updates in the Unicode data set and automatically upgrades to the latest published standard. This feature ensures you are aligned with the newest emoji releases and changes in the Unicode standard.

## Getting Started

### Documentation

Documentation for pwshEmojiExplorer is available at: [https://pwshEmojiExplorer.readthedocs.io](https://pwshEmojiExplorer.readthedocs.io)

### Installation

```powershell
Install-Module -Name 'pwshEmojiExplorer' -Repository PSGallery -Scope CurrentUser
```

### Quick Start

```powershell
#-------------------------------------------------------------------------------------
# Import the pwshEmojiExplorer module
Import-Module -Name 'pwshEmojiExplorer'
#-------------------------------------------------------------------------------------
# Get detailed information about a specific emoji by its character
Get-Emoji -Emoji '😀'
#-------------------------------------------------------------------------------------
# Retrieve a list of all emojis within the 'Food & Drink' group
Get-Emoji -Group 'Food & Drink'
#-------------------------------------------------------------------------------------
# Retrieve a list of all emojis within the 'food-vegetable' sub-group
Get-Emoji -SubGroup 'food-vegetable'
#-------------------------------------------------------------------------------------
# Find an emoji based on its shortcode 🥰
Get-Emoji -ShortCode ':smiling_face_with_hearts:'
#-------------------------------------------------------------------------------------
# Get information about an emoji using its hex code, like '1F600' for 😀
Get-Emoji -HexCodePoint '1F600'
#-------------------------------------------------------------------------------------
# Retrieve an emoji by specifying its decimal code point, e.g., 128512 for 😀
Get-Emoji -Decimal 128512
#-------------------------------------------------------------------------------------
# Perform a general search for emojis
Get-Emoji -SearchTerm 'fork'
#-------------------------------------------------------------------------------------
# Retrieve the complete list of available emojis
Get-AllEmoji
#-------------------------------------------------------------------------------------
# Enhance a given text by automatically adding relevant emojis
$sampleText = "I am going to the airport tomorrow to fly on a plane to Spain. Before I take off I'm going to eat some food. I've heard they have good restaurants at the terminal. Hopefully they have something spicy. You know how much I like hot food! I'm so excited to see you! Can't wait to see you! Love you!"
Add-EmojiToText -Text $sampleText
#-------------------------------------------------------------------------------------
```

## Notes

This PowerShell project was created with [Catesta](https://github.com/techthoughts2/Catesta).

## Contributing

If you'd like to contribute to pwshEmojiExplorer, please see the [contribution guidelines](.github/CONTRIBUTING.md).

## License

This project is [licensed under the MIT License](LICENSE).
