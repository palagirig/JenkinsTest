#!/bin/bash
rm -rf /var/lib/jenkins/workspace/CITEST/delta
mkdir /var/lib/jenkins/workspace/CITEST/delta

git diff-tree --no-commit-id --diff-filter=ACM --name-only -r HEAD | xargs -I {} cp --parents {} /var/lib/jenkins/workspace/CITEST/delta
deltaCount=$(git diff-tree --no-commit-id --diff-filter=ACM --name-only -r HEAD src| wc -l)
echo $deltaCount " files to process ..."
if(expr $deltaCount > 0)
then
touch delta/go.further
else
echo "Nothing to deploy this time!!"
fi