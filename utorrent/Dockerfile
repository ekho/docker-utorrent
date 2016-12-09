# Docker container with utorrent
FROM ubuntu:trusty
MAINTAINER Boris Gorbylev "ekho@ekho.name"

RUN locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8 \
    LANG en_US.UTF-8 \
    LANGUAGE en_US:en

#
# Create user and group for utorrent
#
RUN useradd -G users -m utorrent

#
# Add utorrent dist
#
ADD http://download.ap.bittorrent.com/track/beta/endpoint/utserver/os/linux-x64-ubuntu-13-04 /tmp/utserver.tar.gz

#
# Add utorrent init script and config.
#
ADD utserver.sh /opt/utorrent/utserver.sh
ADD utserver.conf /opt/utorrent/utserver.conf

#
# Unpack utorrent and change permissions
#
VOLUME ["/utorrent", "/data"]
EXPOSE 8080 6881

RUN tar vxzf /tmp/utserver.tar.gz --strip-components 1 -C /opt/utorrent && \
    rm -f /tmp/utserver.tar.gz && \
    chown -R utorrent:utorrent /utorrent && \
    chmod 755 /opt/utorrent/utserver.sh

#
# Start utorrent.
#

WORKDIR /utorrent
USER utorrent

CMD ["/opt/utorrent/utserver.sh"]
