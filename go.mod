module github.com/crossplaneio/minimal-gcp

go 1.13

replace github.com/crossplaneio/crossplane-runtime => github.com/muvaf/crossplane-runtime v0.0.0-20191211130614-3cf4bd127550

require (
	github.com/crossplaneio/crossplane-runtime v0.2.3
	github.com/go-logr/logr v0.1.0
	github.com/muvaf/crossplane-resourcepacks v0.0.0-20191212125918-fed1b5cab606
	github.com/onsi/ginkgo v1.10.1
	github.com/onsi/gomega v1.7.0
	k8s.io/apimachinery v0.0.0-20191203211716-adc6f4cd9e7d
	k8s.io/client-go v0.0.0-20190918160344-1fbdaa4c8d90
	sigs.k8s.io/controller-runtime v0.4.0
)
