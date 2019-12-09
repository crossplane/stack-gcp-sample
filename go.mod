module github.com/crossplaneio/minimal-gcp

go 1.13

replace github.com/crossplaneio/crossplane-runtime => github.com/muvaf/crossplane-runtime v0.0.0-20191206111112-1fe048748dc5

require (
	github.com/crossplaneio/crossplane-runtime v0.2.3
	github.com/go-logr/logr v0.1.0
	github.com/muvaf/configuration-stacks v0.0.0-20191209200648-b3c0ada5c684
	github.com/onsi/ginkgo v1.10.1
	github.com/onsi/gomega v1.7.0
	k8s.io/apimachinery v0.0.0-20191203211716-adc6f4cd9e7d
	k8s.io/client-go v0.0.0-20190918160344-1fbdaa4c8d90
	sigs.k8s.io/controller-runtime v0.4.0
	sigs.k8s.io/kustomize/api v0.2.0
)
