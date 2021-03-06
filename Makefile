include crd.Makefile

REGISTRY := gcr.io/opsmx-images
APP_NAME := oes
DEPLOYER_IMAGE_REPO := $(REGISTRY)/$(APP_NAME)/deployer
INSTALLER_IMAGE_REPO := $(REGISTRY)/$(APP_NAME)/installer
DEPLOYER_IMAGE_VERSION := 1.0

.PHONY: docker-push
docker-push: docker-push-deployer

.PHONY: docker-push-deployer
docker-push-deployer:
	REGISTRY=$(REGISTRY) APP_NAME=$(APP_NAME) docker build -t $(DEPLOYER_IMAGE_REPO):$(DEPLOYER_IMAGE_VERSION) -f Dockerfile . --no-cache
	docker push $(DEPLOYER_IMAGE_REPO):$(DEPLOYER_IMAGE_VERSION)


.PHONY: mpdev-doctor
mpdev-doctor:
	REGISTRY=$(REGISTRY) mpdev doctor

TEST_NS:=test-oes-ns
.PHONY: test-install
test-install:
	kubectl create namespace $(TEST_NS)
	kubectl apply -f "https://raw.githubusercontent.com/GoogleCloudPlatform/marketplace-k8s-app-tools/master/crd/app-crd.yaml"
	mpdev /scripts/install \
  --deployer=$(REGISTRY)/$(APP_NAME)/deployer:$(DEPLOYER_IMAGE_VERSION) \
  --parameters='{"name": "test-install", "namespace": "$(TEST_NS)"}'


.PHONY: cleanup-cluster.
cleanup-cluster:
	kubectl delete namespace $(TEST_NS)

.PHONY: mpdev-verify
mpdev-verify:
		mpdev /scripts/verify   --deployer=gcr.io/opsmx-images/oes/deployer:$(DEPLOYER_IMAGE_VERSION)
