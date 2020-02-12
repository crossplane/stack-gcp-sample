IMG ?= "crossplane/stack-minimal-gcp"
VERSION ?= "0.0.2"

build:
	docker build . -t ${IMG}:${VERSION}