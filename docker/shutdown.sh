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
VERTICAL="\nID\t\t{{.ID}}\nImage\t\t{{.Image}}\nCommand\t\t{{.Command}}\nCreated\t\t{{.RunningFor}}\nStatus\t\t{{.Status}}\nPorts\t\t{{.Ports}}\nNames\t\t{{.Names}}\n"
DOCKERNM=$(sudo docker ps -aq -f NAME=$IMAGE)
sudo docker kill $DOCKERNM
sudo docker stop $DOCKERNM
sudo docker rm $DOCKERNM
DOCKERNM=$(sudo docker ps -aq -f STATUS=exited)
sudo docker stop $DOCKERNM
sudo docker rm $DOCKERNM
sudo docker ps -a --format=$VERTICAL
sudo docker rmi -f $(sudo docker images | grep "<none>" | awk "{print \$3}")
sudo docker images
exit 0
