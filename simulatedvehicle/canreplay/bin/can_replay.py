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


import code
import readline
import canigen
import time
import datetime
import argparse
import pandas as pd
import logging

parser = argparse.ArgumentParser(
    description='Generates SocketCAN messages for AWS IoT FleetWise demo')
parser.add_argument('inputfilename', type=str,
                    help='Path to CSV file to process')
parser.add_argument('--dbcfile', type=str,
                    help='DBC File for encoding', required=True)
parser.add_argument('--obdconfig', type=str,
                    help='OBD Configuration', required=False)
parser.add_argument('-i', '--interface', default='vcan0',
                    help='CAN interface, e.g. vcan0')
parser.add_argument('--verbose', '-v', action='count',
                    default=1, help='Provide more output')
parser.add_argument('--delimiter', '-d', default=",",
                    help='Delimiter character')
parser.add_argument('-s', '--sleep-interval-ms',
                    default=200, help='Sleep interval in ms')
parser.add_argument('--dryrun', action='count',
                    default=1, help='Dry run, i.e. no CAN messages are sent')

args = parser.parse_args()

# Logging
logger = logging.getLogger()
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s: %(message)s',
                    datefmt='%Y-%m-%d %H:%M:%S')


# Load CSV File to data frame

logger.info(f"Loading input file {args.inputfilename}")
df = pd.read_csv(args.inputfilename, delimiter=args.delimiter, quotechar='|')

# Initialize CAN simulation
logger.info(f"Loading DBC file {args.dbcfile} for interface {args.interface}")

can_sim = canigen.canigen(
    interface=args.interface,
    database_filename=args.dbcfile,
    #    obd_config_filename=args.obdconfig
)

# Initialize variables
is_dryrun = args.dryrun > 1
count_successfull_rows = 0
count_successfull_files = 0

# Iterate over the CSV file and write data to CAN bus
while True:
    count_successfull_rows = 0
    for device_row in df.itertuples(index=False, name="CANRaw"):
        time.sleep(int(args.sleep_interval_ms)/1000)
        logger.info(f"Processing data row {device_row}")

        # Iterate over all signal names in the CSV file
        for signal_name in df.columns:

            if signal_name == "t":
                continue

            signal_value = float(getattr(device_row, signal_name))
            logger.info(
                f"[iteration {count_successfull_files}, row {count_successfull_rows}] Setting CAN {signal_name} to value {signal_value}")
            if is_dryrun:
                logger.info(f"Dry run, skipping the ingestion")
                continue
            else:
                can_sim.set_sig(signal_name, signal_value)

        count_successfull_rows += 1
    count_successfull_files += 1

can_sim.stop()
