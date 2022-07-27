FROM gitpod/workspace-full

USER root

RUN brew update && brew install awscli docker-credential-helper-ecr

USER gitpod

# below is an inline bash script to populate this container with a helper script to run at login
# this is really a terrible idea and why aws_init.sh is used instead
RUN <<'EOF' bash
set -e


mkdir -p /home/gitpod/.aws/

cat <<'AWSINIT' >  /home/gitpod/.aws/init.sh
#!/bin/bash
set -e

# create the config for SSO login
# This assumes the below variables have been configured for this repo in gitpod
# https://www.gitpod.io/docs/environment-variables#using-the-account-settings
cat <<- AWSFILE > /home/gitpod/.aws/config
[default]
sso_start_url = ${AWS_SSO_URL}
sso_region = ${AWS_SSO_REGION}
sso_account_id = ${AWS_ACCOUNT_ID}
sso_role_name = ${AWS_ROLE_NAME}
region = ${AWS_REGION}
AWSFILE

# update docker config to use ecr-login

# make sure we have ecr-login
if [ ! -f /usr/local/bin/docker-credential-ecr-login ]; then
    ECR_LATEST=$(curl -s https://api.github.com/repos/awslabs/amazon-ecr-credential-helper/releases/latest | jq -r ".tag_name")
    curl -o docker-credential-ecr-login -fSsL "https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/${ECR_LATEST##*v}/linux-arm64/docker-credential-ecr-login"
    sudo mv docker-credential-ecr-login /usr/local/bin/docker-credential-ecr-login
    sudo chmod +x /usr/local/bin/docker-credential-ecr-login
fi

# if we don't have a .docker/config.json, create:

if [ ! -d /home/gitpod/.docker ]; then
    mkdir -p /home/gitpod/.docker && echo '{}' > /home/gitpod/.docker/config.json
elif [ ! -f /home/gitpod/.docker/config.json ]; then
    echo '{}' > /home/gitpod/.docker/config.json
fi

jq '.credHelpers["public.ecr.aws"]="ecr-login"' /home/gitpod/.docker/config.json > /home/gitpod/.docker/config_tmp.json
jq ".credHelpers[\"${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com\"]=\"ecr-login\"" /home/gitpod/.docker/config_tmp.json > /home/gitpod/.docker/config.json

AWSINIT

chmod +x /home/gitpod/.aws/init.sh

EOF

