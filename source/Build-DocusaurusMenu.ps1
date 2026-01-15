# Configuration
$SourceRoot = "H:\FoodMenu"
$DocsDestination = "H:\John\Documents\MakeMeASammich\website\docs"

function Create-DocusaurusFiles($CurrentPath, $DestPath) {
    # 1. Generate _category_.yml for the current directory
    $FolderName = Split-Path $CurrentPath -Leaf
    $CategoryYaml = @"
label: '$FolderName'
link:
  type: generated-index
"@
    if (!(Test-Path $DestPath)) { New-Item -ItemType Directory -Path $DestPath -Force }
    $CategoryYaml | Out-File -FilePath (Join-Path $DestPath "_category_.yml") -Encoding utf8

    # 2. Process Files
    $Items = Get-ChildItem -Path $CurrentPath
    foreach ($Item in $Items) {
        $DestItemPath = Join-Path $DestPath $Item.Name

        if ($Item.PSIsContainer) {
            # Recursive call for subdirectories
            Create-DocusaurusFiles $Item.FullName $DestItemPath
        }
        else {
            # Convert recipe files to Template Markdown
            $RecipeName = $Item.BaseName
            $Slug = $RecipeName.ToLower().Replace(" ", "-")
            $Content = Get-Content $Item.FullName -Raw

            $MarkdownTemplate = @"
---
title: $RecipeName
sidebar_label: $RecipeName
slug: /$Slug
---

## RECIPE $RecipeName

**Ready in:** [Insert Time]
**Serves:** [Insert Servings]

### Ingredients
$Content

### Preparation
1. Follow the mixing instructions provided in the source.

---
"@
            $MarkdownTemplate | Out-File -FilePath (Join-Path $DestPath "$Slug.md") -Encoding utf8
        }
    }
}

Create-DocusaurusFiles $SourceRoot $DocsDestination
Write-Host "Docusaurus menu structure generated successfully!" -ForegroundColor Green