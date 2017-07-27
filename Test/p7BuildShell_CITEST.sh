#!/bin/bash
rm -rf /var/lib/jenkins/workspace/CITEST/delta
mkdir /var/lib/jenkins/workspace/CITEST/delta
git diff-tree --no-commit-id --diff-filter=ACM --name-only -r HEAD | xargs -I {} cp --parents {} /var/lib/jenkins/workspace/CITEST/delta
deltaPath="/var/lib/jenkins/workspace/CITEST/delta/src"
if [ -e $deltaPath ] 
then
groovy /var/lib/jenkins/workspace/CITEST/p7config/componentPackager.groovy /var/lib/jenkins/workspace/CITEST/p7config/componentHandler.json /var/lib/jenkins/workspace/CITEST/delta/src/ /var/lib/jenkins/workspace/CITEST/delta/src/package.xml
else
echo "Perhaps nothing to deploy or check access issues"
fi