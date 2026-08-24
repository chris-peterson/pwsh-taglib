# <img src="favicon.svg" alt="pwsh-taglib" width="64" height="64" style="vertical-align: middle"> pwsh-taglib

Read and rewrite music file tags from PowerShell, over
[TagLib#](https://github.com/mono/taglib-sharp).

## Installation

```powershell
Install-Module TagLibCli
```

## Commands

### `Get-MusicMetadata`

Aliased to `id3` and `Get-ID3`. Takes files from the pipeline and emits the
TagLib `File` and `Tag` for each one. Given no input it walks the current
directory recursively, so it works as a bare command:

```powershell
id3
```

```powershell
Get-ChildItem *.mp3 | Get-MusicMetadata
```

A file TagLib can't read is skipped rather than throwing; run with `-Debug` to
see which ones and why.

### `Rename-MusicFile`

Renames files from the tags they already carry. Pick the parts you want with
`-Track`, `-Album`, `-Artist`, and `-Title`:

```powershell
Get-ChildItem *.mp3 | Rename-MusicFile -Track -Title
```

It supports `-WhatIf` and `-Confirm`, so you can see the renames before
committing to them:

```powershell
Get-ChildItem *.mp3 | Rename-MusicFile -Artist -Album -Title -WhatIf
```
