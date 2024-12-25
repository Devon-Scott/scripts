param (
    [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
    [string[]]$Classes
)

if ($Classes.Count -eq 0) {
    Write-Host "Usage: .\startSemester.ps1 <list of class names>"
    exit
}

foreach ($class in $Classes) {
    if (Test-Path $class -PathType Container) {
        Write-Host "Directory $class already exists"
        Set-Location $class
    }
    else {
        New-Item -ItemType Directory -Name $class | Out-Null
        Write-Host "Created directory $class"
        Set-Location $class
    }

    $exists = $false
    & git rev-parse --is-inside-work-tree *>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Local git repo for $class already exists"
        $exists = $true
    }
    else {
        & git init
    }

    foreach ($subdir in "Assignments","Labs","Notes") {
        if (!(Test-Path $subdir -PathType Container)) {
            New-Item -ItemType Directory -Name $subdir | Out-Null
            New-Item -Path "$subdir\.gitkeep" -ItemType File | Out-Null
        }
    }
    if (!(Test-Path ".gitignore")) { New-Item -ItemType File -Name ".gitignore" | Out-Null }
    if (!(Test-Path "README.md"))  { New-Item -ItemType File -Name "README.md"  | Out-Null }
    Write-Host "Created subfolders in $class"

    & git add .
    if ($exists) {
        & git commit -m "Updating commit after init.ps1 in $class"
    }
    else {
        & git commit -m "Initial commit for $class"
    }

    & gh repo view $class *>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "GitHub repository $class already exists"
        Set-Location ..
        continue
    }

    & gh repo create $class --private --push --source .
    Set-Location ..
}