# Workflows

| Workflow          | Description                                                |
|-------------------|------------------------------------------------------------|
| image-reuse.yaml  | Build, push, and Sign container images                     |
| image.yaml        | Build for PR's & Build & push for push events              |
| init-release.yaml | Build manifests and Version then create a PR               |
| release.yaml      | Build images, cli-binaries, provenances, and post actions  |

## image-reuse.yaml

* The reuable workflow can be used to publish or build images with multiple container registries(Quay,GHCR,dockerhub), and then signed with cosign when a image is pushed.
* A GO version `must` be specified e.g. 1.19
* The image namespace for each registry *must* contain the tag. Note: multiple tags are allowed for each registry.
* Multiple platforms can be specified e.g. linux/amd64,linux/arm64
* Images are not published by default. A boolean value must be set to `true` to push images.
* An optional target can be specified.


| Inputs            | Description                         | Value       | Required | Defaults        |
|-------------------|-------------------------------------|-------------|----------|-----------------|
| go-version        | Version of Go to be used            | string      | true     | none            |
| quay_image_name   | Full image name and tag             | CSV, string | false    | none            |
| ghcr_image_name   | Full image name and tag             | CSV, string | false    | none            |
| docker_image_name | Full image name and tag             | CSV, string | false    | none            |
| platforms         | Platforms to build (linux/amd64)    | CSV, string | false    | linux/amd64     |
| push              | Whether to push image/s to registry | boolean     | false    | false           |
| target            | Target build stage                  | string      | false    | none            |

| Outputs     | Description                              | Type  |
|-------------|------------------------------------------|-------|
|image-digest | Image disgest of image container created | string|






