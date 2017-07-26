#!/bin/bash
rm -rf /p7config/CITEST/delta
mkdir /CITEST/delta
git diff-tree --no-commit-id --diff-filter=ACM --name-only -r HEAD | xargs -I {} cp --parents {} /CITEST/delta
deltaPath="/CITEST/delta/src"
if [ -e $deltaPath ] 
then
groovy /CITEST/p7config/componentPackager.groovy /CITEST/p7config/componentHandler.json /CITEST/delta/src/ /CITEST/delta/src/package.xml
else
echo "error"
fi
