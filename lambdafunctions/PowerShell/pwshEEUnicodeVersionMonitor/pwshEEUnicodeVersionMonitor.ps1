# PowerShell script file to be executed as an AWS Lambda function.
#
# When executing in Lambda the following variables will be predefined.
#   $LambdaInput - A PSObject that contains the Lambda function input data.
#   $LambdaContext - An Amazon.Lambda.Core.ILambdaContext object that contains information about the currently running Lambda environment.
#
# The last item in the PowerShell pipeline will be returned as the result of the Lambda function.
#
# To include PowerShell modules with your Lambda function, like the AWS.Tools.Common module, add a "#Requires" statement
# indicating the module and version.

# Env variables that are set by the AWS Lambda environment:
# $env:S3_BUCKET_NAME
# $env:TELEGRAM_SECRET
# $env:SERVICE_NAME

#Requires -Modules @{ModuleName='AWS.Tools.Common';ModuleVersion='4.1.472'}
#Requires -Modules @{ModuleName='AWS.Tools.CloudWatch';ModuleVersion='4.1.472'}
#Requires -Modules @{ModuleName='AWS.Tools.SimpleSystemsManagement';ModuleVersion='4.1.472'}
#Requires -Modules @{ModuleName='AWS.Tools.S3';ModuleVersion='4.1.472'}
#Requires -Modules @{ModuleName='PoshGram';ModuleVersion='2.3.0'}

# Uncomment to send the input event to CloudWatch Logs
Write-Host (ConvertTo-Json -InputObject $LambdaInput -Compress -Depth 5)

# CW Event Scheduled -> Lambda -> CW Metric

#region supportingFunctions

function Send-TelegramMessage {
    <#
    .SYNOPSIS
        Sends message to Telegram for notification.
    #>
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Message to send to telegram')]
        [string]
        $Message
    )

    if ($null -eq $script:telegramToken -or $null -eq $script:telegramChannel) {
        try {
            $getSSMParameterValueSplatToken = @{
                Name           = 'telegramtoken'
                WithDecryption = $true
                ErrorAction    = 'Stop'
            }
            $getSSMParameterValueSplatChannel = @{
                Name           = 'telegramchannel'
                WithDecryption = $true
                ErrorAction    = 'Stop'
            }
            $script:telegramToken = Get-SSMParameterValue @getSSMParameterValueSplatToken
            $script:telegramChannel = Get-SSMParameterValue @getSSMParameterValueSplatChannel
        }
        catch {
            throw $_
        }
    } #if_token_channel_null

    if ([string]::IsNullOrWhiteSpace($script:telegramToken) -or [string]::IsNullOrWhiteSpace($script:telegramChannel)) {
        throw 'Parameters not successfully retrieved'
    }
    else {
        Write-Host 'Parameters retrieved.'
        $token = $script:telegramToken.Parameters.Value
        $channel = $script:telegramChannel.Parameters.Value
        $out = Send-TelegramTextMessage -BotToken $token -ChatID $channel -Message $Message
        Write-Host ($out | Out-String)
    }
} #Send-TelegramMessage

#endregion

#region unicode version

# Define the URL
$url = 'https://unicode.org/Public/emoji/latest/ReadMe.txt'

Write-Host ('Getting content from {0}' -f $url)
try {
    $content = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop
}
catch {
    Write-Warning -Message ('Error getting content from {0}' -f $url)
    Write-Error $_
    Send-TelegramMessage -Message '\\\ Project pwshEmojiExplorer - Error retrieving information from unicode.org'
    return
}

# Parse the content to find the version number
$version = $content.Content | Select-String -Pattern 'Public\/emoji\/\d+\.\d+' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }

# if the version is null, or if the version is not in the expected format, then error and send telegram message
if ([string]::IsNullOrWhiteSpace($version) -or $version -notmatch '\d+\.\d+') {
    Write-Warning -Message 'Error parsing version number'
    Send-TelegramMessage -Message '\\\ Project pwshEmojiExplorer - Error parsing version number'
    return
}
else {
    Write-Host ('Version number is {0}' -f $version)
}

if ($version -like '*Public*' -or $version -like '*emoji*') {
    # extract the version number from the string
    # sample: Public/emoji/15.1
    $version = $version.Split('/')[2]
}

# verify that the version is in the expected format
if ($version -notmatch '\d+\.\d+') {
    Write-Warning -Message 'Error parsing version number'
    Send-TelegramMessage -Message '\\\ Project pwshEmojiExplorer - Error parsing version number'
    return
}
Write-Host ('Final Version number is {0}' -f $version)

# Create a MetricDatum .NET object
$MetricDatum = [Amazon.CloudWatch.Model.MetricDatum]::new()
$MetricDatum.MetricName = 'UnicodeEmojiVersion'
$MetricDatum.Value = $version

# Create a Dimension .NET object
$Dimension = [Amazon.CloudWatch.Model.Dimension]::new()
$Dimension.Name = 'UnicodeEmoji'
$Dimension.Value = 'LatestVersion'

# Assign the Dimension object to the MetricDatum's Dimensions property
$MetricDatum.Dimensions = $Dimension

$Namespace = 'UnicodeEmoji'

Write-Host ('Sending LatestVersion metric data to CloudWatch')
try {

    # Write the metric data to the CloudWatch service
    $writeCWMetricDataSplat = @{
        Namespace   = $Namespace
        MetricData  = $MetricDatum
        ErrorAction = 'Stop'
    }
    Write-CWMetricData @writeCWMetricDataSplat
}
catch {
    $errorMessage = $_.Exception.Message
    Write-Error -Message ('Something went wrong: {0}' -f $errorMessage)
    Send-TelegramMessage -Message '\\\ Project pwshEmojiExplorer - Error sending metric data to CloudWatch'
}

#endregion

#region current version

# download the current version from S3 to lambda temp

$key = 'version.json'
$file = "/tmp/$key"
Write-Host ('Downloading {0} from S3 to {1}' -f $key, $file)
$readS3ObjectSplat = @{
    BucketName  = $env:S3_BUCKET_NAME
    Key         = $key
    File        = $file
    ErrorAction = 'Stop'
}
try {
    Read-S3Object @readS3ObjectSplat
}
catch {
    $errorMessage = $_.Exception.Message
    Write-Error -Message ('Something went wrong: {0}' -f $errorMessage)
    Send-TelegramMessage -Message '\\\ Project pwshEmojiExplorer - Error downloading version file from S3'
}
# read the file
$versionFile = Get-Content -Path $file -Raw
# convert from json
$versionJson = $versionFile | ConvertFrom-Json
# get the version
$currentVersion = $versionJson.version

Write-Host ('Current version is {0}' -f $currentVersion)

# verify that the version is in the expected format
if ($currentVersion -notmatch '\d+\.\d+') {
    Write-Warning -Message 'Error parsing current version number'
    Send-TelegramMessage -Message '\\\ Project pwshEmojiExplorer - Error parsing current version number'
    return
}

# Create a MetricDatum .NET object
$MetricDatum2 = [Amazon.CloudWatch.Model.MetricDatum]::new()
$MetricDatum2.MetricName = 'UnicodeEmojiVersion'
$MetricDatum2.Value = $currentVersion

# Create a Dimension .NET object
$Dimension2 = [Amazon.CloudWatch.Model.Dimension]::new()
$Dimension2.Name = 'UnicodeEmoji'
$Dimension2.Value = 'CurrentVersion'

# Assign the Dimension object to the MetricDatum's Dimensions property
$MetricDatum2.Dimensions = $Dimension2

$Namespace = 'UnicodeEmoji'

Write-Host ('Sending CurrentVersion metric data to CloudWatch')
try {

    # Write the metric data to the CloudWatch service
    $writeCWMetricDataSplat = @{
        Namespace   = $Namespace
        MetricData  = $MetricDatum2
        ErrorAction = 'Stop'
    }
    Write-CWMetricData @writeCWMetricDataSplat
}
catch {
    $errorMessage = $_.Exception.Message
    Write-Error -Message ('Something went wrong: {0}' -f $errorMessage)
    Send-TelegramMessage -Message '\\\ Project pwshEmojiExplorer - Error sending CurrentVersion metric data to CloudWatch'
}

#endregion

#region version difference calculation

# convert both string versions to format we can use for comparison
$versionProper = [System.Version]$version
$currentVersionProper = [System.Version]$currentVersion

# Compare each component of the version
$majorDifference = $versionProper.Major - $currentVersionProper.Major
$minorDifference = $versionProper.Minor - $currentVersionProper.Minor
$buildDifference = $versionProper.Build - $currentVersionProper.Build
$revisionDifference = $versionProper.Revision - $currentVersionProper.Revision

# Output the differences
Write-Host ('Major version difference: {0}' -f $majorDifference)
Write-Host ('Minor version difference: {0}' -f $minorDifference)
Write-Host ('Build version difference: {0}' -f $buildDifference)
Write-Host ('Revision version difference: {0}' -f $revisionDifference)

# Overall comparison
$metricDifference = 0
if ($versionProper -gt $currentVersionProper) {
    Write-Host ('Available version ({0}) is newer than the current version ({1})' -f $version, $currentVersion)
    $metricDifference = 1
}
elseif ($versionProper -lt $currentVersionProper) {
    Write-Host ('Current version ({0}) is newer than the available version ({1})' -f $currentVersion, $version)
}
else {
    Write-Host ('Current version ({0}) is the same as the available version ({1})' -f $currentVersion, $version)
}

# Create a MetricDatum .NET object
$MetricDatum2 = [Amazon.CloudWatch.Model.MetricDatum]::new()
$MetricDatum2.MetricName = 'UnicodeEmojiVersionDifference'
$MetricDatum2.Value = $metricDifference

# Create a Dimension .NET object
$Dimension2 = [Amazon.CloudWatch.Model.Dimension]::new()
$Dimension2.Name = 'UnicodeEmojiVersionCheck'
$Dimension2.Value = 'VersionDifference'

# Assign the Dimension object to the MetricDatum's Dimensions property
$MetricDatum2.Dimensions = $Dimension2

$Namespace = 'UnicodeEmoji'

Write-Host ('Sending VersionDifference metric data to CloudWatch')
try {

    # Write the metric data to the CloudWatch service
    $writeCWMetricDataSplat = @{
        Namespace   = $Namespace
        MetricData  = $MetricDatum2
        ErrorAction = 'Stop'
    }
    Write-CWMetricData @writeCWMetricDataSplat
}
catch {
    $errorMessage = $_.Exception.Message
    Write-Error -Message ('Something went wrong: {0}' -f $errorMessage)
    Send-TelegramMessage -Message '\\\ Project pwshEmojiExplorer - Error sending VersionDifference metric data to CloudWatch'
}

#endregion

return $true
