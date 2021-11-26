BASE_CLUSTER_NAME := $(shell cat ../config.json | jq '.base_cluster_name' --raw-output)
CURRENT_INDEX := $(shell cat ../config.json | jq '.current_index' --raw-output)
AWS_ACCOUNT_ID := $(shell cat ../config.json | jq '.aws_account_id' --raw-output)
REGION := $(shell cat ../config.json | jq '.region' --raw-output)
FULL_CLUSTER_NAME=${BASE_CLUSTER_NAME}-${CURRENT_INDEX}
AWS_PROFILE=default

prepare:
	./export_vpc_subnet_json.sh
	./separate_eks_subnets_json.js > eks_subnets.json
	rm vpc_subnets.json

eks:
	jsonnet -S ./cluster-spec.jsonnet | eksctl create cluster -f -
	aws eks --region ${REGION} update-kubeconfig --name ${FULL_CLUSTER_NAME}

config:
	aws eks --region ${REGION} update-kubeconfig --name ${FULL_CLUSTER_NAME}

replace-irsa:
	jsonnet -S ./cluster-spec.jsonnet | eksctl delete iamserviceaccount --approve -f -
	jsonnet -S ./cluster-spec.jsonnet | eksctl create iamserviceaccount --override-existing-serviceaccounts --approve -f -

up: prepare eks

down:
	jsonnet -S ./cluster-spec.jsonnet | eksctl delete cluster -f -

config:
	aws eks --region ${REGION} update-kubeconfig --name ${FULL_CLUSTER_NAME}
