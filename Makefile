IMG ?= "crossplane/stack-minimal-gcp"
VERSION ?= "0.2.1"

build:
	docker build . -t ${IMG}:${VERSION}