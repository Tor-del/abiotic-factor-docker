FROM ubuntu:24.04

RUN dpkg --add-architecture i386 && \
    apt update && \
    echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt install -y wine64 steamcmd && \
    apt clean autoclean && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN /usr/games/steamcmd +quit

ARG UID=1000
ARG GID=1000

ENV UID=${UID}
ENV GID=${GID}

USER ${UID}:${GID}

WORKDIR /app

VOLUME [ "/app", "/data" ]

COPY --chown=${UID}:${GID} ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]