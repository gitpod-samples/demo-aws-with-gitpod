FROM gitpod/workspace-full

USER root

# Install the AWS CLI
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
RUN cd /tmp && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install the Amazon ECR Docker Credential Helper
# https://github.com/awslabs/amazon-ecr-credential-helper
RUN apt-get install -y amazon-ecr-credential-helper

# Install the AWS Session Manager plugin
# https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
RUN cd /tmp && \
    curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" && \
    sudo dpkg -i session-manager-plugin.deb && \
    rm -rf session-manager-plugin.deb

# Configure AWS with Gitpod
RUN mkdir -p /home/gitpod/.aws /home/gitpod/.docker
COPY .gitpod/.gitpod.configure.sh /home/gitpod/.aws/configure.sh
RUN echo ". /home/gitpod/.aws/configure.sh" >> /home/gitpod/.bashrc
