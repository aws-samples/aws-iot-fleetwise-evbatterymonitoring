#!/bin/sh
ROOTDIR=/home/ubuntu/aws-iot-fleetwise-evbatterymonitoring/simulatedvehicle/canreplay
python3 $ROOTDIR/bin/can_replay.py \
          $ROOTDIR/config/ev/evdemo_tempissue.csv \
         --sleep-interval 1000 \
         --delimiter ";" \
         --dbcfile $ROOTDIR/config/ev/evdemo.dbc \
         --obdconfig $ROOTDIR/config/ev/evdemo_obd_config.json




