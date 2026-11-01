param(
    [string]$InputFile,
    [switch]$All,
    [int]$Width = 256,
    [int]$Height = 256
)

# Check if Inkscape is installed
$inkscape = Get-Command "inkscape" -ErrorAction SilentlyContinue
if (-not $inkscape) {
    Write-Error "Inkscape is not installed or not in PATH."
    exit 1
}

function Convert-SvgToPng($file) {
    if (-not (Test-Path $file)) {
        Write-Warning "File not found: $file"
        return
    }

    $output = [System.IO.Path]::ChangeExtension($file, ".png")

    inkscape $file `
        --export-type=png `
        --export-filename="$output" `
        --export-width=$Width `
        --export-height=$Height

    Write-Host "Converted: $file -> $output ($Width x $Height)"
}

if ($All) {
    $svgs = Get-ChildItem -Filter "*.svg"
    if ($svgs.Count -eq 0) {
        Write-Warning "No SVG files found in current directory."
        exit
    }

    foreach ($svg in $svgs) {
        Convert-SvgToPng $svg.FullName
    }
}
elseif ($InputFile) {
    Convert-SvgToPng $InputFile
}
else {
    Write-Host "Usage:"
    Write-Host "  .\svgtopng.ps1 file.svg -Width 256 -Height 256"
    Write-Host "  .\svgtopng.ps1 -All -Width 256 -Height 256"
}
