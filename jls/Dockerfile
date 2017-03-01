FROM alpine:latest
MAINTAINER Boris Gorbylev <ekho@ekho.name>

RUN apk add --update --no-cache git python py2-pip \
 && pip install --upgrade pip git-lfs \
 && git clone --depth 1 https://github.com/ekho/dockerized-tools.git /tmp/dt \
 && python -m git_lfs -v /tmp/dt \
 && mv /tmp/dt/jls/jls /usr/local/bin/jls \
 && chmod +x /usr/local/bin/jls \
 && rm -rf /tmp/dt \
 && pip uninstall -y git-lfs \
 && apk del --purge --no-cache git python py2-pip

EXPOSE 1017

ENTRYPOINT ["/usr/local/bin/jls"]
