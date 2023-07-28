FROM alpine:3.18.2 as upgraded-alpine
RUN set -ex \
    && apk update \
    && apk upgrade

FROM upgraded-alpine as release-binary-fetcher
RUN apk add bash
COPY ./versions.sh /tmp/versions.sh
COPY ./fetch_binaries.sh /tmp/fetch_binaries.sh
RUN /tmp/fetch_binaries.sh

FROM upgraded-alpine
RUN apk add zsh git
COPY --from=release-binary-fetcher /tmp/binaries/* /usr/local/bin/

RUN addgroup --g 1000 tcuser
RUN adduser -u 1000 -G tcuser -h /home/tcuser -D tcuser
USER tcuser
WORKDIR /

COPY ./etc/* /etc/
COPY ./home/tcuser/* /home/tcuser/
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/tcuser/powerlevel10k

LABEL org.opencontainers.image.source="https://github.com/justingarfield/home-ops"

WORKDIR /home/tcuser
CMD ["zsh"]
