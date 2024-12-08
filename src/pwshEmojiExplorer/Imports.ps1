# This is a locally sourced Imports file for local development.
# It can be imported by the psm1 in local development to add script level variables.
# It will merged in the build process. This is for local development only.

# region script variables
# $script:resourcePath = "$PSScriptRoot\Resources"

$script:unicodeVersion = '16.0'

function Get-DataLocation {
    $folderName = 'pwshEmojiExplorer'
    if ($PROFILE) {
        $script:dataPath = (Join-Path (Split-Path -Parent $PROFILE) $folderName)
    }
    else {
        $script:dataPath = "~\${$folderName}"
    }
}

$domain = 'cloudfront.net'
$target = 'd1nm4o1hreod3r'
Get-DataLocation
$script:dataFileZip = 'pwshemojis.zip'
$script:metadataFile = 'version.json'
$script:dataFile = 'pwshEmoji.xml'
$script:dlURI = '{0}.{1}' -f $target, $domain
$script:glData = $null


class PSEmoji {
    [string]$Group
    [string]$Subgroup
    [string]$HexCodePoint
    [string]$Status
    [string]$Name
    [string]$Version
    [string]$Description
    [string]$ShortCode
    [string[]]$HexCodePointArray
    [string[]]$UnicodeStandard
    [string[]]$HTMLEntityFormat
    [string]$pwshEscapedFormat
    [int[]]$Decimal

    PSEmoji([string]$Group, [string]$Subgroup, [string]$HexCodePoint, [string]$Status, [string]$Name, [string]$Version, [string]$Description, [string]$ShortCode, [string[]]$HexCodePointArray, [string[]]$UnicodeStandard, [string[]]$HTMLEntityFormat, [string]$pwshEscapedFormat, [int[]]$Decimal) {
        $this.Group = $Group
        $this.Subgroup = $Subgroup
        $this.HexCodePoint = $HexCodePoint
        $this.Status = $Status
        $this.Name = $Name
        $this.Version = $Version
        $this.Description = $Description
        $this.ShortCode = $ShortCode
        $this.HexCodePointArray = $HexCodePointArray
        $this.UnicodeStandard = $UnicodeStandard
        $this.HTMLEntityFormat = $HTMLEntityFormat
        $this.pwshEscapedFormat = $pwshEscapedFormat
        $this.Decimal = $Decimal
    }

    # You can add any additional methods here
}

$script:stopWords = @(
    'a'
    'about'
    'above'
    'actually'
    'after'
    'again'
    'against'
    'all'
    'almost'
    'also'
    'although'
    'always'
    'am'
    'an'
    'and'
    'any'
    'are'
    'as'
    'at'
    'be'
    'became'
    'because'
    'become'
    'been'
    'before'
    'being'
    'below'
    'between'
    'both'
    'but'
    'by'
    'can'
    'cannot'
    'could'
    'did'
    'do'
    'does'
    'doing'
    'down'
    'during'
    'each'
    'either'
    'else'
    'few'
    'for'
    'from'
    'further'
    'had'
    'has'
    'have'
    'having'
    'he'
    'hence'
    'her'
    'here'
    'hers'
    'herself'
    'him'
    'himself'
    'his'
    'how'
    'i'
    'if'
    'i''m'
    'in'
    'into'
    'is'
    'it'
    'its'
    'itself'
    'just'
    'may'
    'maybe'
    'me'
    'might'
    'mine'
    'more'
    'most'
    'must'
    'my'
    'myself'
    'neither'
    'no'
    'nor'
    'not'
    'of'
    'off'
    'oh'
    'ok'
    'on'
    'once'
    'only'
    'or'
    'other'
    'ought'
    'our'
    'ours'
    'ourselves'
    'out'
    'over'
    'own'
    'same'
    'she'
    'so'
    'some'
    'such'
    'than'
    'that'
    'the'
    'their'
    'theirs'
    'them'
    'themselves'
    'then'
    'there'
    'these'
    'they'
    'this'
    'those'
    'through'
    'to'
    'too'
    'under'
    'very'
    'wait'
    'was'
    'we'
    'were'
    'what'
    'whenever'
    'whereas'
    'wherever'
    'whether'
    'who'
    'whoever'
    'whom'
    'whose'
    'why'
    'will'
    'with'
    'within'
    'without'
    'would'
    'yes'
    'yet'
    'you'
    'your'
    'yours'
    'yourself'
    'yourselves'
)
