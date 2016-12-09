FROM alpine:latest
MAINTAINER Boris Gorbylev <ekho@ekho.name>

ENV REMOTEDIR 'rsync://<host>[/path]' \
    PASSWORD '******' \
    LOCALDIR '/'

VOLUME /eursync/data

RUN apk add --update --no-cache \
      lockfile-progs \
      rsync \
      tini \
 && rm -rf /var/cache/apk/*

WORKDIR /eursync

ADD assets/scripts/* /eursync/

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/eursync/eursync.start.sh"]
