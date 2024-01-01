# pwshEmojiExplorer - FAQ

## FAQs

### Why would I use this vs just internet searching for an emoji?

`pwshEmojiExplorer` offers a quicker, more integrated approach for finding and using emojis in your projects. Unlike web searches, it provides immediate, command-line access to a comprehensive set of emoji data, including details like Unicode standards and HTML entity formats, useful for developers and content creators. It streamlines your workflow by allowing programmatic access to emojis and their metadata directly within your PowerShell environment, saving you the time and hassle of manual searching and copying from the web.

### How current is the emoji data?

The emoji data in `pwshEmojiExplorer` is kept up-to-date through a weekly automated scan of the Unicode site for any new emoji version updates. Upon detecting a version update, an automated process is triggered to update the emoji data set on the same day, ensuring that the module always contains the latest emojis and information. For detailed insights into this process, refer to the [Emoji Data Set creation component](pwshEmojiExplorer_data_workflow.md) documentation.

### I'm using Windows PowerShell and noticed that some emojis don't display correctly. Why is this happening?

Windows PowerShell, unlike higher versions of PowerShell, has limited support for Unicode, particularly for characters outside the Basic Multilingual Plane (BMP). This limitation primarily affects emojis composed of surrogate pairs - essentially emojis that are represented by two (or more) Unicode code units.

In Windows PowerShell, the console technology is based on UCS-2 encoding, which is a precursor to UTF-16. UCS-2 does not fully support characters that require surrogate pairs, leading to incorrect rendering of certain emojis. These are typically the more complex emojis or those added in later Unicode versions.

While pwshEmojiExplorer functions correctly in Windows PowerShell and can retrieve emoji data, the display of some emojis might not be accurate. This issue does not affect the functionality of the module but is a display limitation in the console.

For users seeking full emoji support, including accurate rendering of all emojis, consider upgrading to PowerShell (version 6 or newer), which has comprehensive Unicode support and handles all emojis correctly.
