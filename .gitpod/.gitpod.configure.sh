#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# assert that the required AWS variables are configured in Gitpod
# https://www.gitpod.io/docs/environment-variables#using-the-account-settings
AWS_VARS=(AWS_SSO_URL AWS_SSO_REGION AWS_ACCOUNT_ID AWS_ROLE_NAME AWS_REGION)

for AWS_VAR in "${AWS_VARS[@]}"; do
    if [[ -z "${!AWS_VAR}" ]]; then
        echo "ERROR: The AWS variable \"$AWS_VAR\" is not set"
        AWS_VAR_UNSET=true
    fi
done

if ! [[ -z "$AWS_VAR_UNSET" ]]; then
    echo "ERROR: The AWS variables above are not set and thus authentication will not work"
    exit 1
fi

# Create the AWS configuration for SSO login
mkdir -p /home/gitpod/.aws
cat <<- AWSFILE > /home/gitpod/.aws/config
[default]
sso_start_url = ${AWS_SSO_URL}
sso_region = ${AWS_SSO_REGION}
sso_account_id = ${AWS_ACCOUNT_ID}
sso_role_name = ${AWS_ROLE_NAME}
region = ${AWS_REGION}
AWSFILE

# Update the docker configuration to use ecr-login
mkdir -p /home/gitpod/.docker
sudo bash -c 'echo "{}" > /home/gitpod/.docker/config.json'
sudo bash -c 'jq ".credHelpers[\"public.ecr.aws\"]=\"ecr-login\"" /home/gitpod/.docker/config.json > /home/gitpod/.docker/config_tmp.json'
sudo bash -c 'jq ".credHelpers[\"${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com\"]=\"ecr-login\"" /home/gitpod/.docker/config_tmp.json > /home/gitpod/.docker/config.json'
sudo bash -c 'rm /home/gitpod/.docker/config_tmp.json'
