prepare:
	./create_subnet_json.sh

eks:
	jsonnet -S ./cluster-spec.jsonnet | eksctl create cluster -f -
	aws eks --region ap-northeast-1 update-kubeconfig --name practice-eks

up: prepare eks

down:
	jsonnet -S ./cluster-spec.jsonnet | eksctl delete cluster -f -
