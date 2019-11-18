all: cluster ingress

cloudauth:
	echo "token = \"`gcloud auth application-default print-access-token`\"" > terraform.tfvars
	cat cloudflare.tfvars >> terraform.tfvars

cluster: cloudauth
	terraform apply --auto-approve
	
kubeauth:
	gcloud container clusters get-credentials primary --region=us-central1

ingress: kubeauth
	sed "s/IP_ADDRESS/$(shell cat gke/ipaddress.txt)/g" ingress/nginx/service.yaml.tpl > ingress/nginx/service.yaml
	kubectl apply -f ingress/nginx
	echo "Ingress configured at: $(shell cat gke/ipaddress.txt)"

test:
	curl -H 'Host: myservice.telliott.io' http://$(shell cat gke/ipaddress.txt)/info

destroy:
	terraform destroy --auto-approve