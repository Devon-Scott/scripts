#!/bin/bash

# This script accepts a list of class names as arguments
# It then creates a skeleton folder structure for each class
# along with initializing a local git repo. It then creates a 
# remote repository for each class on GitHub, then pushes the local
# repo to the remote.

if [ $# -eq 0 ]; then
    echo "Usage: init.sh <list of class names>"
    exit
fi

for arg in "${@}"; do
    if [ -d "$arg" ]; then
        echo "Directory $arg already exists"
        cd $arg
    else
        mkdir $arg
        echo "Created directory $arg"
        cd $arg
    fi
    
    exists=false

    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Local git repo for $arg already exists"
        exists=true
    else
        git init
    fi

    for subdir in Assignments Labs Notes; do
        if [ ! -d "$subdir" ]; then
            mkdir "$subdir"
            touch "$subdir/.gitkeep"
        fi
    done
    touch ".gitignore"
    touch "README.md"
    echo "Created subfolders in $arg"
    git add .
    if $exists; then
        git commit -m "Updating commit after init.sh in $arg"
    else 
        git commit -m "Initial commit for $arg"
    fi

    if gh repo view $arg > /dev/null 2>&1; then
        echo "GitHub repository $arg already exists"
        cd ..
        continue
    fi

    gh repo create $arg --private --push --source .
    cd ..
done
    