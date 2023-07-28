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
USER root
WORKDIR /root

COPY etc/* /etc/
COPY root/* /root/
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
RUN echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

LABEL org.opencontainers.image.source="https://github.com/justingarfield/home-ops"

CMD ["zsh"]
