#!/bin/bash
echo -e "\nBase Directory and Filename..."
BASEDIR00="$( cd "$( dirname "$0" )" && pwd )"
CURRDIR00=${BASEDIR00##*/}
FILENAME=`basename $0`; FILE=$(echo $FILENAME | cut -d '.' -f 1)
echo [${BASEDIR00}] [$CURRDIR00] [$FILENAME] [$FILE]
echo "......."
BASEDIR001=${BASEDIR00%/*}; CURRDIR01=${BASEDIR001##*/}
echo [${BASEDIR00}1] [$CURRDIR01]
echo "......."
cd ${BASEDIR00} && cd ..
IMAGE=${CURRDIR01//"-"/"_"} && echo [$IMAGE]
sudo docker exec -ti $IMAGE sh
exit 0
