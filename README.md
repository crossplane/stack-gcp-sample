# GCP Sample Stack

You can use this stack to spin up a private network as well as
resource classes that will let you provision resources in that
network.

# Installation

Requirements:
* Crossplane should be installed.
* [GCP Provider](https://github.com/crossplane/provider-gcp) should be installed and its version should be at least 0.7.0

If you have crossplane-cli installed, you can use the following command to install:

```bash
# Do not forget to change <version> with the correct version.
kubectl crossplane stack install --cluster -n crossplane-system 'crossplane/stack-gcp-sample:<version>' gcp-sample
```

If you don't have crossplane-cli installed, you need to create the following YAML to install:

```yaml
apiVersion: stacks.crossplane.io/v1alpha1
kind: ClusterStackInstall
metadata:
  name: "gcp-sample"
  namespace: crossplane-system
spec:
  package: "crossplane/stack-gcp-sample:<version>"
```

# Usage Instructions

You can create the following YAML to trigger creation of

* [`Network`][network]
* [`Subnetwork`][subnetwork]
* [`GlobalAddress`][global-address]
* [`Connection`][connection]
* [`Provider`][provider] that points to credentials secret reference you supply

and the following resource classes with minimal hardware requirements that will let you create instances that are connected to that network.

* [`GKEClusterClass`][gkecluster-class]
* [`CloudSQLInstanceClass`][cloudsqlinstance-class]
* [`CloudMemorystoreInstanceClass`][cloudmemorystoreinstance-class]

```yaml
apiVersion: gcp.stacks.crossplane.io/v1alpha1
kind: GCPSample
metadata:
  name: test
spec:
  region: us-west2
  projectID: crossplane-playground
  credentialsSecretRef:
    name: gcp-account-creds
    namespace: crossplane-system
    key: credentials
```

In Crossplane, the resource classes that are annotated with `resourceclass.crossplane.io/is-default-class: "true"` are used as default if the claim doesn't specify a resource class selector. The resource classes you create via the `GCPSample` instance above will deploy all of its resource classes as default. If you'd like those defaulting annotations to be removed, you need to add the following to `GCPSample` instance above:

```yaml
templatestacks.crossplane.io/remove-defaulting-annotations: true
```

## Build

Run `make`

## Test Locally

### Minikube

Run `make` and then run the following command to copy the image into your minikube node's image registry:

```bash
# Do not forget to specify <version>
docker save "crossplane/stack-gcp-sample:<version>" | (eval "$(minikube docker-env --shell bash)" && docker load)
```

After running this, you can use the [installation](#installation) command and the image loaded into minikube node will be picked up. 

[network]: kustomize/gcp/compute/network.yaml
[subnetwork]: kustomize/gcp/compute/subnetwork.yaml
[global-address]: kustomize/gcp/compute/globaladdress.yaml
[connection]: kustomize/gcp/servicenetworking/connection.yaml
[provider]: kustomize/gcp/provider.yaml
[gkecluster-class]: kustomize/gcp/compute/gkeclusterclass.yaml
[cloudmemorystoreinstance-class]: kustomize/gcp/cache/cloudmemorystoreinstance.yaml
[cloudsqlinstance-class]: kustomize/gcp/database/cloudsqlinstanceclass.yaml
