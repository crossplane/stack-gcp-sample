IMG ?= "crossplane/stack-minimal-gcp"
VERSION ?= "0.0.2"

make:
	docker build . -t ${IMG}:${VERSION}