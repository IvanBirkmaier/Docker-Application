.PHONY: help
help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_0-9]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

.PHONY: start_k3d
start_k3d: ## baut das k3d Cluster.
	mkdir -p "${PWD}"/k3d/k3dvol
	k3d cluster create mycluster -v "${PWD}"/k3d/registries.yaml:/etc/rancher/k3s/registries.yaml -v "${PWD}"/k3d/k3dvol:/tmp/k3dvol

.PHONY: delete_k3d
delete_k3d: ## delete das k3d Cluster.
	k3d cluster delete mycluster
	rm -rf "${PWD}"/k3d/k3dvol

.PHONY: start_docker_registry
start_docker_registry: ## startet eine Docker Registry, welche im k3d Netzwerk sichtbar ist.
	docker container run -d --network k3d-mycluster --name registry --restart always -p 5000:5000 registry:2

.PHONY: start
start: tag_push_docker_images ## startet die Anwendung.
	kubectl apply -f k8s/persistent-volume.yaml -n default
	kubectl apply -f k8s/secret-alpha-vantage-free-key.yaml -n default
	kubectl apply -f k8s/secret-minio.yaml -n default
	kubectl apply -f k8s/deployment-minio.yaml -n default
	kubectl apply -f k8s/service-minio.yaml -n default
	kubectl apply -f k8s/pod-createbucketsminio.yaml -n default
	kubectl apply -f k8s/pod-getdata.yaml -n default
	kubectl apply -f k8s/deployment-forecast.yaml -n default
	kubectl apply -f k8s/service-webserver.yaml -n default
	kubectl apply -f k8s/service-restcontroller.yaml -n default
	kubectl apply -f k8s/deployment-webserver.yaml -n default
	kubectl apply -f k8s/deployment-restcontroller.yaml -n default


.PHONY: stop
stop: delete_bucket ## stoppt die Anwendung.
	kubectl delete -f k8s/secret-alpha-vantage-free-key.yaml -n default
	kubectl delete -f k8s/secret-minio.yaml -n default
	kubectl delete -f k8s/deployment-minio.yaml -n default
	kubectl delete -f k8s/service-minio.yaml -n default
	kubectl delete -f k8s/pod-createbucketsminio.yaml -n default
	kubectl delete -f k8s/pod-getdata.yaml -n default
	kubectl delete -f k8s/deployment-forecast.yaml -n default
	kubectl delete -f k8s/service-webserver.yaml -n default
	kubectl delete -f k8s/service-restcontroller.yaml -n default
	kubectl delete -f k8s/deployment-webserver.yaml -n default
	kubectl delete -f k8s/deployment-restcontroller.yaml -n default


.PHONY: delete_bucket
delete_bucket: ## löscht den Inhalt der Buckets.
	rm -rf k3d/k3dvol/csv
	rm -rf k3d/k3dvol/forecast
	rm -rf k3d/k3dvol/rohdata

.PHONY: tag_push_docker_images
tag_push_docker_images: ## uploaded die Docker-Images zur Registry.
	docker tag getdata:latest localhost:5000/getdata:latest
	docker tag forecast:latest localhost:5000/forecast:latest
	docker tag webserver:latest localhost:5000/webserver:latest
	docker tag restcontroller:latest localhost:5000/restcontroller:latest
	docker push localhost:5000/getdata:latest
	docker push localhost:5000/forecast:latest
	docker push localhost:5000/webserver:latest
	docker push localhost:5000/restcontroller:latest

