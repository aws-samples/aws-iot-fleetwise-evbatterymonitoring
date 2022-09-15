#/bin/bash
aws cloudformation deploy \
        --template-file simulatedvehicle/ec2simulation/template.yaml \
        --stack-name vehiclesimulation --disable-rollback \
       --parameter-overrides Ec2KeyPair=fleetwiseblogec2key \
       IoTCoreRegion=$AWS_REGION \
        --capabilities  "CAPABILITY_NAMED_IAM" 

