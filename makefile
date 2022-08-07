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
		brew update; \
		brew install srt ffmpeg rtptools sox; \
	else \
		echo "Platform not implemented"; \
	fi;


docker-build:
	docker build -f Dockerfile.base .
