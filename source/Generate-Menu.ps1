# Define paths
$recipeSource = "H:\FoodMenu""  # Where your current files are
$docsDestination = "./docs/menu" # Where Docusaurus docs live

# Create destination folders if they don't exist
if (!(Test-Path $docsDestination)) { New-Item -ItemType Directory -Path $docsDestination }

# 1. Create the Category Metadata for the sidebar
$categoryYaml = @"
label: 'Food Menu'
position: 2
link:
  type: generated-index
  description: 'Browse our collection of delicious recipes.'
"@
$categoryYaml | Out-File -FilePath "$docsDestination/_category_.yml" -Encoding utf8

# 2. Process each recipe file
$files = Get-ChildItem -Path $recipeSource -Filter *.txt # Change extension as needed

foreach ($file in $files) {
    $name = $file.BaseName
    $slug = $name.ToLower().Replace(" ", "-")
    $content = Get-Content $file.FullName -Raw

    # Create the Markdown content with Docusaurus Front Matter
    $mdContent = @"
---
title: $name
sidebar_label: $name
slug: /$slug
---

# $name

$content
"@

    # Save to the Docusaurus docs folder
    $targetPath = Join-Path $docsDestination "$slug.md"
    $mdContent | Out-File -FilePath $targetPath -Encoding utf8

    Write-Host "Generated: $targetPath" -ForegroundColor Green
}