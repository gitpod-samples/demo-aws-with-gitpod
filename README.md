# Gitpod with AWS

If your software project is comprised of multiple source control repositories it is possible to configure Gitpod to clone these additional repositories through the configuration keys of `additionalRepositories` and `mainConfiguration` in the [.gitpod.yml](https://www.gitpod.io/docs/references/gitpod-yml) file which removes the need to run multiple workspaces, and makes it easier to configure services which need to be aware of each other.

Learn more about cloning additional repositories and delegation at https://www.gitpod.io/docs/multi-repo-workspaces

## Demo

This repository uses `mainConfiguration` to delegate the configuration of Gitpod to https://github.com/gitpod-io/demo-multi-repo-frontend and makes it possible to open the same workspace from any issue, branch or other context URL.

<a href="https://gitpod.io/#https://github.com/gitpod-io/demo-gitpod-with-aws"><img src="https://gitpod-staging.com/button/open-in-gitpod.svg"/></a>

```bash
$ cd /workspaces
$ ls -ltr
drwxr-xr-x 3 gitpod gitpod 69 Jun 22 02:37 demo-multi-repo-frontend
drwxr-xr-x 3 gitpod gitpod 69 Jun 22 02:37 backend
```
