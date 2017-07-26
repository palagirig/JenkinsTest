#!/bin/bash
rm -rf /var/lib/jenkins/workspace/J_PRJ_NNN/delta
mkdir /var/lib/jenkins/workspace/J_PRJ_NNN/delta
git diff-tree --no-commit-id --diff-filter=ACM --name-only -r HEAD | xargs -I {} cp --parents {} /var/lib/jenkins/workspace/J_PRJ_NNN/delta
deltaPath="/var/lib/jenkins/workspace/J_PRJ_NNN/delta/src"
if [ -e $deltaPath ] 
then
groovy /var/lib/jenkins/p7config/componentPackager.groovy /var/lib/jenkins/p7config/componentHandler.json /var/lib/jenkins/workspace/J_PRJ_NNN/delta/src/ /var/lib/jenkins/workspace/J_PRJ_NNN/delta/src/package.xml
else
echo "error"
fi
