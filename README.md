# Verification of Argo CD Artifacts

## Release Assets
- argocd_v<version>_cli.intoto.jsonl
- argocd_v<version>_darwin_arm64.tar.gz
- argocd_v<version>_darwin_amd64.tar.gz
- argocd_v<version>_linux_amd64.tar.gz
- argocd_v<version>_linux_arm64.tar.gz
- argocd_v<version>_linux_ppc64le.tar.gz
- argocd_v<version>_linux_s390x.tar.gz
- argocd_v<version>_linux_windows_amd64.zip
- cli_checksums.txt
- sbom.tar.gz
- sbom.tar.gz.pem
- sbom.tar.gz.sig

All Argo CD container images are signed by cosign. 

## Prerequisites
- Cosign [installation instructions](https://docs.sigstore.dev/cosign/installation)
- Obtain or have a copy of ```argocd-cosign.pub```, which can be located in the assets section of the [release page](https://github.com/argoproj/argo-cd/releases)

Once you have installed cosign, you can use ```argocd-cosign.pub``` to verify the signed assets or container images.


## Verification of container images

```bash
cosign verify --key argocd-cosign.pub  quay.io/argoproj/argocd:<VERSION>

Verification for quay.io/argoproj/argocd:<VERSION> --
The following checks were performed on each of these signatures:
  * The cosign claims were validated
  * The signatures were verified against the specified public key
...
```
## Verification of signed assets

```bash
cosign verify-blob --key cosign.pub --signature $(cat argocd-<VERSION>-checksums.sig) argocd-$VERSION-checksums.txt
Verified OK
```
## Admission controllers

Cosign is compatible with several types of admission controllers.  Please see the [Cosign documentation](https://docs.sigstore.dev/cosign/overview/#kubernetes-integrations) for supported controllers




# View provenance of container image
```bash
COSIGN_EXPERIMENTAL=1  cosign verify-attestation --type slsaprovenance quay.io/34fathombelow/argocd:v2.5.0 | jq -r .payload | base64 -d | jq
```
```
cosign download attestation quay.io/34fathombelow/argocd:latest | jq -r '.payload' | base64 -d | jq
```
# Verify an asset
```bash
slsa-verifier verify-artifact argocd_v2.5.0_linux_amd64.tar.gz --provenance-path argocd-v2.5.0-cli.intoto.jsonl --source-uri github.com/34fathombelow/cosign_test
```
# Verifying an asset and outputting the provenance
```bash
slsa-verifier verify-artifact argocd_v2.5.0_linux_amd64.tar.gz --provenance-path argocd-v2.5.0-cli.intoto.jsonl --source-uri github.com/34fathombelow/cosign_test --print-provenance | jq
```