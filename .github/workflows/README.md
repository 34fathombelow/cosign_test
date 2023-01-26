# Workflows

| Workflow          | Description                                                |
|-------------------|------------------------------------------------------------|
| image-reuse.yaml  | Build, push, and Sign container images                     |
| image.yaml        | Build for PR's & Build & push for push events              |
| init-release.yaml | Build manifests and Version then create a PR               |
| release.yaml      | Build images, cli-binaries, provenances, and post actions  |

## image-reuse.yaml

1. The reuable workflow can be used to publish or build images with multiple container registries(Quay,GHCR,dockerhub), and then signed with cosign when a image is pushed.
2. A GO version `must` be specified e.g. 1.19
3. The image names for each registry *must* contain the tag.
4. Multiple platforms can be specified e.g. linux/amd64,linux/arm64
5. Images are not published by default. A boolean value must be set to `true` to push images.
6. An optional target can be specified.


| Inputs            | Description                         | Value       | Required | Defaults        |
|-------------------|-------------------------------------|-------------|----------|-----------------|
| go-version        | Version of Go to be used            | string      | true     | none            |
| quay_image_name   | Full image name and tag             | string      | false    | none            |
| ghcr_image_name   | Full image name and tag             | string      | false    | none            |
| docker_image_name | Full image name and tag             | string      | false    | none            |
| platforms         | Platforms to build (linux/amd64)    | CSV, string | false    | linux/amd64     |
| push              | Whether to push image/s to registry | boolean     | false    | false           |
| target            | Target build stage                  | string      | false    | none            |

| Outputs     | Description                              | Type  |
|-------------|------------------------------------------|-------|
|image-digest | Image disgest of image container created | string|






