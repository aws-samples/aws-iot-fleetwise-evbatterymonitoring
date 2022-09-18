# Troubleshooting the deployment of the AWS CloudFormation stack

This page provides guidance on diagnosing and troubleshooting the issues with the deployment of AWS CloudFormation stack used in the blog "Building an EV Battery Monitoring solution with AWS IoT FleetWise (Part 1/2)".

If the instructions below do not help you to resolve the problem, please [create an issue](https://github.com/aws-samples/aws-iot-fleetwise-evbatterymonitoring/issues/new) in this repository.

## Triage

Please complete the following steps to diagnose the root cause of the deployment issue:

1. Open [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation/home)
2. Click on "Stacks"
3. Click on the stack "vehiclesimulation"
4. Review the "Status". 
   - If the stack status is "CREATE_FAILED", proceed to the section "Troubleshooting failed stack deployment"
   - If the stack status is "CREATE_COMPLETE", proceed to the section "Troubleshooting other issues"


## Troubleshooting failed stack deployment

In the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation/home), please ensure you have selected the stack "vehiclesimulation".

Please perform the followign actions:

1. Click on the tab "Events"
2. Review the events and identify events with the status indicating an error, e.g. CREATE_FAILED
3. Review the "Status reason column" to identify possible root cause.


## Troubleshooting other issues

If the creation of the stack was completed with CREATE_COMPLETE, but you see no data in Amazon Timestream, please consider thc following steps:


1. In the AWS CloudFormation script output, run the following command to get guidance on establishing the SSH connection of the EC2 instance:

    aws cloudformation describe-stacks \
        --stack-name vehiclesimulation \
        --query "Stacks[0].Outputs[?OutputKey=='Ec2Instance1SSH'].OutputValue" \
        --output text

2. SSH into the Amazon EC2 instance:

    ssh -i ~/fleetwiseblogec2key.pem ubuntu@<Value of Vehicle1EC2PublicIP>

3. Check outputs of the software components involved into the solution:

    Initial setup log:
    `cat /var/log/cloud-init-output.log`


    FleetWise Edge Agent:
    `sudo journalctl -fu fwe@0`

    Vehicle siumulation script:
    `sudo journalctl -fu evcansumulation`


