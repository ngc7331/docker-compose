#!/bin/bash

git branch -r | grep -v '\->' | while read line; do
    app=$(echo $line | sed 's/origin\///g')
    if [ "$app" == "main" ]; then
        continue
    fi
    git checkout $app
    git rebase main
    git push -f origin $app
done

git checkout main
