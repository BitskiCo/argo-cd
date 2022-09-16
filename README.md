# Argo CD

[![Docker Repository on Quay](https://quay.io/repository/bitski/argocd/status "Docker Repository on Quay")](https://quay.io/repository/bitski/argocd)

Custom Docker image for [Argo CD][argocd].

## Prerequisites

Install [Docker][docker] and configure [BuildKit][buildkit]:

```sh
docker buildx create --use --name buildkit
```

## Build

Build a local image:

```sh
docker buildx build --tag quay.io/bitski/argocd:latest --load .
```

## Startup Test

Test that the image starts:

```sh
docker run --rm -it quay.io/bitski/argocd:latest argocd-repo-server
```

## Publish

Login Quay.io:

```sh
docker login quay.io
```

Then build and publish a [multi-platform image][docker-multiplatform]:

```sh
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag quay.io/bitski/argocd:latest \
  --push .
```

[argocd]: https://argocd-vault-plugin.readthedocs.io/en/stable/
[buildkit]: https://github.com/moby/buildkit
[docker-multiplatform]: https://docs.docker.com/build/buildx/multiplatform-images/
[docker]: https://www.docker.com/get-started/
