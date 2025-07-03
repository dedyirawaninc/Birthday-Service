#!/bin/bash
echo -e "\nBase Directory and Filename..."
BASEDIR00="$( cd "$( dirname "$0" )" && pwd )"
CURRDIR00=${BASEDIR00##*/}
FILENAME=`basename $0`; FILE=$(echo $FILENAME | cut -d '.' -f 1)
echo [${BASEDIR00}] [$CURRDIR00] [$FILENAME] [$FILE]
echo "......."
cd ${BASEDIR00}
USERNAME=$(< ./username.txt)
PASSWORD=$(< ./password.txt)
echo [$USERNAME] [$PASSWORD]
TYPE=$(uname -s | cut -d '_' -f 1) && echo [$TYPE]
if [ "$TYPE" == "Darwin" ]; then
  security -v unlock-keychain ~/Library/Keychains/login.keychain-db
  echo $PASSWORD | docker login docker.io -u $USERNAME --password-stdin
else
  echo $PASSWORD | sudo docker login docker.io -u $USERNAME --password-stdin
fi
exit 0
