
deploy:
	sh deploy.sh

local-build:
	docker build -t cloudnative-handson .

local-run:
	docker run -it -p 8080:8080 cloudnative-handson
