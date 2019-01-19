ifndef USER_NAME
$(error USER_NAME is not set)
endif

IMAGE_PATHS=../src/ui ../src/post-py ../src/comment ../monitoring/prometheus
BUILDS = $(addsuffix /build_info.txt, $(IMAGE_PATHS))

default: all

all: clean build

build: $(BUILDS)

%/build_info.txt: %/*
	cd $* && bash docker_build.sh

clean: 
	rm $(BUILDS)

.PHONY: clean push_ui push_post push_comment push_prometheus

push_ui: ../src/ui/build_info.txt
	docker push $(USER_NAME)/ui

push_post: ../src/post-py/build_info.txt
	docker push $(USER_NAME)/post

push_comment: ../src/comment/build_info.txt
	docker push $(USER_NAME)/comment

push_prometheus: ../src/prometheus/build_info.txt
	docker push $(USER_NAME)/prometheus
