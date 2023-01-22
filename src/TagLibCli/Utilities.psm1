function New-TagLibCliObject {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $InputObject,

        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $DisplayType
    )
    process {
        foreach ($Item in $InputObject) {
            if ($DisplayType) {
                $Item.PSTypeNames.Insert(0, $DisplayType)
            }
            Write-Output $Item
        }
    }
}
