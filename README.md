# gitlab-minikube

This is a simple `Makefile` and `Helm` values file that deploys [Gitlab Official Helm Repo](https://gitlab.com/gitlab-org/charts/gitlab) on `Minikube`

### Assumptions
- Following packages should already be installed on your system below running this and this readme does not include instructions on how to install them (as steps will vary as per os)
  - make
  - docker
  - kubectl
  - minikube
  - helm3
- For stateful services like Postgresql, Redis, Object Storage I'm pods deployed using their respective helm carts (check [requirements.yaml](https://gitlab.com/gitlab-org/charts/gitlab/-/blob/master/requirements.yaml))
- As it's a local minikube setup I have kept the number of replicas to a minimum
- Have also disabled certain features like cert manager, gitlab-runner, grafana
- Intentionally left prometheus as useful metrics can be extracted from `/metrics` endpoint

### Instructions
- Install helm plugin(s), add repo and install/upgrade helm repo
  ```
  make
  ```
  The default timeout is 10 minutes. Even after the timeout make sure all pods are in running state before try to access the endpoint
  
- Retrieve Gitlab endpoint and initial password for root user
  ```
  make get_login_info
  ```
