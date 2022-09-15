#/bin/bash


# Create signal catalog

aws iotfleetwise create-signal-catalog --cli-input-json file://2_signal_catalog/create-signal-catalog.json 


# Create vehicle model manifest

# Model 1
aws iotfleetwise create-model-manifest --cli-input-json file://3_model_manifest/vehicle-model1.json

aws iotfleetwise update-model-manifest --status ACTIVE --name blog-modelmanifest-01

# Model 2
aws iotfleetwise create-model-manifest --cli-input-json file://3_model_manifest/vehicle-model2.json

aws iotfleetwise update-model-manifest --status ACTIVE --name blog-modelmanifest-02


# Create decoder manifest

aws iotfleetwise create-decoder-manifest --cli-input-json file://4_decoder_manifest/decoder-manifest1.json

aws iotfleetwise update-decoder-manifest --status ACTIVE --name blog-decodermanifest-01

aws iotfleetwise create-decoder-manifest --cli-input-json file://4_decoder_manifest/decoder-manifest2.json

aws iotfleetwise update-decoder-manifest --status ACTIVE --name blog-decodermanifest-02

# Create a vehicle

aws iotfleetwise create-vehicle --cli-input-json file://5_vehicle/vehicle01.json

aws iotfleetwise create-vehicle --cli-input-json file://5_vehicle/vehicle02.json

# Create a fleet and associate vehicles with the fleet

aws iotfleetwise create-fleet --cli-input-json file://6_fleet/fleet.json
aws iotfleetwise associate-vehicle-fleet --fleet-id blog-fleet --vehicle-name blog-vehicle-01
aws iotfleetwise associate-vehicle-fleet --fleet-id blog-fleet --vehicle-name blog-vehicle-02

# Initiate data collection campaigns

aws iotfleetwise create-campaign --cli-input-json file://7_campaign/conditional-snapshot-campaign.json
aws iotfleetwise update-campaign --action APPROVE\
            --name conditional-snapshot-campaign

aws iotfleetwise create-campaign --cli-input-json file://7_campaign/continious-monitoring-campaign.json
aws iotfleetwise update-campaign --action APPROVE\
            --name continious-monitoring-campaign

