IMAGE = ministryofjustice/circleci-stats:1.1

build:
	docker build -t $(IMAGE) .

run:
	docker run \
		-e API_TOKEN=$${API_TOKEN} \
		-e ES_CLUSTER=$${ES_CLUSTER} \
	$(IMAGE)

push:
	docker push $(IMAGE)
