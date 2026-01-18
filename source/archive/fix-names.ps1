$TargetDir = "H:\MakeMeASammich\website\docs\recipes"
Write-Host "Starting Smart Cleanup in: $TargetDir" -ForegroundColor Cyan

# 1. Rename Folders & Files (Lower-Dash & Case-Safe)
Get-ChildItem -Path $TargetDir -Recurse | ForEach-Object {
    $newName = $_.Name.Replace(" ", "-").ToLower()
    if ($_.Name -cne $newName) {
        $tempPath = "$($_.FullName)-temp"
        Rename-Item -Path $_.FullName -NewName "$($_.Name)-temp" -ErrorAction SilentlyContinue
        Rename-Item -Path $tempPath -NewName $newName -ErrorAction SilentlyContinue
    }
}

# 2. Process Files and Generate Markdown
Get-ChildItem -Path $TargetDir -Recurse -File | ForEach-Object {
    if ($_.Extension -match 'md|yml|ts|json') { return }

    $mdPath = Join-Path $_.DirectoryName "$($_.BaseName).md"

    if (-not (Test-Path $mdPath)) {
        $cleanTitle = $_.BaseName.Replace("-", " ").ToUpper()

        if ($_.Extension -match 'jpg|jpeg|png|gif|webp') {
            $linkSyntax = "![$($_.Name)](./$($_.Name))"
            $typeLabel = "Image"
        } else {
            $linkSyntax = "📄 [Click to Open Document: $($_.Name)](./$($_.Name))"
            $typeLabel = "Document"
        }

        # Fixed variable reference using ${} to avoid the ':' error
        $content = @"
---
title: $cleanTitle
---

# $cleanTitle

$linkSyntax

:::info
This page was auto-generated for the ${typeLabel}: $($_.Name).
:::
"@
        $content | Out-File -FilePath $mdPath -Encoding utf8
        Write-Host "Generated MD for ${typeLabel}: $($_.Name)" -ForegroundColor Green
    }
}

Write-Host "Cleanup Complete!" -ForegroundColor Cyan