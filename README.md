# Gitpod with AWS

Ever wondered how to integrate AWS Single Sign-On (SSO) and [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/) with Gitpod? Here's how...

## Demo

<a href="https://gitpod.io/#https://github.com/gitpod-io/demo-gitpod-with-aws"><img src="https://gitpod-staging.com/button/open-in-gitpod.svg"/></a>

```bash
$ command + command output that demonstrates pushing/pulling to/from ECR in Gitpod
```

### Secret Management

```bash
sso_start_url = ${AWS_SSO_URL}
sso_region = ${AWS_SSO_REGION}
sso_account_id = ${AWS_ACCOUNT_ID}
sso_role_name = ${AWS_ROLE_NAME}
region = ${AWS_REGION}
```

1. configure your secrests in gitpod here.
2. Maybe you use vault or some other secret storage, that's okay. the key is to inject them into the config when the worksapce starts. heres how.


## Recommended Reading

### Gitpod

- [One workspace per task](https://www.gitpod.io/docs/workspaces)
- [Environment variables](https://www.gitpod.io/docs/environment-variables#using-the-account-settings)
- [Custom Docker Image](https://www.gitpod.io/docs/config-docker)
- [.gitpod.yml](https://www.gitpod.io/docs/config-gitpod-file)

### AWS

- [Automatically gets credentials for Amazon ECR on docker push/docker pull](https://github.com/awslabs/amazon-ecr-credential-helper)
- [AWS CLI Command Reference // login](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sso/login.html)
- [Using Amazon ECR with the AWS CLI](https://docs.aws.amazon.com/AmazonECR/latest/userguide/getting-started-cli.html)
- [AWS Systems Manager Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html)

### Docker

- [Docker command line configuration files](https://docs.docker.com/engine/reference/commandline/cli/#configuration-files)

### Homebrew

- https://formulae.brew.sh/formula/docker-credential-helper-ecr
- https://formulae.brew.sh/formula/awscli
- https://formulae.brew.sh/cask/session-manager-plugin
