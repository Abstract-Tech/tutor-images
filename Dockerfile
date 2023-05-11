FROM python:3.11-bullseye

ARG DEBIAN_FRONTEND=noninteractive

COPY --from=docker:23 /usr/local/bin/* /usr/bin/
COPY --from=docker:23 /usr/local/libexec/docker/cli-plugins/* /usr/libexec/docker/cli-plugins/
COPY --from=mikefarah/yq:4.33.3 /usr/bin/yq /usr/bin/yq

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

MAINTAINER Illia Shestakov <i.shestakov@abstract-technology.de>
