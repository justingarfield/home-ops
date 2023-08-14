# Alpine image with update and upgrade performed
FROM alpine:3.18.2 as upgraded-alpine
RUN set -ex \
    && apk update \
    && apk upgrade

# Used to download and prep tooling binaries
FROM upgraded-alpine as release-binary-fetcher
RUN set -ex && apk add bash
COPY ./versions.sh /tmp/versions.sh
COPY ./fetch_binaries.sh /tmp/fetch_binaries.sh
RUN /tmp/fetch_binaries.sh

# Used as final image for end-user
FROM upgraded-alpine
RUN set -ex \
    && apk add \
        zsh \
        git \
        openssl \
        # Needed for pre-commit (python apps make me feel dead inside)
        python3 \
        py3-pip \
        python3-dev \
        gcc \
        musl-dev \
        bash

COPY --from=release-binary-fetcher /tmp/binaries/* /usr/local/bin/
COPY ./etc/* /etc/

# Default user will be 'tcuser', UID/GID 1000 matches WSL / Ubuntu defaults for single user
RUN addgroup --g 1000 tcuser
RUN adduser -u 1000 -G tcuser -h /home/tcuser -D tcuser
USER tcuser

COPY --chown=1000:1000 ./home/tcuser/* /home/tcuser/
RUN git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions /home/tcuser/src/zsh-users/zsh-autosuggestions
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/tcuser/src/romkatv/powerlevel10k
COPY --chown=1000:1000 ./misc/README /home/tcuser/src/justingarfield/home-ops/

# Pre-configure Git globals
ARG GITHUB_USER_EMAIL
ARG GITHUB_USER_NAME
RUN git config --global user.email $GITHUB_USER_EMAIL && git config --global user.name $GITHUB_USER_NAME

# Pre-configure pre-commit
RUN pip install pre-commit

LABEL org.opencontainers.image.source="https://github.com/justingarfield/home-ops"

WORKDIR /home/tcuser/src/justingarfield/home-ops/
CMD ["zsh"]
