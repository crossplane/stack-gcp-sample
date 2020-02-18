IMG ?= "crossplane/stack-minimal-gcp"
VERSION ?= "0.2.0"

build:
	docker build . -t ${IMG}:${VERSION}