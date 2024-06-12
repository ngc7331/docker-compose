#!/bin/bash

git branch -r | grep -v '\->' | grep -v 'main' | sed 's/origin\///g' | while read line; do
    git checkout $line
    git rebase main
    git push -f origin $line
done

git checkout main
