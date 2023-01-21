function Get-MusicMetadata {
    [Alias('gmm')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject[]]
        $InputObject
    )

    begin {
    }

    process {
        foreach ($Item in $InputObject) {
            if ($Item.FullName) {
                [TagLib.File]::Create($Item.FullName) |
                    Select-Object -ExpandProperty Tag |
                    New-TagLibCliObject 'TagLib.MusicItem'
            }
        }
    }

    end {
    }
}
