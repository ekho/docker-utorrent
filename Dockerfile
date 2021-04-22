FROM ubuntu:trusty
MAINTAINER Boris Gorbylev "ekho@ekho.name"

ARG CONFD_VERSION=0.16.0

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

RUN set -eux; \
    echo '--> Install packages'; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y locales; \
    locale-gen en_US.UTF-8; \
    locale; \
    apt-get install -y curl sudo openssl unrar; \
    apt-get autoremove -y; \
    apt-get clean -y; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf /var/cache/apt/*; \
    echo '--> Setup user'; \
    groupadd --gid 1001 utorrent; \
    useradd --uid 1001 --gid utorrent --groups tty --home-dir /utorrent --create-home --shell /bin/bash utorrent; \
    echo '--> Download and unpack utorrent'; \
    curl -SL http://download-hr.utorrent.com/track/beta/endpoint/utserver/os/linux-x64-ubuntu-13-04 | \
    tar vxz --strip-components 1 -C /utorrent; \
    mkdir -p /utorrent/webui/builtin; \
    mv /utorrent/webui.zip /utorrent/webui/builtin/; \
    mkdir -p /utorrent/webui/ng /utorrent/webui/ut; \
    echo '--> Download NG webui'; \
    curl -SL https://github.com/psychowood/ng-torrent-ui/releases/latest/download/webui.zip --output  /utorrent/webui/ng/webui.zip; \
    echo '--> Download UT webui'; \
    curl -SL https://sites.google.com/site/ultimasites/files/utorrent-webui.2013052820184444.zip?attredirects=0 --output /utorrent/webui/ut/webui.zip; \
    echo '--> Setup confd'; \
    curl -fSL --output /confd https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64; \
    chmod +x /confd; \
    echo '--> Make dirs'; \
    mkdir \
        /utorrent/autoload \
        /utorrent/settings \
        /utorrent/temp \
        /utorrent/torrents \
        /utorrent/data; \
    chown -R utorrent:utorrent /utorrent

ADD --chown=utorrent:utorrent docker-entrypoint.sh /
RUN set -eux; chmod +x /docker-entrypoint.sh

# Copy confd configs and templates
ADD --chown=utorrent:utorrent confd/ /etc/confd/

VOLUME ["/utorrent/settings", "/utorrent/autoload", "/utorrent/temp", "/data"]
EXPOSE 8080 6881
HEALTHCHECK --interval=30s --timeout=10s --retries=5 CMD curl -sSf http://127.0.0.1:8080/gui

WORKDIR /utorrent

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/utorrent/utserver", "-settingspath", "/utorrent/settings", "-configfile", "/utorrent/utserver.conf", "-logfile", "/dev/stdout"]
