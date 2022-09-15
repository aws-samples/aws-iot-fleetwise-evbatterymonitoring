#/bin/bash

# Key pair
aws ec2 create-key-pair --key-name fleetwiseblogec2key | jq -r .KeyMaterial > fleetwiseblogec2key.pem

chmod 0600 fleetwiseblogec2key.pem

# Configure CLI
wget https://docs.aws.amazon.com/iot-fleetwise/latest/developerguide/samples/APIChange_iotfleetwise-preview.zip

unzip APIChange_iotfleetwise-preview.zip

aws configure add-model --service-name iotfleetwise --service-model file://iotfleetwise-2021-06-17.normal.json


# Repo checkout
git clone https://github.com/aws-samples/aws-iot-fleetwise-evbatterymonitoring 

# Create an AWS IAM role

aws iam create-role --role-name AWSIoTFleetWiseServiceRole --assume-role-policy-document file://1_setup/trustpol.json

aws iam create-policy --policy-name AWSIoTFleetwiseIAMUserPolicy --policy-document file://1_setup/policy.json

aws iam attach-role-policy --cli-input-json  file://1_setup/policy_attach.json

# Initial AWS IoT FleetWise configuration

aws iotfleetwise register-account --cli-input-json file://1_setup/account_registration.json
