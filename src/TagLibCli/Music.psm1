function Get-MusicMetadata {
    [Alias('id3')]
    [Alias('Get-ID3')]
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject[]]
        $InputObject
    )

    process {
        if ($InputObject) {
            foreach ($Item in $InputObject) {
                if ($_ -is [System.IO.FileInfo]) {
                    try {
                        $File = [TagLib.File]::Create($Item.FullName)
                        Write-Output $([PSCustomObject]@{
                            File = $File
                            Tag  = $File.Tag
                        } | New-TagLibCliObject 'TagLib.MusicItem')
                    }
                    catch {
                        Write-Debug "Caught error getting $($Item.FullName) - $($_.Exception.Message)"
                    }
                }
            }
        }
        else {
            Get-ChildItem -Recurse | Get-MusicMetadata
        }
    }
}

function Rename-MusicFile {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSObject[]]
        $InputObject,

        [Parameter()]
        [switch]
        $Track,

        [Parameter()]
        [switch]
        $Album,

        [Parameter()]
        [switch]
        $Artist,

        [Parameter()]
        [switch]
        $Title
    )

    process {
        foreach ($Item in $InputObject) {
            $Meta = $null
            if ($Item.Tag?.GetType().FullName -eq 'TagLib.NonContainer.Tag') {
                Write-Debug "Processing tag '$($Item.Path)'..."
                $Meta = $Item
            }
            elseif ($Item.Tag?.GetType().FullName -eq 'TagLib.CombinedTag') {
                Write-Debug "Processing combined tag '$($Item.Path)'..."
                $Meta = $Item
            }
            elseif ($Item -is [System.IO.FileInfo]) {
                Write-Debug "Processing file '$($Item.FullName)'..."
                $Meta = $Item | Get-MusicMetadata
            }
            else {
                Write-Warning "Skipping unknown item ($Item)"
            }
            if ($Meta) {
                $NewNameParts = @()
                $PSCmdlet.MyInvocation.BoundParameters.Keys |
                    Where-Object { $_ -notin @('Debug', 'WhatIf', 'Confirm', 'InputObject') } |
                    ForEach-Object {
                        Write-Debug "checking $_ on $($Meta.GetType()) / $($Meta.Path)"
                        $Tag = $Meta.$_ ?? $Meta.Tag.$_
                        if ($Tag) {
                            Write-Debug "$_ - $Tag"
                            if (-not [string]::IsNullOrWhiteSpace($Tag)) {
                                $NewNameParts += $Tag
                            }
                        }
                        else {
                            Write-Debug "Could not retrieve $_ from $($Meta.Path)"
                        }
                    }
                    $NewName = $NewNameParts -join ' - '
                    $DestinationPath = "$(Join-Path -Path $Item.Directory.FullName $NewName)$($Item.Extension)"
                    if ($PSCmdlet.ShouldProcess("$($Item.FullName)", "Rename to '$DestinationPath'")) {
                        Move-Item -Path $Item.FullName -Destination $DestinationPath
                    }
            }
        }
    }
}
