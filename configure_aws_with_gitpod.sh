#!/bin/bash
set -e

# update AWS CLI
OLD_DIR="$PWD"
TMP_DIR="$(mktemp -d)"
echo "Updating AWS"
cd "${TMP_DIR}" || exit 1

curl -fSsl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qq awscliv2.zip
sudo ./aws/install --update
rm awscliv2.zip

cd "${OLD_DIR}" || exit 1
rm -rf "${TMP_DIR}"

# make sure we have ecr-login
if [ ! -f /usr/local/bin/docker-credential-ecr-login ]; then
    echo "Installing ecr-login helper"
    OLD_DIR="$PWD"
    TMP_DIR="$(mktemp -d)"
    cd "${TMP_DIR}" || exit 1
    ECR_LATEST=$(curl -s https://api.github.com/repos/awslabs/amazon-ecr-credential-helper/releases/latest | jq -r ".tag_name")
    curl -o docker-credential-ecr-login -fSsL "https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/${ECR_LATEST##*v}/linux-amd64/docker-credential-ecr-login"
    curl -o docker-credential-ecr-login.sha256 -fSsL "https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/${ECR_LATEST##*v}/linux-amd64/docker-credential-ecr-login.sha256"
    sha256sum -c docker-credential-ecr-login.sha256
    sudo mv docker-credential-ecr-login /usr/local/bin/docker-credential-ecr-login
    sudo chmod +x /usr/local/bin/docker-credential-ecr-login
    cd "${OLD_DIR}" || exit 1
    rm -rf "${TMP_DIR}"
fi

# This should be moved to the workspace image.
if ! command -v session-manager-plugin; then
    echo "Installing AWS session manager plugin"

      TMP_DIR="$(mktemp -d)"
      cd "$TMP_DIR" || exit 1

      curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
      sudo dpkg -i "session-manager-plugin.deb"

      cd "$OLD_DIR"
      rm -rf "$TMP_DIR"
fi


AWS_VARS=(AWS_SSO_URL AWS_SSO_REGION AWS_ACCOUNT_ID AWS_ROLE_NAME AWS_REGION)

for AWS_VAR in "${AWS_VARS[@]}"; do
  echo "$AWS_VAR is ${!AWS_VAR}"
    if [[ -z "${!AWS_VAR}" ]]; then
        echo "Error: AWS variable \"$AWS_VAR\" is unset"
        AWS_VAR_UNSET=true
    fi
done

if ! [[ -z "$AWS_VAR_UNSET" ]]; then
    SCRIPT=$(realpath "$0")
    echo "AWS Variables are not set, skipping autoconfig of files."
    echo "Re-run ${SCRIPT} when AWS_ variables are set."
    echo "set you AWS_ variables in https://gitpod.io/variables ." 
    echo "For more help, you can refer these docs: https://www.gitpod.io/docs/environment-variables#using-the-account-settings ."
    exit 1
fi


# create the config for SSO login

# This assumes the below variables have been configured for this repo in gitpod
# https://www.gitpod.io/docs/environment-variables#using-the-account-settings
echo "Forcing AWS config to just use SSO credentials"
[[ -d /home/gitpod/.aws ]] || mkdir /home/gitpod/.aws
cat <<- AWSFILE > /home/gitpod/.aws/config
[default]
sso_start_url = ${AWS_SSO_URL}
sso_region = ${AWS_SSO_REGION}
sso_account_id = ${AWS_ACCOUNT_ID}
sso_role_name = ${AWS_ROLE_NAME}
region = ${AWS_REGION}
AWSFILE

# update docker config to use ecr-login
# if we don't have a .docker/config.json, create:

if [ ! -d /home/gitpod/.docker ]; then
    mkdir -p /home/gitpod/.docker && echo '{}' > /home/gitpod/.docker/config.json
elif [ ! -f /home/gitpod/.docker/config.json ]; then
    echo '{}' > /home/gitpod/.docker/config.json
fi

echo "Ensuring Docker Config uses ecr-login for ECR repositories"

cp /home/gitpod/.docker/config.json /home/gitpod/.docker/config_bak.json
jq '.credHelpers["public.ecr.aws"]="ecr-login"' /home/gitpod/.docker/config.json > /home/gitpod/.docker/config_tmp.json
jq ".credHelpers[\"${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com\"]=\"ecr-login\"" /home/gitpod/.docker/config_tmp.json > /home/gitpod/.docker/config.json
rm /home/gitpod/.docker/config_tmp.json

echo "All Things whcih are required for AWS SSO & ECR Login are Installed & Configured Successfully."
echo "Now, You can Start an AWS SSO login session."
