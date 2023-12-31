# $env:SERVICE_NAME = name of the project
# $env:ARTIFACT_S3_BUCKET = the artifact bucket used by CB
# $env:AWS_ACCOUNTID = the AWS Account hosting the service under test
# $env:GIT_REPO = the git repo name
# $env:S3_PREFIX = the artifact prefix used by CB


Describe -Name 'Infrastructure Tests' -Fixture {
    BeforeAll {
        try {
            $cfnExports = Get-CFNExport -ErrorAction Stop
        }
        catch {
            throw
        }
        $script:ServiceName = $env:SERVICE_NAME
        $script:AWSRegion = $env:AWS_REGION
        $script:AWSAccountID = $env:AWS_ACCOUNTID
    } #before_all

    Context -Name 'psee.yml' -Fixture {

        It -Name 'Should create a PSEEFinalXMLBucketARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-PSEEFinalXMLBucketARN" }).Value
            $expected = 'arn:aws:s3::*'
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a PSEECloudFrontLogBucketARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-PSEECloudFrontLogBucketARN" }).Value
            $expected = 'arn:aws:s3::*'
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a CloudFront distribution' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-PSEECloudFrontDistributionDomain" }).Value
            $expected = '*.cloudfront.net'
            $assertion | Should -BeLike $expected
        } #it

    } #context_psee.yml

    Context -Name 'psee_alarms.yml' -Fixture {

        It -Name 'Should create a pwshEEPubXMLMonitorAlarmARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-pwshEEUnicodeVersionComparisonAlarmARN" }).Value
            $expected = 'arn:aws:cloudwatch:*'
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a pwshEEUnicodeVersionMonitorARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-pwshEEUnicodeVersionMonitorARN" }).Value
            $expected = 'arn:aws:lambda:*'
            $assertion | Should -BeLike $expected
        } #it

    } #context_psee_alarms.yml

} #describe_infra_tests
