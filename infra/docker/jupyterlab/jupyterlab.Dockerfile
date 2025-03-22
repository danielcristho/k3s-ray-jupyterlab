ARG BASE_CONTAINER=jupyter/datascience-notebook:python-3.10.11
FROM $BASE_CONTAINER

USER root

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
        curl