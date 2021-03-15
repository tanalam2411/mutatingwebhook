docker-build:
	docker build . --rm -t on2411/mutatingwebhook-example

docker-push:
	docker push on2411/mutatingwebhook-example