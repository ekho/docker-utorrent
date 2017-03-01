FROM alpine:latest
MAINTAINER Boris Gorbylev <ekho@ekho.name>

ADD jls /usr/local/bin/
RUN chmod +x /usr/local/bin/jls

EXPOSE 1017

ENTRYPOINT ["/usr/local/bin/jls"]
