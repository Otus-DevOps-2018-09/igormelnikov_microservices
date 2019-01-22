ifndef USER_NAME
$(error USER_NAME is not set)
endif

IMAGE_PATHS=../src/ui ../src/post-py ../src/comment ../monitoring/prometheus ../monitoring/mongodb-exporter
BUILDS = $(addsuffix /build_info.txt, $(IMAGE_PATHS))

default: all

all: clean build

build: $(BUILDS)

%/build_info.txt: %/*
	cd $* && bash docker_build.sh

clean: 
	rm $(BUILDS)

.PHONY: clean push_ui push_post push_comment push_prometheus push_mongodb-exporter push_all

push_ui: ../src/ui/build_info.txt
	docker push $(USER_NAME)/ui

push_post: ../src/post-py/build_info.txt
	docker push $(USER_NAME)/post

push_comment: ../src/comment/build_info.txt
	docker push $(USER_NAME)/comment

push_prometheus: ../monitoring/prometheus/build_info.txt
	docker push $(USER_NAME)/prometheus

push_mongodb-exporter: ../monitoring/mongodb-exporter/build_info.txt
	docker push $(USER_NAME)/mongodb-exporter

push_all: push_post push_comment push_prometheus push_ui push_mongodb-exporter
