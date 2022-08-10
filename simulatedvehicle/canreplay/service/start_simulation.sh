#!/bin/sh
ROOTDIR=/home/ubuntu/aws-iot-fleetwise-batterymonitoring/simulatedvehicle/canreplay
python3 $ROOTDIR/bin/can_replay_v2.py \
          $ROOTDIR/config/evdemo_tempissue.csv \
         --sleep-interval 1000 \
         --dbcfile $ROOTDIR/config/evsample.dbc \
         --obdconfig $ROOTDIR/config/evdemo_obd_config.json




