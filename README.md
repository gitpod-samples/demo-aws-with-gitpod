# Gitpod with AWS

This repository contains an example of how to integrate AWS Single Sign-On (SSO) and [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/) with Gitpod.

## Demo

[Configure Secrets](#configure-secrets) & Hit Below button:

<a href="https://gitpod.io/#https://github.com/gitpod-io/demo-gitpod-with-aws"><img src="https://gitpod.io/button/open-in-gitpod.svg"/></a>


## Secret Management

### Secrets Key-Value Map

```bash
sso_start_url = ${AWS_SSO_URL}
sso_region = ${AWS_SSO_REGION}
sso_account_id = ${AWS_ACCOUNT_ID}
sso_role_name = ${AWS_ROLE_NAME}
region = ${AWS_REGION}
```

### Configure secrets

- Configure the following secrets [here in Gitpod settings](https://gitpod.io/variables):

  - `AWS_SSO_URL`
  - `AWS_SSO_REGION`
  - `AWS_ACCOUNT_ID`
  - `AWS_ROLE_NAME`
  - `AWS_REGION`

  <br>

  > **Note**: You Can set scope at for all worskapces (⚠️) or at your Org. Level, at your Personal username level, or at Just Repo. Level. _Read More: [Configure Environment Variables](https://www.gitpod.io/docs/environment-variables#using-the-account-settings)_

- Maybe you use vault or some other secret storage, that's okay. The key is to inject them into the config when the workspace starts.

🚀 Now, You are ready to use AWS CLI, & With that, you can log in to your SSO or Use AWS ECR to use Private Registries/ Images. 


## Recommended Reading

### Gitpod

- [One workspace per task](https://www.gitpod.io/docs/workspaces)
- [Environment variables](https://www.gitpod.io/docs/environment-variables#using-the-account-settings)
- [Custom Docker Image](https://www.gitpod.io/docs/config-docker)
- [Config `.gitpod.yml`](https://www.gitpod.io/docs/config-gitpod-file)

### AWS

- [Automatically gets credentials for Amazon ECR on docker push/docker pull](https://github.com/awslabs/amazon-ecr-credential-helper)
- [AWS CLI Command Reference // login](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sso/login.html)
- [Using Amazon ECR with the AWS CLI](https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html)
- [AWS Systems Manager Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html)

### Docker

- [Docker command line configuration files](https://docs.docker.com/engine/reference/commandline/cli/#configuration-files)
