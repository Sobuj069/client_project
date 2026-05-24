$htmlContent = Get-Content -Path "index.html" -Raw

# Find all occurrences of the absolute path
$pattern = 'src="C:/Users/HP/\.gemini/antigravity/brain/90b72793-7ada-45d6-a602-73d4cc9fc0c6/([^"]+\.(png|jpg|jpeg))"'

# Create assets directory if it doesn't exist
If (!(Test-Path -Path "assets")) {
    New-Item -ItemType Directory -Path "assets"
}

# Find all matches
$matches = [regex]::Matches($htmlContent, $pattern)

foreach ($match in $matches) {
    $fullUrl = $match.Value -replace 'src="', '' -replace '"', ''
    $fileName = $match.Groups[1].Value
    
    Write-Host "Copying $fileName"
    
    # Copy file to assets
    Copy-Item -Path $fullUrl -Destination "assets/$fileName" -ErrorAction SilentlyContinue
    
    # Replace in HTML
    $htmlContent = $htmlContent -replace [regex]::Escape($match.Value), "src=`"assets/$fileName`""
}

Set-Content -Path "index.html" -Value $htmlContent
Write-Host "Done replacing and copying."
