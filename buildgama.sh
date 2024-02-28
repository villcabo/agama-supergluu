#!/bin/bash

boldGreen='\033[1;32m'
colorOff='\033[0m'
boldOff='\033[1m'

projectName="agama-supergluu.gama"

echo -e "$boldOff➔$colorOff Deleting $boldOff$projectName$colorOff ⏳ "
rm -rf $projectName
echo -e "$boldOff➔$colorOff $boldOff$projectName$colorOff Deleted! $boldGreen✔$colorOff"
echo -e " ⠸⠸⠸ "

echo -e "$boldOff➔$colorOff Building $boldOff$projectName$colorOff ⏳ "
zip -qr $projectName code lib web project.json
echo -e "$boldOff➔$colorOff $boldOff$projectName$colorOff Builded! $boldGreen✔$colorOff"
