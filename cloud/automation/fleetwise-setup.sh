git clone https://github.com/aws-samples/aws-iot-fleetwise-evbatterymonitoring 

aws ec2 create-key-pair --key-name fleetwiseblogec2key | jq -r .KeyMaterial > fleetwiseblogec2key.pem

chmod 0600 fleetwiseblogec2key.pem

aws cloudformation deploy \
        --parameter-overrides Ec2KeyPair=fleetwiseblogec2key \
        --template-file simulatedvehicle/ec2simulation/template.yaml \
        --stack-name vehiclesimulation --disable-rollback \
       --parameter-overrides Ec2KeyPair=fleetwiseblogec2key IoTCoreRegion=$AWS_REGION \
        --capabilities  "CAPABILITY_NAMED_IAM" 


Configure CLI
wget https://docs.aws.amazon.com/iot-fleetwise/latest/developerguide/samples/APIChange_iotfleetwise-preview.zip

unzip APIChange_iotfleetwise-preview.zip

aws configure add-model --service-name iotfleetwise --service-model file://iotfleetwise-2021-06-17.normal.json

Create AWS CLI input files
cd aws-iot-fleetwise-evbatterymonitoring/cloud
./prepare_templates.sh
cd cli-inputs


Create an AWS IAM role

aws iam create-role --role-name AWSIoTFleetWiseServiceRole --assume-role-policy-document file://1_setup/trustpol.json

aws iam create-policy --policy-name AWSIoTFleetwiseIAMUserPolicy --policy-document file://1_setup/policy.json

aws iam attach-role-policy --cli-input-json  file://1_setup/policy_attach.json

Initial AWS IoT FleetWise configuration

aws iotfleetwise register-account --cli-input-json file://1_setup/account_registration.json

Create signal catalog

aws iotfleetwise create-signal-catalog --cli-input-json file://2_signal_catalog/create-signal-catalog.json 



Create vehicle model manifest

# Model 1
aws iotfleetwise create-model-manifest --cli-input-json file://3_model_manifest/vehicle-model1.json

aws iotfleetwise update-model-manifest --status ACTIVE --name blog-modelmanifest-01

# Model 2
aws iotfleetwise create-model-manifest --cli-input-json file://3_model_manifest/vehicle-model2.json

aws iotfleetwise update-model-manifest --status ACTIVE --name blog-modelmanifest-02


Create decoder manifest

aws iotfleetwise create-decoder-manifest --cli-input-json file://4_decoder_manifest/decoder-manifest1.json

aws iotfleetwise update-decoder-manifest --status ACTIVE --name blog-decodermanifest-01

aws iotfleetwise create-decoder-manifest --cli-input-json file://4_decoder_manifest/decoder-manifest2.json

aws iotfleetwise update-decoder-manifest --status ACTIVE --name blog-decodermanifest-02

Create a vehicle

aws iotfleetwise create-vehicle --cli-input-json file://5_vehicle/vehicle01.json

aws iotfleetwise create-vehicle --cli-input-json file://5_vehicle/vehicle02.json

Create a fleet and associate vehicles with the fleet

aws iotfleetwise create-fleet --cli-input-json file://6_fleet/fleet.json
aws iotfleetwise associate-vehicle-fleet --fleet-id blog-fleet --vehicle-name blog-vehicle-01
aws iotfleetwise associate-vehicle-fleet --fleet-id blog-fleet --vehicle-name blog-vehicle-02

Initiate data collection campaigns

aws iotfleetwise create-campaign --cli-input-json file://7_campaign/fleettargeted-monitoring-campaign.json

aws iotfleetwise update-campaign --action APPROVE\
            --name fleettargeted-monitoring-campaign

aws iotfleetwise create-campaign --cli-input-json file://7_campaign/vehicletargeted-detailed-analysis-campaign.json

aws iotfleetwise update-campaign --action APPROVE\
            --name vehicletargeted-detailed-analysis-campaign

Connect to the simulated vehicle            

aws cloudformation describe-stacks --stack-name vehiclesimulation  --query "Stacks[0].Outputs[?OutputKey=='Ec2Instance1SSH'].OutputValue" --output text
