# Containerized Cloud and Software Development Environment

## Features
* Google Cloud SDK (i.e. gcloud).
* AWS CLI
* Kubernetes (i.e. kubectl).
* Terraform (i.e. setting up a GKE cluster, GCP Cloud Storage, or a Google Container Registry).
* Helm (i.e. deploying Nginx chart to GKE).
* C++ (g++, Clang, Google Test, Microsoft C++ Rest SDK, Boost).
* Go (Golang)
* Rust + Cargo
* Python + PIP
* Node + npm

## Getting Started
* Install Docker via [Docker.com](https://docs.docker.com/install/) or use [build.sh](https://github.com/chrmi/dev/blob/master/install.sh).
* Configure [vimrc](https://github.com/chrmi/dev/blob/master/vimrc), [tmux.conf](https://github.com/chrmi/dev/blob/master/tmux.conf), [bashrc.sh](https://github.com/chrmi/dev/blob/master/bashrc.sh) to taste.
* Create service account in GCP.
  * Generate JSON credentials.  Place in auth/gcp.json
  * Add account details in gcp.env
  * Customize [Dockerfile](https://github.com/chrmi/dev/blob/master/Dockerfile) as needed.
  * Customize startup within the container with [init.sh](https://github.com/chrmi/dev/blob/master/init.sh).
     * Note that if you haven't created a cluster yet, this will show a hardmless error the first time.  Making changes to this requires re-building the container, which is no big deal.
  * Finally, use [dock.sh](https://github.com/chrmi/dev/blob/master/dock.sh) to work with the container.
    * First time sequence: build, shell.  If changing init.sh, you can update and shell; but if there are issues, build for a clean slate.
  * Files in are mounted as a volume and persisted, even with a clean build of the container.

## Example Workflow
  * Shell into the running container.
  * Within src, clone a C++ repo, compile.
  * Modify Terraform in src, tfinit(), tfplan(), tfapply() -- these can be customized and added to in [bashrc.sh](https://github.com/chrmi/dev/blob/master/bashrc.sh).
  * Helm deploy from the charts loaded in the repos listed in [Dockerfile](https://github.com/chrmi/dev/blob/master/Dockerfile) **You can temporarily add another repo while in shell, but to be available in subsequent shell sessions, add the repos to the Dockerfile.**

## Environment Variables
Added to .gitignore, and intended (along with volume mounts) to house all private data.  While this is not intended to run outside of a local machine, no private should live in the container itself.

All else in misc.env (as example):
```
GOPATH=/home/me/src/go
APIPORT=8998
LOGGER_STDOUT=true
LOGGER_BIGTABLE=true
LOGGER_CLOUD_STORAGE=true
```

Required for GCP in gcp.env (in .gitignore):
```
GCP_REGION=us-central1-a
GCP_ACCOUNT=email@project.iam.gserviceaccount.com
GCP_PROJECT=project-name
GCP_CLUSTER=cluster-name
```

