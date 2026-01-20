$TargetDir = "H:\MakeMeASammich\website\docs\recipes\drinks\alcoholic-drinks"

Write-Host "Starting Smart Cleanup in: $TargetDir" -ForegroundColor Cyan

# ===============================
# CONFIG
# ===============================

$SkipExtensions  = @(".md", ".yml", ".yaml", ".ts", ".json")
$ImageExtensions = @(".jpg", ".jpeg", ".png", ".gif", ".webp")

# ===============================
# 1. Normalize Folder & File Names
# ===============================

Get-ChildItem -Path $TargetDir -Recurse |
    Sort-Object FullName -Descending |
    ForEach-Object {

        $newName = $_.Name.Replace(" ", "-").ToLower()

        if ($_.Name -cne $newName) {
            $tempName = "$($_.Name).tmp"

            Rename-Item $_.FullName $tempName -ErrorAction SilentlyContinue
            Rename-Item (Join-Path $_.DirectoryName $tempName) $newName -ErrorAction SilentlyContinue
        }
    }

# ===============================
# 2. Create Recipe Markdown from Images
# ===============================

Get-ChildItem -Path $TargetDir -Recurse -File | ForEach-Object {

    if ($ImageExtensions -notcontains $_.Extension) { return }

    $mdPath = Join-Path $_.DirectoryName "$($_.BaseName).md"

    if (Test-Path $mdPath) { return }

    $title = ($_.BaseName -replace "-", " ").ToUpper()
    $slug  = "/recipes/$($_.BaseName)"
    $imgName = $_.Name
    $imgAlt  = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
$content = @"
---
title: $title
sidebar_label: $title
serves: x
slug: $slug
---

# $title

![$imgAlt](./$imgName)

## Ingredients
-

## Preparation
1.

## Notes
-

:::note
This recipe page was auto-generated from the image **$imgName**.
Populate ingredients and steps by referencing the source image.
:::
"@


    $content | Out-File -FilePath $mdPath -Encoding utf8

    Write-Host "Created recipe template for image: $($_.Name)" -ForegroundColor Green
}

Write-Host "Cleanup Complete." -ForegroundColor Cyan
