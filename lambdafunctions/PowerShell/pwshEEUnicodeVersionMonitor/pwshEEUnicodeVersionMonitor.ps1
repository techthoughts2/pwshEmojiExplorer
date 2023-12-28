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

return $true
