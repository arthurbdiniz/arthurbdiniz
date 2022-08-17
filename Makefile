build:
	docker build -t site .
.PHONY: build

shell:
	docker run -it --entrypoint /bin/bash -v $(PWD):/site site
.PHONY: shell

run:
	docker run -it \
		-p 4000:4000 \
		-v $(PWD):/site site
.PHONY: run

stop:
	docker-compose stop
.PHONY: stop