#!/bin/sh

CONFIG_VEHICLE=$1

if [ -z ${CONFIG_VEHICLE+x} ]; then 
echo "Usage: $0 <vehicle name>"
exit 1
fi


SAMPLE_ROOT=/home/ubuntu/aws-iot-fleetwise-evbatterymonitoring
echo "Using SAMPLE_ROOT=[$SAMPLE_ROOT]"

echo "Using CONFIG_VEHICLE=[$CONFIG_VEHICLE]"

CONFIG_SCENARIO=ev_overcurrent_detection
echo "Using CONFIG_SCENARIO=[$CONFIG_SCENARIO]"

CONFIG_DIRECTORY_ROOT=$SAMPLE_ROOT/simulatedvehicle/canreplay/config/$CONFIG_VEHICLE/$CONFIG_SCENARIO
echo "Using CONFIG_DIRECTORY_ROOT=[$CONFIG_DIRECTORY_ROOT]"


python3 $SAMPLE_ROOT/simulatedvehicle/canreplay/bin/can_replay.py \
          $CONFIG_DIRECTORY_ROOT/$CONFIG_SCENARIO.txt \
         --sleep-interval 1000 \
         --dbcfile $CONFIG_DIRECTORY_ROOT/$CONFIG_SCENARIO.dbc\
         --delimiter "\t" 