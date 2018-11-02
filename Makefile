# =============================================================================
# CONFIGURATION
# =============================================================================
APP=dwh-importer-zendesk
PROJECT-TYPE=python
CONTAINER_VOLUMES= \
	-v $(PWD)/volumes/key.json:/opt/secrets/service-account/key.json \
	-v $(PWD)/volumes/appinfo.json:/opt/config/appinfo.json \
	-v $(PWD)/test/unittest:/opt/container/unittest
CONTAINER_ENVS=-e GOOGLE_CLOUD_PROJECT=spil-bi-stg \
	-e GOOGLE_CLOUD_DISABLE_GRPC=true \
	-e GOOGLE_APPLICATION_CREDENTIALS=/opt/secrets/service-account/key.json \
	-e IMPORTER_GCS_PROJECT_NAME=spil-bi-stg \
	-e IMPORTER_GCS_BUCKET_NAME=spil-gc-etls-stg \
	-e IMPORTER_BQ_DATASET_NAME=raw__historized__staging \
	-e LOG_TO_CONSOLE=true \
	-e HOST=devbox

BUILD_CREDENTIALS=true
USE_JENKINS_UP=false

# =============================================================================
# COMMON TARGETS BELOW
# =============================================================================

.ME-test=off
.ME-k8s-up=normal
.ME-unittest=off

# =============================================================================
# DON'T UPDATE SECTION BELOW
# =============================================================================

# Include common makefile
-include microservices-ext/make/Makefile-common.mk

# Or get it, if it's not there
GITURL:=$(shell git remote -v | awk '{print $$2}' | head -1 | sed -E 's/(.*)\/[^\/].*$$/\1/')
$(.ME-ext)microservices-ext:
	git clone -q https://github.com/spilgames/microservices-ext
	-@test "`grep microservices-ext .gitignore`" || echo "microservices-ext/" >> .gitignore
	@make $(MAKECMDGOALS)

# =============================================================================
# PROJECT SPECIFIC TARGETS
# =============================================================================

secrets/mount:
	./microservices-ext/scripts/volumes.py ${PWD} mount

secrets/create:
	./microservices-ext/scripts/volumes.py ${PWD} printcreate

#setup:: origsetup secrets/mount

test:: unittest pep8

unittest:
	docker run -t -v $(PWD)/container:/opt/container -v $(PWD)/test/unittest:/opt/container/unittest --entrypoint=/opt/container/unittest/run.sh $(APP):latest
