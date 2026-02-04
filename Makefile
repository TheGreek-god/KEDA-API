all: help

help:
	@echo ----------------------------------
	@echo MY IDENTITY API DEPLOYMENT COMMANDS
	@echo ----------------------------------
	@echo make image 	- build and upload docker image to minikube environment
	@echo make apply 	- deploy myidentity-api and expose service
	@echo make test 	- test deployment
	@echo make delete	- uninstall myidentity-api deployment and service

delete:
	kubectl delete service myidentity-service
	kubectl delete deployment myidentity-api

image:
	eval $(minikube docker-env)
	docker image prune -f
	docker build -t brandiqa/myidentity-api .

apply:
	kubectl apply -f deploy/myidentity-deployment.yml
	kubectl get services | grep myidentity

test:
	curl 10.98.55.109:4000/my-identity

local-run:
	ENDPOINT=http://localhost:4000/my-indentity k6 run performance-test.js

local-influx-run:
	ENDPOINT=http://localhost:4000/my-identity k6 run -o influxdb=http://localhost:8086/k6 performance-test.js

run:
	ENDPOINT=http://10.98.55.109:4000/my-identity k6 run -o influxdb=http://localhost:8086/k6 performance-test.js
