TYPE=alpine

foo:
	@echo "bar"

install:
	@echo "Installing tools for $$OSTYPE"
	@if [[ $$OSTYPE == "linux"* ]]; then \
		echo "Ubuntu"; \
		sudo apt-get update; \
		sudo apt-get upgrade; \
		sudo apt-get install sox ffmpeg rtptools tclsh pkg-config cmake libssl-dev build-essential; \
		cd srt; \
		./configure; \
		make; \
	elif [[ $$OSTYPE == "darwin"* ]]; then \
		echo "MacOS"; \
		brew update; \/us	
		brew install srt ffmpeg rtptools sox; \
	else \
		echo "Platform not implemented"; \
	fi;


docker-build:
	docker build \
	-f Dockerfile.$(TYPE) . -t axia_streamer

docker-push:
	docker buildx build -f Dockerfile.$(TYPE) . -t docker.io/kmahelona/axia-to-icecast:$(TYPE) --platform linux/amd64,linux/arm64 --push

docker-interact:
	docker run \
	--network="host" \
	--cap-add=NET_ADMIN \
	--cap-add=NET_RAW \
	-it \
	--env AXIA_PORT \
	--env ICE_USER \
	--env ICE_PASS \
	--env ICE_MNT \
	--env ICE_URL \
	--env ICE_PORT \
	axia_streamer \
	bash

docker-run:
	docker run \
	--env AXIA_PORT \
	--env ICE_USER \
	--env ICE_PASS \
	--env ICE_MNT \
	--env ICE_URL \
	--env ICE_PORT \
	axia_streamer
