@{
    ModuleVersion = '0.0.4'

    PrivateData = @{
        PSData = @{
            LicenseUri = 'https://github.com/chris-peterson/pwsh-taglib/blob/main/LICENSE'
            ProjectUri = 'https://github.com/chris-peterson/pwsh-taglib'
            ReleaseNotes = 'add wrapper type'
        }
    }

    GUID = 'e1c4c5ce-2148-4d76-8e23-6aa33ee2ebbe'

    Author = 'Chris Peterson'
    CompanyName = 'Chris Peterson'
    Copyright = '(c) 2023-2024'

    Description = 'Interact with TagLib# via PowerShell'
    PowerShellVersion = '7.1'

    RequiredAssemblies = @('TagLibSharp.dll')
    ScriptsToProcess = @()
    TypesToProcess = @('Types.ps1xml')
    FormatsToProcess = @('Formats.ps1xml')

    NestedModules = @(
        'Music.psm1',
        'Utilities.psm1'
    )
    FunctionsToExport = @(
        # Music
        'Get-MusicMetadata'
        'Rename-MusicFile'

        # Utilities
        'New-TagLibCliObject'
    )
    AliasesToExport = @(
        'id3'
    )
}
