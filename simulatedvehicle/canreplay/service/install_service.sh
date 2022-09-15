#! /bin/sh
CONFIG_VEHICLE=$1

if [ -z ${CONFIG_VEHICLE+x} ]; then 
echo "Usage: $0 <vehicle name>"
exit 1
fi

ROOTDIR=/home/ubuntu/aws-iot-fleetwise-evbatterymonitoring/simulatedvehicle/canreplay

if [ -f /etc/systemd/system/evcansimulation.service ]; then
    sudo \cp -f $ROOTDIR/service/evcansimulation.$CONFIG_VEHICLE.service /etc/systemd/system/evcansimulation.service
    sudo systemctl daemon-reload
    sudo systemctl stop evcansimulation.service
    sudo systemctl disable evcansimulation.service
else
    sudo \cp -f $ROOTDIR/service/evcansimulation.$CONFIG_VEHICLE.service /etc/systemd/system/evcansimulation.service
fi

sudo systemctl enable evcansimulation.service
sudo systemctl start evcansimulation.service