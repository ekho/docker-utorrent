FROM ubuntu:trusty
MAINTAINER Boris Gorbylev "ekho@ekho.name"

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y locales; \
    locale-gen en_US.UTF-8; \
    locale; \
    apt-get install -y curl sudo; \
    groupadd --gid 1001 utorrent; \
    useradd --uid 1001 --gid utorrent --groups tty --home-dir /utorrent --create-home --shell /bin/bash utorrent; \
    curl -SL http://download-hr.utorrent.com/track/beta/endpoint/utserver/os/linux-x64-ubuntu-13-04 | \
    tar vxz --strip-components 1 -C /utorrent; \
    mkdir /utorrent/settings; \
    mkdir /utorrent/data; \
    touch /utorrent/utserver.log; \
    ln -sf /dev/stdout /utorrent/utserver.log; \
    chown -R utorrent:utorrent /utorrent; \
    cp /utorrent/webui.zip /utorrent/orig-webui.zip; \
    curl -SL https://github.com/psychowood/ng-torrent-ui/releases/latest/download/webui.zip --output /utorrent/ng-webui.zip; \
    curl -SL https://sites.google.com/site/ultimasites/files/utorrent-webui.2013052820184444.zip?attredirects=0 --output /utorrent/ut-webui.zip; \
    apt-get purge -y curl; \
    apt-get autoremove -y; \
    apt-get clean -y; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf /var/cache/apt/*

ADD --chown=utorrent:utorrent docker-entrypoint.sh /
ADD --chown=utorrent:utorrent utserver.conf /utorrent/

RUN chmod 755 /docker-entrypoint.sh

VOLUME ["/utorrent/settings", "/utorrent/data"]
EXPOSE 8080 6881

WORKDIR /utorrent

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/utorrent/utserver", "-settingspath", "/utorrent/settings", "-configfile", "/utorrent/utserver.conf", "-logfile", "/utorrent/utserver.log"]