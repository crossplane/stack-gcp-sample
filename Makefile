IMG ?= "crossplane/stack-minimal-gcp"
VERSION ?= "0.1.0"

build:
	docker build . -t ${IMG}:${VERSION}