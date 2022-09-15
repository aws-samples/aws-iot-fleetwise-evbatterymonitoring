#/bin/bash
set -e

if [[ $(uname -a) == *"amzn2"* ]]; then
  # Install envsubst for Amazon Linux 2
  sudo yum install gettext -y
fi

# Check for envsubst
if ! command -v envsubst &> /dev/null
then
    echo "envsubst could not be found, but required to run this script"
    echo "If you are on Amazon Linux, please run [sudo yum install gettext -y]"
    exit 1
fi


if [ -z ${AWS_REGION} ]; then 
echo "AWS_REGION is not set, please set it to your preferred region"; 
else 
echo "AWS_REGION is set to ${AWS_REGION}"; 
fi


# Extract AWS account id
echo "[INFO] Calling 'aws sts get-caller-identity' to identify the AWS account id"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
echo "[INFO] AWS account id: $AWS_ACCOUNT_ID"
# Set AWS region
#export AWS_REGION=us-east-1
echo "[INFO] AWS region: $AWS_REGION"


# Iterate over all templates
for SOURCEFILEPATH in $(find cli-input-templates -name "*.json"); do
  if [ -f $SOURCEFILEPATH ]; then
    
    TARGETFILEPATH=$(echo $SOURCEFILEPATH | sed 's/-template//')
    TARGETFILEDIR="$(dirname "${TARGETFILEPATH}")" 
    echo "[INFO] Creating $TARGETFILEDIR"
    mkdir -p $TARGETFILEDIR
     envsubst '$AWS_REGION $AWS_ACCOUNT_ID' < $SOURCEFILEPATH > $TARGETFILEPATH
    echo "[INFO] Processed $TARGETFILEPATH to $TARGETFILEPATH"

  fi
done