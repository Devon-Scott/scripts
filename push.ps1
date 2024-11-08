param (
    [Parameter(Mandatory = $true)]
    [string]$CommitMessage
)

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
Run-GitCommand -Command "git" -Arguments "commit", "-m", "$CommitMessage" -ErrorMessage "Error: git commit failed."
Run-GitCommand -Command "git" -Arguments "pull" -ErrorMessage "Error: git pull failed."
Run-GitCommand -Command "git" -Arguments "push" -ErrorMessage "Error: git push failed."