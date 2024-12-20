#
# Module manifest for module 'pwshEmojiExplorer'
#
# Generated by: Jake
#
# Generated on: 12/27/2023
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'pwshEmojiExplorer.psm1'

    # Version number of this module.
    ModuleVersion     = '0.9.0'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID              = '6e4813c7-6f30-42e8-adc4-b3d9b46bce9a'

    # Author of this module
    Author            = 'Jake Morrison'

    # Company or vendor of this module
    CompanyName       = 'TechThoughts'

    # Copyright statement for this module
    Copyright         = '(c) Jake Morrison. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'Enables detailed emoji search, discovery, and retrieval. Offers detailed insights on emojis, with multiple search options aligned with the Unicode standard. Provides comprehensive emoji data, including diverse representations and formats, to enhance your scripts and digital communication.'

    # Minimum version of the PowerShell engine required by this module
    # PowerShellVersion = ''

    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # ClrVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules   = @(
        @{
            ModuleName    = 'Convert'
            ModuleVersion = '1.5.0'
        }
    )

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    ScriptsToProcess  = @(
        'ArgumentCompleters.ps1'
    )

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess  = @(
        'pwshEmojiExplorer.Format.ps1xml'
    )

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Add-EmojiToText',
        'Get-Emoji',
        'Get-AllEmoji'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    # CmdletsToExport = '*'

    # Variables to export from this module
    # VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    # AliasesToExport = '*'

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @(
                'emoji',
                'emojis',
                'unicode',
                'unicode-emoji',
                'unicode-emojis',
                'chat',
                'text',
                'texting',
                'text-emoji',
                'text-emojis',
                'texting-emoji',
                'texting-emojis',
                'message',
                'messaging',
                'message-emoji',
                'message-emojis',
                'messaging-emoji',
                'messaging-emojis',
                'Activities',
                'Animals',
                'Nature',
                'Component',
                'Flag',
                'Flags',
                'Food',
                'Drink',
                'People',
                'Smileys',
                'Emotion',
                'Symbols',
                'Travel',
                'Places'
            )

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/techthoughts2/pwshEmojiExplorer/blob/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/techthoughts2/pwshEmojiExplorer'

            # A URL to an icon representing this module.
            IconUri      = 'https://github.com/techthoughts2/pwshEmojiExplorer/raw/main/docs/assets/pwshEmojiExplorer_icon.png'

            # ReleaseNotes of this module
            ReleaseNotes = 'https://github.com/techthoughts2/pwshEmojiExplorer/blob/main/docs/CHANGELOG.md'

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}


