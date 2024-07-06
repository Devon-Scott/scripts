if ($args.Count -ne 1) {
    Write-Error "Usage: push.ps1 <commit message>";
    exit 1;
}

git add .;
git commit -m "$args[0]";
git push;