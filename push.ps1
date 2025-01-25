param (
    [Parameter(Mandatory = $true)]
    [string]$CommitMessage,
    [string]$DetailedMessage
)

if (!(Get-Command git.exe -ErrorAction SilentlyContinue)) {
    Write-Error "Git is not installed or not on the PATH."
    exit 1
}

function Run-GitCommand {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Command,
        [string[]]$Arguments,
        [string]$ErrorMessage
    )
    try {
        & $Command @Arguments
        if ($LASTEXITCODE -ne 0) {
            Write-Error $ErrorMessage
            exit 1
        }
    } catch {
        Write-Error "$ErrorMessage`n$($_.Exception.Message)"
        exit 1
    }
}

Run-GitCommand -Command "git" -Arguments "add", "." -ErrorMessage "Error: git add failed."

$commitArgs = @("commit", "-m", $CommitMessage)
if ($DetailedMessage) {
    $commitArgs += "-m"
    $commitArgs += $DetailedMessage
}

Run-GitCommand -Command "git" -Arguments $commitArgs -ErrorMessage "Error: git commit failed."
Run-GitCommand -Command "git" -Arguments "pull" -ErrorMessage "Error: git pull failed."
Run-GitCommand -Command "git" -Arguments "push" -ErrorMessage "Error: git push failed."