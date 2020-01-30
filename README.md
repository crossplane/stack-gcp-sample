# Minimal GCP Template Stack

You can use this stack to spin up a private network as well as
resource classes that will let you provision resources in that
network.

# Usage Instructions

Below you can see what fields are supported and
how you can use them.

```yaml
apiVersion: gcp.resourcepacks.crossplane.io/v1alpha1
kind: MinimalGCP
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

Note that, as of now, the resource classes you create via the
`MinimalGCP` instance above will deploy all of its resource
classes as default.

## Build

Run `make`
