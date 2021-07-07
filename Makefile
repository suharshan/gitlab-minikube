# Retrieve minikube IP incase if it's not the default
MINIKUBE_IP = ${shell minikube ip}
RELEASE_NAME = gitlab

all: plugins install

plugins:
	@echo "Installing helm plugins..."
	minikube addons enable ingress

install:
	@echo "Installing Gitlab Helm Chart..."
	helm repo add gitlab https://charts.gitlab.io/
	helm repo update
	helm upgrade --install ${RELEASE_NAME} gitlab/gitlab --wait --timeout 600s --set global.hosts.domain=${MINIKUBE_IP}.nip.io --set global.hosts.externalIP=${MINIKUBE_IP} -f ./values-minikube.yaml

get_login_info:
	@echo -n "Gitlab URL is: "
	@kubectl get ingress ${RELEASE_NAME}-webservice-default  -o jsonpath='{.spec.rules[*].host}'
	@echo ""
	@echo -n "Password for root user is: "
	@kubectl get secret ${RELEASE_NAME}-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo

destroy:
	@echo "Destroying your Gitlab..."
	@helm uninstall gitlab
	# Delete PVs and PVCs to avoid any postgresql complications when re-creating the stack
	@kubectl delete pvc,pv --all
