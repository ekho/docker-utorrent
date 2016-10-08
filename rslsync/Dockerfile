FROM ubuntu:trusty
MAINTAINER Boris Gorbylev <ekho@ekho.name>

ADD https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz /tmp/rslsync.tar.gz
ADD start.sh /start.sh

VOLUME ["/data", "/rslsync"]
EXPOSE 3369 8888

ENV LANG en_US.UTF-8
RUN locale-gen $LANG && \
    tar xf /tmp/rslsync.tar.gz -C /opt && \
    rm /tmp/rslsync.tar.gz

CMD ["/start.sh"]
