# syntax=docker/dockerfile:1

#############################################################################
# Builder container                                                         #
#############################################################################
FROM --platform="$BUILDPLATFORM" \
    registry.access.redhat.com/ubi8-minimal AS builder

ARG TARGETARCH

ARG AVP_VERSION=1.12.0
ARG AVP_BIN_NAME="argocd-vault-plugin_${AVP_VERSION}_linux_$TARGETARCH"
ARG AVP_RELEASE_URL="https://github.com/argoproj-labs/argocd-vault-plugin/releases/download/v$AVP_VERSION/$AVP_BIN_NAME"
ARG AVP_CHECKSUM_URL="https://github.com/argoproj-labs/argocd-vault-plugin/releases/download/v$AVP_VERSION/argocd-vault-plugin_${AVP_VERSION}_checksums.txt"

WORKDIR /tmp

ADD --link "$AVP_RELEASE_URL" .
ADD --link "$AVP_CHECKSUM_URL" checksums.txt
RUN cat checksums.txt | grep "$AVP_BIN_NAME" | sha256sum -c
RUN mv "$AVP_BIN_NAME" argocd-vault-plugin

#############################################################################
# Release container                                                         #
#############################################################################
FROM argoproj/argocd:v2.4.12 AS release

ARG TARGETARCH

COPY --from=builder \
    /tmp/argocd-vault-plugin \
    /usr/local/bin/argocd-vault-plugin
