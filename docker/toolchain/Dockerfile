FROM alpine:3.18.2 as upgraded-alpine
RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add --no-cache \
        bash

FROM upgraded-alpine as release-binary-fetcher
COPY ./versions.sh /tmp/versions.sh
COPY ./fetch_binaries.sh /tmp/fetch_binaries.sh
RUN /tmp/fetch_binaries.sh

FROM upgraded-alpine
COPY --from=release-binary-fetcher /tmp/binaries/* /usr/local/bin
USER root
WORKDIR /root
COPY motd motd

# CMD ["bash"]
ENTRYPOINT ["/bin/sleep","3600"]
