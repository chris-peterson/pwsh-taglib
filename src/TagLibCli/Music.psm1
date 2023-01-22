function Get-MusicMetadata {
    [Alias('id3')]
    [Alias('Get-ID3')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject[]]
        $InputObject
    )

    process {
        foreach ($Item in $InputObject | Where-Object { $_ -is [System.IO.FileInfo] -and $_.FullName}) {
            try {
                $Meta = [TagLib.File]::Create($Item.FullName) |
                    Select-Object -ExpandProperty Tag
                $Meta | Add-Member -Force -NotePropertyName 'Track' -NotePropertyValue $('{0:D2}' -f $Meta.Track)
                Write-Output $Meta | New-TagLibCliObject 'TagLib.MusicItem'
            }
            catch {
                Write-Debug "Caught error getting $($Item.FullName) - $($_.Exception.Message)"
            }
        }
    }
}

function Rename-MusicFile {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
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
        foreach ($Item in $InputObject | Where-Object { $_ -is [System.IO.FileInfo]} ) {
            Write-Debug "Processing '$($Item.FullName)'..."
            $Meta = $Item | Get-MusicMetadata
            if ($Meta) {
                $NewNameParts = @()
                $PSCmdlet.MyInvocation.BoundParameters.Keys |
                    Where-Object { $_ -notin @('Debug', 'WhatIf', 'Confirm', 'InputObject') } |
                    ForEach-Object {
                        $Tag = $Meta.$_
                        if ($Tag) {
                            Write-Debug "$_ - $Tag"
                            if (-not [string]::IsNullOrWhiteSpace($Tag)) {
                                $NewNameParts += $Tag
                            }
                        }
                    }
                $NewName = $NewNameParts -join ' - '
                if ($PSCmdlet.ShouldProcess("$($Item.Name)", "Rename to '$NewName'")) {
                    $DestinationPath = "$(Join-Path -Path $Item.Directory.FullName $NewName)$($Item.Extension)"
                    Write-Debug $DestinationPath
                    Move-Item -Path $Item.FullName -Destination $DestinationPath
                }
            }
            else {
                Write-Debug "Skipping rename for $($Item.FullName) as metadata is incomplete"
            }
        }
    }
}
