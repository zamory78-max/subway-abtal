# Downloads the libraries the game uses into app\src\main\assets\www\lib
# so the Android app runs 100% offline. Run once before building (Windows).
$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'

$LIB = 'app/src/main/assets/www/lib'
New-Item -ItemType Directory -Force -Path "$LIB/fontawesome/css", "$LIB/fontawesome/webfonts", "$LIB/cairo" | Out-Null

function Get-File([string]$Url, [string]$Dest, [switch]$Required) {
    Write-Host "-> $Dest"
    try {
        Invoke-WebRequest -Uri $Url -OutFile $Dest -UseBasicParsing
    } catch {
        if (Test-Path $Dest) { Remove-Item $Dest -Force }
        if ($Required) { throw "FAILED (required): $Url" }
        Write-Warning "skipped (optional): $Url"
    }
}

# 3D engine (required)
Get-File 'https://cdn.jsdelivr.net/npm/three@0.128.0/build/three.min.js' "$LIB/three.min.js" -Required

# Tailwind CSS runtime (required for the menus layout)
Get-File 'https://cdn.tailwindcss.com/3.4.16' "$LIB/tailwind.js"
if (-not (Test-Path "$LIB/tailwind.js")) { Get-File 'https://cdn.tailwindcss.com' "$LIB/tailwind.js" -Required }

# Font Awesome icons
$FA = 'https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0'
Get-File "$FA/css/all.min.css" "$LIB/fontawesome/css/all.min.css"
foreach ($f in 'fa-solid-900', 'fa-regular-400', 'fa-brands-400', 'fa-v4compatibility') {
    Get-File "$FA/webfonts/$f.woff2" "$LIB/fontawesome/webfonts/$f.woff2"
    Get-File "$FA/webfonts/$f.ttf" "$LIB/fontawesome/webfonts/$f.ttf"
}

# Cairo Arabic font
$CA = 'https://cdn.jsdelivr.net/npm/@fontsource/cairo@5/files'
foreach ($w in 600, 700, 800, 900) {
    foreach ($s in 'arabic', 'latin') {
        Get-File "$CA/cairo-$s-$w-normal.woff2" "$LIB/cairo/cairo-$s-$w-normal.woff2"
    }
}

Write-Host "Done. Libraries are in $LIB" -ForegroundColor Green
