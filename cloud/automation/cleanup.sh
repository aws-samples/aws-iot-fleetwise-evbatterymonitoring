#/bin/bash
aws iotfleetwise delete-vehicle --vehicle-name blog-vehicle-01
aws iotfleetwise delete-vehicle --vehicle-name blog-vehicle-02

aws iotfleetwise delete-campaign --name fleettargeted-monitoring-campaign
aws iotfleetwise delete-campaign --name vehicletargeted-detailed-analysis-campaign

aws iotfleetwise delete-fleet --fleet-id blog-fleet

aws iotfleetwise delete-decoder-manifest --name blog-decodermanifest-01
aws iotfleetwise delete-decoder-manifest --name blog-decodermanifest-02

aws iotfleetwise delete-model-manifest --name blog-modelmanifest-01
aws iotfleetwise delete-model-manifest --name blog-modelmanifest-02

aws iotfleetwise delete-signal-catalog --name main-signal-catalog