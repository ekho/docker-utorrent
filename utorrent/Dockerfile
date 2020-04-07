FROM ubuntu:trusty
MAINTAINER Boris Gorbylev "ekho@ekho.name"

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

RUN export DEBIAN_FRONTEND=noninteractive && \
    addgroup --gid 1001 utorrent && \
    adduser --uid 1001 --ingroup utorrent --home /utorrent --shell /bin/bash --disabled-password --gecos "" utorrent && \
    apt-get update && \
    apt-get install -y locales curl && \
    locale-gen en_US.UTF-8 && \
    locale && \
    curl -SL http://download.ap.bittorrent.com/track/beta/endpoint/utserver/os/linux-x64-ubuntu-13-04 | \
    tar vxz --strip-components 1 -C /utorrent && \
    mkdir /utorrent/settings && \
    mkdir /utorrent/data && \
    touch /utorrent/utserver.log && \
    ln -sf /dev/stdout /utorrent/utserver.log && \
    chown -R utorrent:utorrent /utorrent && \
    cp /utorrent/webui.zip /utorrent/orig-webui.zip && \
    curl -sSL https://github.com/psychowood/ng-torrent-ui/releases/latest/download/webui.zip --output /utorrent/ng-webui.zip && \
    curl -sSL https://sites.google.com/site/ultimasites/files/utorrent-webui.2013052820184444.zip?attredirects=0 --output /utorrent/ut-webui.zip && \
    apt-get purge -y curl && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/*

ADD --chown=utorrent:utorrent entrypoint.sh /utorrent/entrypoint.sh
ADD --chown=utorrent:utorrent utserver.conf /utorrent/utserver.conf

RUN chmod 755 /utorrent/entrypoint.sh

VOLUME ["/utorrent/settings", "/utorrent/data"]
EXPOSE 8080 6881

WORKDIR /utorrent

ENTRYPOINT ["/utorrent/entrypoint.sh"]
CMD ["/utorrent/utserver", "-settingspath", "/utorrent/settings", "-configfile", "/utorrent/utserver.conf", "-logfile", "/utorrent/utserver.log"]