# Verification of Argo CD Artifacts

## Prerequisites
- cosign [installation instructions](https://docs.sigstore.dev/cosign/installation)
- slsa-verifier [installation instructions](https://github.com/slsa-framework/slsa-verifier#installation)
***
## Verification of container images

Argo CD container images are signed by [cosign](https://github.com/sigstore/cosign) using keyless signatures. A [SLSA](https://slsa.dev/) Level 3 provenance is also generated using [slsa-github-generator](https://github.com/slsa-framework/slsa-github-generator). Executing the following command can be used to verify the signature of a container image.

```bash
COSIGN_EXPERIMENTAL=1  cosign verify quay.io/argoproj/argocd:<VERSION> | jq
```
The command should output the following if the container image was correctly verified:
```bash
The following checks were performed on each of these signatures:
  - The cosign claims were validated
  - Existence of the claims in the transparency log was verified offline
  - Any certificates were verified against the Fulcio roots.
[
  {
    "critical": {
      "identity": {
        "docker-reference": "quay.io/argoproj/argo-cd"
      },
      "image": {
        "docker-manifest-digest": "sha256:63dc60481b1b2abf271e1f2b866be8a92962b0e53aaa728902caa8ac8d235277"
      },
      "type": "cosign container image signature"
    },
    "optional": {
      "1.3.6.1.4.1.57264.1.1": "https://token.actions.githubusercontent.com",
      "1.3.6.1.4.1.57264.1.2": "push",
      "1.3.6.1.4.1.57264.1.3": "a6ec84da0eaa519cbd91a8f016cf4050c03323b2",
      "1.3.6.1.4.1.57264.1.4": "Publish ArgoCD Release",
      "1.3.6.1.4.1.57264.1.5": "argoproj/argo-cd",
      "1.3.6.1.4.1.57264.1.6": "refs/tags/<version>",
      ...
```
***
## Verification of container image attestations

The output of the following command will verify the attestation and will contain the payloadType, payload, and signature:
```bash
COSIGN_EXPERIMENTAL=1  cosign verify-attestation --type slsaprovenance quay.io/argoproj/argo-cd:<version> | jq
```
The payload is a non-falsifiable provenance which is base64 encoded and can be viewed by using the command below. We encourage all users to verify the provenance with your admission controller of choice. Doing so will verify that the image was built by Argo CD from a verified maintainer.
```bash
COSIGN_EXPERIMENTAL=1  cosign verify-attestation --type slsaprovenance quay.io/argoproj/argocd:<version> | jq -r .payload | base64 -d | jq
```
***

## Release Assets
| Asset                                   | Description                   |
|-----------------------------------------|-------------------------------|
| argocd_v<version\>_cli.intoto.jsonl     | Attestation of CLI binaries   |
| argocd_v<version\>_darwin_amd64.tar.gz  | CLI Binary                    |
| argocd_v<version\>_darwin_arm64.tar.gz  | CLI Binary                    |
| argocd_v<version\>_linux_amd64.tar.gz   | CLI Binary                    |
| argocd_v<version\>_linux_arm64.tar.gz   | CLI Binary                    |
| argocd_v<version\>_linux_ppc64le.tar.gz | CLI Binary                    |
| argocd_v<version\>_linux_s390x.tar.gz   | CLI Binary                    |
| argocd_v<version\>_windows_amd64.zip    | CLI Binary                    |
| cli_checksums.txt                       | Checksums of binaries         |
| sbom.tar.gz                             | Sbom                          |
| sbom.tar.gz.pem                         | Certificate used to sign sbom |
| sbom.tar.gz.sig                         | Sbom signature                |

***

## Verification of CLI artifacts

A single attestation (`argocd_v<version>_cli.intoto.jsonl`) can be used with [slsa-verifier](https://github.com/slsa-framework/slsa-verifier#verification-for-github-builders) to verify that a CLI binary was generated using Argo CD workflows on GitHub and ensures the provenance was cryptographically signed.
```bash
slsa-verifier verify-artifact argocd_v<version>_linux_amd64.tar.gz --provenance-path argocd_v<version>_cli.intoto.jsonl  --source-uri github.com/argoproj/argo-cd
```
## Verifying an artifact and output the provenance

```bash
slsa-verifier verify-artifact argocd_v<version>_linux_amd64.tar.gz --provenance-path argocd_v<version>_cli.intoto.jsonl  --source-uri github.com/argoproj/argo-cd --print-provenance | jq
```
## Verification of Sbom

```bash
COSIGN_EXPERIMENTAL=1 cosign verify-blob --signature sbom.tar.gz.sig --certificate sbom.tar.gz.pem  sbom.tar.gz

Verified OK
```


## Verification on Kubernetes

### Policy controllers

Cosign and SLSA provenances are compatible with several types of admission controllers.  Please see the [cosign documentation](https://docs.sigstore.dev/cosign/overview/#kubernetes-integrations) and [slsa-github-generator](https://github.com/slsa-framework/slsa-github-generator/blob/main/internal/builders/container/README.md#verification) for supported controllers.
