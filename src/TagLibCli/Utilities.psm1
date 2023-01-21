function New-TagLibCliObject {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $InputObject,

        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $DisplayType
    )
    Begin{}
    Process {
        foreach ($Item in $InputObject) {
            $Wrapper = New-Object PSObject
            $Item.PSObject.Properties |
                Sort-Object Name |
                ForEach-Object {
                    $Wrapper | Add-Member -MemberType NoteProperty -Name $_.Name -Value $_.Value
                }
            
            
            if ($DisplayType) {
                $Wrapper.PSTypeNames.Insert(0, $DisplayType)
            }
            Write-Output $Wrapper
        }
    }
    End{}
}
