FROM alpine:3.18.2 as upgraded-alpine
ARG AZURE_CLI_VERSION=2.50.0
RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add --no-cache \
        bash \
        openssl \
        python3 \
        py3-pip

RUN apk add --no-cache --update --virtual=build \
        gcc \
        musl-dev \
        python3-dev \
        libffi-dev \
        openssl-dev \
        cargo \
        make

RUN pip3 install --no-cache-dir --prefer-binary azure-cli==${AZURE_CLI_VERSION}
RUN apk del build

FROM upgraded-alpine as release-binary-fetcher
COPY ./versions.sh /tmp/versions.sh
COPY ./fetch_binaries.sh /tmp/fetch_binaries.sh
RUN /tmp/fetch_binaries.sh

FROM upgraded-alpine
COPY --from=release-binary-fetcher /tmp/binaries/* /usr/local/bin/
USER root
WORKDIR /root
COPY motd motd

LABEL org.opencontainers.image.source="https://github.com/justingarfield/home-ops"

# CMD ["bash"]
ENTRYPOINT ["/bin/sleep","3600"]
