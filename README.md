# Tutor CI Docker Images

This repository contains GitHub Actions workflow for building and pushing Docker images with Tutor (Open edX platform) pre-installed.

## Docker Hub Repository

Images are published to: `abstract2tech/tutor-ci`

## Available Versions

You can build any Tutor version by specifying it when triggering the workflow. Common versions include:
Tested version:

- "14.2.3"
- "14.2.4"
- "14.2.5"
- "15.3.3"
- "15.3.4"
- "15.3.5"
- "15.3.6"
- "15.3.7"
- "15.3.8"
- "15.3.9"
- "16.0.0"
- "16.0.1"
- "16.0.2"
- "16.0.3"
- "16.0.4"
- "16.0.5"
- "16.1.0"
- "16.1.1"
- "16.1.2"
- "16.1.3"
- "16.1.4"
- "16.1.5"
- "16.1.7"
- "16.1.8"
- "17.0.0"
- "17.0.1"
- "17.0.2"
- "17.0.3"
- "17.0.4"
- "17.0.5"
- "17.0.6"
- "18.0.0"
- "18.1.0"
- "18.1.1"
- "18.1.2"
- "18.1.3"
- "18.1.4"
- "18.2.0"
- "18.2.1"
- "18.2.2"
- "19.0.0"
- "19.0.1"
Not tested:
- "20.0.0"

## How to Use

## Replacing Bitnami images / binaries

The Dockerfile previously used commented Bitnami multi-stage COPYs for two helper tools:

- kubectl (bitnami/kubectl:1.28.6)
- mc — MinIO client (bitnami/minio-client:2024.5.9)

Rather than copying these from Bitnami images, the build now downloads the official upstream
binaries for each tool and installs them into `/usr/local/bin`:

- kubectl — downloaded from the official Kubernetes release binary (pinned to `1.28.6` in the Dockerfile)
- mc — downloaded from MinIO's release binary

Why this change?

- Avoid reliance on third-party vendor images for small helper binaries.
- Pinning a known release binary reduces surprise changes caused by upstream image base changes.
- Reduces the number of build stages/sizes when those images aren't otherwise needed.

If you'd rather copy from alternate images (for example an official docker image that already contains the binaries):

1. Identify a replacement image and the correct path to the binary inside it (e.g. `/usr/bin/mc` or `/kubectl`).
2. Replace the relevant `curl`-download lines in the `Dockerfile` with an equivalent `COPY --from=<image>:<tag> <path-to-binary> /usr/local/bin/<bin>`.

Note: pin versions explicitly when using downloads or image tags to keep builds reproducible.

## Prerequisites

For maintainers who want to trigger builds:

- GitHub account with access to this repository
- Docker Hub secret `DOCKER_REGISTRY_PASSWORD` must be configured in repository settings

### Building a New Image

1. Go to the [Actions tab](../../actions) in this repository
2. Click on "Build and Push docker & tutor installed images" workflow
3. Click "Run workflow" button
4. Enter the desired Tutor version (e.g., `20.0.0`)
5. Click "Run workflow"

The workflow will:

- Build a Docker image with the specified Tutor version
- Push it to Docker Hub as `abstract2tech/tutor-ci:<version>`
