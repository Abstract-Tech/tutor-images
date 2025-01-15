FROM alpine:3.21 as age

RUN apk add curl

RUN curl -L https://github.com/FiloSottile/age/releases/download/v1.2.1/age-v1.2.1-linux-amd64.tar.gz | tar xzf - -C /tmp

FROM alpine:3.21 as sops

RUN apk add curl

RUN curl -L https://github.com/getsops/sops/releases/download/v3.9.3/sops-v3.9.3.linux.amd64 > /tmp/sops
RUN chmod +x /tmp/sops

FROM python:3.11-bookworm

ARG DEBIAN_FRONTEND=noninteractive

COPY --from=docker:23 /usr/local/bin/* /usr/bin/
COPY --from=docker:23 /usr/local/libexec/docker/cli-plugins/* /usr/libexec/docker/cli-plugins/
COPY --from=mikefarah/yq:4.40.5 /usr/bin/yq /usr/bin/yq
COPY --from=bitnami/kubectl:1.28.6 /opt/bitnami/kubectl/bin/kubectl /usr/local/bin
COPY --from=bitnami/minio-client:2024.5.9 /opt/bitnami/minio-client/bin/mc /usr/local/bin
COPY --from=age /tmp/age/age /usr/bin/age
COPY --from=sops /tmp/sops /usr/local/bin/sops
RUN chmod +x /usr/local/bin/sops

RUN apt-get update && apt-get install -qq --no-install-recommends python3 python3-pip libyaml-dev

ARG tutor_release
ENV TUTOR_RELEASE=$tutor_release

RUN pip install "tutor<=${TUTOR_RELEASE}" \
                "tutor-android<=${TUTOR_RELEASE}" \
                "tutor-discovery<=${TUTOR_RELEASE}" \
                "tutor-ecommerce<=${TUTOR_RELEASE}" \
                "tutor-forum<=${TUTOR_RELEASE}" \
                "tutor-mfe<=${TUTOR_RELEASE}" \
                "tutor-minio<=${TUTOR_RELEASE}" \
                "tutor-notes<=${TUTOR_RELEASE}" \
                "tutor-webui<=${TUTOR_RELEASE}" \
                "tutor-xqueue<=${TUTOR_RELEASE}"

LABEL org.opencontainers.image.authors="Illia Shestakov <i.shestakov@abstract-technology.de>"
