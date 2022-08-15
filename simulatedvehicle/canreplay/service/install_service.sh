#! /bin/sh
ROOTDIR=/home/ubuntu/aws-iot-fleetwise-evbatterymonitoring/simulatedvehicle/canreplay

if [ -f /etc/systemd/system/evcansimulation.service ]; then
    sudo \cp -f $ROOTDIR/service/evcansimulation.service /etc/systemd/system/evcansimulation.service
    sudo systemctl daemon-reload
    sudo systemctl stop evcansimulation.service
    sudo systemctl disable evcansimulation.service
else
    sudo \cp -f $ROOTDIR/service/evcansimulation.service /etc/systemd/system/evcansimulation.service
fi

sudo systemctl enable evcansimulation.service
sudo systemctl start evcansimulation.service