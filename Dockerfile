FROM alpine:3.21 as base
RUN apk add curl

FROM base AS age
RUN curl -L https://github.com/FiloSottile/age/releases/download/v1.2.1/age-v1.2.1-linux-amd64.tar.gz | tar xzf - -C /tmp

FROM base AS sops
RUN curl -L https://github.com/getsops/sops/releases/download/v3.9.3/sops-v3.9.3.linux.amd64 > /tmp/sops

FROM base AS kubectl
ARG KUBECTL_VERSION=1.28.6
RUN curl -fsSL "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl

FROM base AS minio
RUN curl -fsSL "https://dl.min.io/client/mc/release/linux-amd64/mc" -o /usr/local/bin/mc

FROM python:3.11.15-bookworm

ARG DEBIAN_FRONTEND=noninteractive

COPY --from=docker:28 /usr/local/bin/* /usr/bin/
COPY --from=docker:28 /usr/local/libexec/docker/cli-plugins/* /usr/libexec/docker/cli-plugins/
COPY --from=mikefarah/yq:4.49.2 /usr/bin/yq /usr/bin/yq
COPY --from=age /tmp/age/age /usr/bin/age
COPY --from=sops /tmp/sops /usr/local/bin/sops
COPY --from=minio /usr/local/bin/mc /usr/local/bin/mc
COPY --from=kubectl /usr/local/bin/kubectl /usr/local/bin/kubectl

RUN chmod +x /usr/local/bin/sops
RUN chmod +x /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/mc

RUN apt-get update && apt-get install -qq --no-install-recommends \
    curl ca-certificates \
    python3 python3-pip libyaml-dev \
 && rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.authors="Maksym Bilan <m.bilan@abstract-technology.de>"
LABEL org.opencontainers.image.authors="Emad Rad <e.ehsanrad@abstract-technology.de>"
