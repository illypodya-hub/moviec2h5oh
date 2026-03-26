$ErrorActionPreference = "Stop"
$root = "c:\Users\TANK2\Desktop\moviec2h5oh-main"
$files = Get-ChildItem -Path $root -Filter *.html -Recurse

foreach ($file in $files) {
    # Skip the root index.html because we already fully hand-crafted it
    if ($file.FullName -eq "$root\index.html") {
        Write-Host "Skipping $file.FullName"
        continue
    }

    $content = Get-Content -Path $file.FullName -Raw

    # 1. Remove inline style
    $content = $content -replace '(?s)<style>.*?</style>', ''

    # 2. Add fonts and css link
    $styleLinks = @"
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/style.css">
</head>
"@
    # Only replace if not already replaced
    if ($content -notmatch 'style\.css') {
        $content = $content -replace '</head>', $styleLinks
    }

    # 3. Add orbs
    $orbs = @"
    <div class="bg-orb orb-1"></div>
    <div class="bg-orb orb-2"></div>
"@
    if ($content -notmatch 'bg-orb') {
        # Check if overlay exists
        if ($content -match '<div class="overlay">') {
            $content = $content -replace '(<div class="overlay">)', "`r`n`$1`r`n$orbs"
        } else {
            $content = $content -replace '(<body>)', "`r`n`$1`r`n$orbs"
        }
    }

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    Write-Host "Updated $($file.FullName)"
}
