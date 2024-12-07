# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.2.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.8.4]

- Module Changes
    - Addressed bug where `Expand-XMLDataSet` can file if user has `Expand-Archive` from `Pscx` module, not from `Microsoft.PowerShell.Archive`
- Build Updates
    - Added `MarkdownRepair.ps1` and added Markdown repair logic to InvokeBuild script. This is to account for an issue in PowerShell `7.4.0`+ where a new parameter was introduced that platyPS can not handle during help creation. Ref: [platyPS issue]([text](https://github.com/PowerShell/platyPS/issues/595)).

## [0.8.2]

- Module Changes
    - Added ReleaseNotes link to `psd1` manifest
    - Updated `Convert-EmojiToHexCodePoint` to use `System.Collections.Generic.List` instead of `System.Collections.ArrayList`
- Build Updates
    - Adjusted metric dashboard arrangement and sizing
- Misc
    - Updated `settings.json` for tab requirements to support Readthedocs
    - Updated `extensions.json` with recommended extensions for working with this repo

## [0.8.0]

- Initial release.
