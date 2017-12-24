FROM ubuntu:trusty
MAINTAINER Boris Gorbylev "ekho@ekho.name"

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

RUN export DEBIAN_FRONTEND=noninteractive && \
    useradd -G users -d /utorrent -m utorrent && \
    apt-get update && \
    apt-get install -y locales curl && \
    locale-gen en_US.UTF-8 && \
    locale && \
    curl -L http://download.ap.bittorrent.com/track/beta/endpoint/utserver/os/linux-x64-ubuntu-13-04 | \
    tar vxz --strip-components 1 -C /utorrent && \
    apt-get purge -y curl && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/* && \
    mkdir /utorrent/settings && \
    mkdir /utorrent/data && \
    touch /utorrent/utserver.log && \
    ln -sf /dev/stdout /utorrent/utserver.log && \
    chown -R utorrent:utorrent /utorrent

ADD entrypoint.sh /utorrent/entrypoint.sh
ADD utserver.conf /utorrent/utserver.conf

RUN chown utorrent:utorrent /utorrent/entrypoint.sh && \
    chmod 755 /utorrent/entrypoint.sh

WORKDIR /utorrent
USER utorrent
VOLUME ["/utorrent/settings"]
EXPOSE 8080 6881

ENTRYPOINT ["/utorrent/entrypoint.sh"]
CMD ["/utorrent/utserver", "-settingspath", "/utorrent/settings", "-configfile", "/utorrent/utserver.conf", "-logfile", "/utorrent/utserver.log"]