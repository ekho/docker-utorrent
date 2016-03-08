# Docker container with utorrent
FROM ubuntu:trusty
MAINTAINER Boris Gorbylev "ekho@ekho.name"

RUN locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

#
# Create user and group for utorrent
#
RUN groupadd -r -g 666 utorrent && \
    useradd -r -u 666 -g 666 -m utorrent

#
# Add utorrent dist
#
ADD http://download.ap.bittorrent.com/track/beta/endpoint/utserver/os/linux-x64-ubuntu-13-04 /tmp/utserver.tar.gz

#
# Add utorrent init script and config.
#
ADD utorrent.sh /opt/utorrent/utorrent.sh
ADD utorrent.conf /opt/utorrent/utorrent.conf

#
# Unpack utorrent and change permissions
#
RUN tar vxzf /tmp/utserver.tar.gz --strip-components 1 -C /opt/utorrent && \
    rm -f /tmp/utserver.tar.gz && \
    chmod 755 /opt/utorrent/utorrent.sh && \
    mkdir /utorrent && \
    chown utorrent:utorrent /utorrent

VOLUME ["/utorrent", "/data"]
EXPOSE 8080 6881

#
# Start utorrent.
#

WORKDIR /utorrent
USER utorrent

CMD ["/opt/utorrent/utorrent.sh"]
