FROM ubuntu:trusty
MAINTAINER Boris Gorbylev <ekho@ekho.name>

ADD http://download-lb.utorrent.com/endpoint/btsync/os/linux-x64/track/stable /btsync.tar.gz
ADD start.sh /start.sh

ENV LANG en_US.UTF-8
RUN locale-gen $LANG && \
    tar xf /btsync.tar.gz && \
    rm /btsync.tar.gz

VOLUME ["/data"]
EXPOSE 3369/udp 8888

CMD ["/start.sh"]
