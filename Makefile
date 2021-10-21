build:
	docker build -t site .
.PHONY: build

shell:
	docker run -it --entrypoint /bin/bash -v $(PWD):/site site
.PHONY: shell

run:
	docker-compose up --build
.PHONY: run

stop:
	docker-compose stop
.PHONY: stop