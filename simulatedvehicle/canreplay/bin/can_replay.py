#!/usr/bin/python3
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import canigen
import time
import datetime
import argparse
import pandas as pd
import logging

parser = argparse.ArgumentParser(description='Generates SocketCAN messages for AWS IoT FleetWise demo')
parser.add_argument('inputfilename', type=str,  help='Path to CSV file to process')
parser.add_argument('--dbcfile', type=str,  help='DBC File for encoding', required=True )
parser.add_argument('--obdconfig', type=str,  help='OBD Configuration', required=True )
parser.add_argument('-i', '--interface', default='vcan0', help='CAN interface, e.g. vcan0')
parser.add_argument('--verbose', '-v', action='count', default=1, help='Provide more output')
parser.add_argument('--delimiter', '-d', default=",", help='Delimiter character')
parser.add_argument('-s', '--sleep-interval-ms', default=200, help='Sleep interval in ms')
args = parser.parse_args()

# Logging
logger = logging.getLogger()
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s: %(message)s',
                    datefmt='%Y-%m-%d %H:%M:%S')


# Load CSV File to data frame

logger.info(f"Loading input file {args.inputfilename}")
df = pd.read_csv(args.inputfilename, delimiter=args.delimiter, quotechar='|')


can_sim = canigen.canigen(
    interface=args.interface,
    database_filename=args.dbcfile,
    obd_config_filename=args.obdconfig)


def set_with_print(func, name, val):
    print(str(datetime.datetime.now())+" Set "+name+" to "+str(val))
    func(name, val)

success_count = 0
failure_count = 0

counter = 0 

while True:    
    for device_row in df.itertuples(index=False, name="CANRaw"):
            time.sleep(int(args.sleep_interval_ms)/1000)
            logger.info(f"Ingesting data {device_row}")
            # set_with_print(can_sim.set_sig, 'NAME FROM DBC FILE', getattr(device_row,"NAME FROM CSV FILE"))
            set_with_print(can_sim.set_sig, 'Main_Battery_Temperature_C', getattr(device_row,"Main_Battery_Temperature_C"))
            success_count = 1
            if counter < 20:
                can_sim.set_dtc('ECM_DTC1', 1)
                can_sim.set_dtc('ECM_DTC2', 1)
                can_sim.set_dtc('TCU_DTC1', 1)
                can_sim.set_dtc('TCU_DTC2', 1)
                can_sim.set_pid('ENGINE_SPEED', 49)

            if counter >= 20:
                can_sim.set_dtc('ECM_DTC1', 0)
                can_sim.set_dtc('ECM_DTC2', 0)
                can_sim.set_dtc('TCU_DTC1', 0)
                can_sim.set_dtc('TCU_DTC2', 0)
                can_sim.set_pid('ENGINE_SPEED', 49)

            if counter == 40:
                counter = 0

            counter = counter + 1
can_sim.stop()
