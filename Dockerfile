FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
RUN set -x \
    && dpkg --add-architecture i386  \
    && apt update \
    # Install `steamcmd`
    && echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections \
    && apt install -y --no-install-recommends --no-install-suggests \
    ca-certificates curl lib32gcc-s1 lib32stdc++6 steamcmd locales \
    # Fix locales
    && locale-gen "en_US.UTF-8" \
    # Clean up
    && apt clean autoclean  \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Install `wine`
RUN set -x \
    && dpkg --add-architecture i386 \
    && apt update  \
    && apt install -y --no-install-recommends --no-install-suggests wine64 \
    && apt clean autoclean \
    && apt autoremove -y  \
    && rm -rf /var/lib/apt/lists/*

ARG UID=1000
ARG GID=1000

ENV UID=${UID}
ENV GID=${GID}

WORKDIR /app

COPY ./entrypoint.sh /

RUN set -x \
    && mkdir -p /app /data \
    && chown -R ${UID}:${GID} /app /data /entrypoint.sh \
    && chmod +x /entrypoint.sh

VOLUME [ "/app", "/data" ]

USER ${UID}:${GID}

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]