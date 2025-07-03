#!/bin/bash
echo -e "\nBase Directory and Filename..."
BASEDIR00="$( cd "$( dirname "$0" )" && pwd )"
CURRDIR00=${BASEDIR00##*/}
FILENAME=`basename $0`; FILE=$(echo $FILENAME | cut -d '.' -f 1)
echo [${BASEDIR00}] [$CURRDIR00] [$FILENAME] [$FILE]
echo "......."
BASEDIR01=${BASEDIR00%/*}; CURRDIR01=${BASEDIR01##*/}
BASEDIR02=${BASEDIR01%/*}; CURRDIR02=${BASEDIR02##*/}
BASEDIR03=${BASEDIR02%/*}; CURRDIR03=${BASEDIR03##*/}
echo [$BASEDIR01] [$CURRDIR01]
echo [$BASEDIR02] [$CURRDIR02]
echo [$BASEDIR03] [$CURRDIR03]
echo "......."
cd ${BASEDIR00} && cd ../../
BRNCH=$(git rev-parse --abbrev-ref HEAD) && echo [$BRNCH]
BUILD="Dockerfile"
COMPA=$(echo $FILE | cut -d '-' -f 1)
GROUP=$(echo $FILE | cut -d '-' -f 2)
IMAGE=${CURRDIR03}/${CURRDIR02//"-"/"_"} && echo [$IMAGE]
if [ "$COMPA" != "$GROUP" ]; then
  BUILD=${BUILD}-${GROUP}
  IMAGE=${IMAGE}_${GROUP}:${BRNCH}
else
  IMAGE=${IMAGE}:${BRNCH}
fi
echo [$BUILD] [$BRNCH] [$GROUP] [$IMAGE]
cat ./${BUILD}
ls -al
if [ "$TYPE" == "Darwin" ]; then
  # ERROR [internal] load metadata for docker.io
  if [ -f ~/.docker/config.json ]; then
    rm  ~/.docker/config.json
  else
    mkdir ~/.docker
  fi
  cp ./docker/config.json ~/.docker/config.json
  chmod 755  ~/.docker/config.json
  docker build --file $BUILD --rm --tag $IMAGE .
  docker rmi -f $(docker images | grep "<none>" | awk "{print \$3}")
  docker images
else
  # ERROR [internal] load metadata for docker.io
  if [ -f ~/.docker/config.json ]; then
    sudo rm  ~/.docker/config.json
  else
    sudo mkdir ~/.docker
  fi
  sudo cp ./docker/config.json ~/.docker/config.json
  sudo chmod 755  ~/.docker/config.json
  sudo docker build --file $BUILD --rm --tag $IMAGE .
  sudo docker rmi -f $(sudo docker images | grep "<none>" | awk "{print \$3}")
  sudo docker images
fi
exit 0
