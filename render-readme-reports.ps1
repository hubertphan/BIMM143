param(
    [string]$RepoRoot = $(Split-Path -Parent $MyInvocation.MyCommand.Path),
    [string]$ReadmePath = 'README.md',
    [string]$QuartoExe = 'quarto',
    [switch]$DryRun,
    [switch]$Strict
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path $RepoRoot).Path
$readmeFullPath = Join-Path $repoRoot $ReadmePath

if (-not (Test-Path $readmeFullPath)) {
    throw "README not found: $readmeFullPath"
}

$renderOverrides = @{
    'FIND_A_GENE_PROJECT/Find_a_Gene_Assignment_part_1.html' = 'FIND_A_GENE_PROJECT/Find_a_Gene_Assignment.qmd'
    'FIND_A_GENE_PROJECT/Find_a_Gene_Assignment.html' = 'FIND_A_GENE_PROJECT/Find_a_Gene_Assignment.qmd'
}

function Resolve-SourcePath {
    param(
        [string]$HtmlLink
    )

    $normalizedLink = [System.Uri]::UnescapeDataString($HtmlLink).Replace('\', '/')

    if ($renderOverrides.ContainsKey($normalizedLink)) {
        return Join-Path $repoRoot $renderOverrides[$normalizedLink]
    }

    $candidateBase = $normalizedLink -replace '\.html?$',''
    $qmdPath = Join-Path $repoRoot ($candidateBase + '.qmd')
    if (Test-Path $qmdPath) {
        return $qmdPath
    }

    $rmdPath = Join-Path $repoRoot ($candidateBase + '.Rmd')
    if (Test-Path $rmdPath) {
        return $rmdPath
    }

    return $null
}

$readmeContent = Get-Content $readmeFullPath -Raw
$linkMatches = [regex]::Matches($readmeContent, '\[[^\]]+\]\(([^)]+\.html?)\)')

$htmlLinks = New-Object System.Collections.Generic.List[string]
$seen = New-Object 'System.Collections.Generic.HashSet[string]'
foreach ($match in $linkMatches) {
    $link = $match.Groups[1].Value
    if ($link -match '^(https?:)?//') {
        continue
    }

    if ($seen.Add($link)) {
        [void]$htmlLinks.Add($link)
    }
}

if ($htmlLinks.Count -eq 0) {
    Write-Host 'No local HTML links found in README.'
    exit 0
}

$rendered = New-Object System.Collections.Generic.List[string]
$skipped = New-Object System.Collections.Generic.List[string]
$failed = New-Object System.Collections.Generic.List[string]

foreach ($htmlLink in $htmlLinks) {
    $sourcePath = Resolve-SourcePath -HtmlLink $htmlLink

    if (-not $sourcePath) {
        $message = "No Quarto source found for $htmlLink"
        if ($Strict) {
            $failed.Add($message) | Out-Null
        } else {
            $skipped.Add($message) | Out-Null
        }
        continue
    }

    $sourceFullPath = (Resolve-Path $sourcePath).Path
    $sourceDir = Split-Path $sourceFullPath -Parent
    $sourceFile = Split-Path $sourceFullPath -Leaf

    if ($DryRun) {
        Write-Host "[dry-run] $QuartoExe render $sourceFullPath"
        $rendered.Add($sourceFullPath) | Out-Null
        continue
    }

    Write-Host "Rendering $sourceFullPath"
    Push-Location $sourceDir
    try {
        & $QuartoExe render $sourceFile
        if ($LASTEXITCODE -ne 0) {
            throw "Quarto exited with code $LASTEXITCODE"
        }
        $rendered.Add($sourceFullPath) | Out-Null
    } catch {
        $failed.Add("$sourceFullPath :: $($_.Exception.Message)") | Out-Null
    } finally {
        Pop-Location
    }
}

Write-Host ''
Write-Host ("Rendered: {0}" -f $rendered.Count)
foreach ($item in $rendered) {
    Write-Host ("  OK   {0}" -f $item)
}

if ($skipped.Count -gt 0) {
    Write-Warning ("Skipped: {0}" -f $skipped.Count)
    foreach ($item in $skipped) {
        Write-Warning ("  SKIP {0}" -f $item)
    }
}

if ($failed.Count -gt 0) {
    Write-Error ("Failed: {0}`n  {1}" -f $failed.Count, ($failed -join "`n  "))
    exit 1
}
