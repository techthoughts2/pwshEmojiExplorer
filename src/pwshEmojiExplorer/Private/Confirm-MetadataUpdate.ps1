<#
.SYNOPSIS
    Compares the local metadata file to the remote metadata file.
.DESCRIPTION
    Evaluates the local metadata file and compares it to the remote metadata file. If the files are the same, returns true. If the files are different, returns false.
.EXAMPLE
    Confirm-MetadataUpdate

    Compares the local metadata file to the remote metadata file.
.OUTPUTS
    System.Boolean
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    pwshEmojiExplorer
#>
function Confirm-MetadataUpdate {
    [CmdletBinding()]
    param (
    )
    $result = $true #assume the best

    Write-Verbose -Message 'Checking for metadata file...'
    $localMetaDataFilePath = [System.IO.Path]::Combine($script:dataPath, $script:metadataFile)
    Write-Debug -Message ('Metadata file path: {0}' -f $localMetaDataFilePath)
    try {
        $pathEval = Test-Path -Path $localMetaDataFilePath -ErrorAction Stop
    }
    catch {
        $result = $false
        Write-Error $_
        return $result
    }

    if (-not ($pathEval)) {
        $result = $false
        Write-Debug -Message 'Metadata file not found.'
    } #if_pathEval
    else {
        Write-Verbose 'Metadata file found. Performing metadata comparison...'
        try {
            $localMetadata = Get-Content $localMetaDataFilePath -ErrorAction 'Stop' | ConvertFrom-Json
        }
        catch {
            $result = $false
            Write-Error $_
            return $result
        }

        $tempMetadataFile = '{0}_temp' -f $script:metadataFile
        $tempMetadataFilePath = [System.IO.Path]::Combine($script:dataPath, $tempMetadataFile)
        Write-Debug -Message ('Temp metadata file path: {0}' -f $tempMetadataFilePath)
        # if the temp metadata file exists, delete it
        if (Test-Path -Path $tempMetadataFile) {
            Write-Debug -Message 'Removing temp metadata file...'
            Remove-Item -Path $tempMetadataFilePath -Force
        }

        # download metadata file for comparison
        $fileFetchStatus = Get-RemoteFile -File $script:metadataFile -OutFile $tempMetadataFile
        if ($fileFetchStatus -eq $false) {
            Write-Error 'Unable to download metadata file.'
            $result = $false
            return $result
        }

        Write-Debug -Message 'Getting content of temp metadata file...'
        try {
            $remoteMetadata = Get-Content $tempMetadataFilePath -ErrorAction 'Stop' | ConvertFrom-Json
        }
        catch {
            $result = $false
            Write-Error $_
            return $result
        }

        Write-Debug -Message ('Local metadata version: {0}' -f $localMetadata.version)
        Write-Debug -Message ('Remote metadata version: {0}' -f $remoteMetadata.version)

        Write-Verbose -Message ('{0} vs {1}' -f $localMetadata.version, $remoteMetadata.version)
        if ($localMetadata.version -eq $remoteMetadata.version) {
            Write-Verbose 'Metadata file is current.'
        }
        else {
            Write-Verbose 'Metadata file requires refresh.'
            $result = $false
        }
    }

    return $result
} #Confirm-MetadataUpdate
