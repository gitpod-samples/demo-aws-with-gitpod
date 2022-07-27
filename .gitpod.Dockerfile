FROM gitpod/workspace-full

USER root

RUN brew update && brew install awscli docker-credential-helper-ecr
