# docker-utorrent

Docker image to run the [utorrent server](http://www.utorrent.com/).

## Run

### Run via Docker CLI client

To run the utorrent container you can execute:

```bash
docker run                                            \
    --name utorrent                                   \
    -v /path/to/data/dir:/utorrent/data               \
    -p 8080:8080                                      \
    -p 6881:6881                                      \
    ekho/utorrent:latest
```

Open a browser and point your to [http://docker-host:8080/gui](http://docker-host:8080/gui)

### Settings persistence

#### Dir on host machine
```bash
docker run                                            \
    --name utorrent                                   \
    -v /path/to/data/dir:/utorrent/data               \
    -v /path/to/setting/dir:/utorrent/settings        \
    -p 8080:8080                                      \
    -p 6881:6881                                      \
    ekho/utorrent:latest
```

#### Named volume
```bash
docker volume create utorrent-settings

docker run                                            \
    --name utorrent                                   \
    -v /path/to/data/dir:/utorrent/data               \
    -v utorrent-settings:/utorrent/settings           \
    -p 8080:8080                                      \
    -p 6881:6881                                      \
    ekho/utorrent:latest
```

### Custom config

Download [utserver.conf](https://raw.githubusercontent.com/ekho/dockerized-tools/master/utorrent/utserver.conf) and modify it as you want.
All available settings you can find in [example config](https://raw.githubusercontent.com/ekho/dockerized-tools/master/utorrent/utserver.conf.example). 

```bash
docker run                                            \
    --name utorrent                                   \
    -v /path/to/data/dir:/utorrent/data               \
    -v /path/to/utserver.conf:/utorrent/utserver.conf \
    -p 8080:8080                                      \
    -p 6881:6881                                      \
    ekho/utorrent:latest
```

### Custom UID/GID

By default container tries to use uid/gid of owner of `/utorrent/data` volume. But you can specify custom UID/GID by environment variables.

```bash
docker run                                            \
    --name utorrent                                   \
    -v /path/to/data/dir:/utorrent/data               \
    -e HOST_UID=1002 -e HOST_GID=1002                 \
    -p 8080:8080                                      \
    -p 6881:6881                                      \
    ekho/utorrent:latest
```

### Alternative NG UI

[Angular + (flat) Boostrap (μ)Torrent Web UI](https://github.com/psychowood/ng-torrent-ui)

Already bundled. You can activate it with env var `NGWEBUI=1`.

```bash
docker run                                            \
    --name utorrent                                   \
    -v /path/to/data/dir:/utorrent/data               \
    -e NGWEBUI=1                                      \
    -p 8080:8080                                      \
    -p 6881:6881                                      \
    ekho/utorrent:latest
```

### Alternative UT UI

[(μ)Torrent Web UI](https://forum.utorrent.com/topic/49588-%C2%B5torrent-webui/)

Already bundled. You can activate it with env var `UTWEBUI=1`.

```bash
docker run                                            \
    --name utorrent                                   \
    -v /path/to/data/dir:/utorrent/data               \
    -e UTWEBUI=1                                      \
    -p 8080:8080                                      \
    -p 6881:6881                                      \
    ekho/utorrent:latest
```

## Run via Docker Compose

You can also run the utorrent container by using [Docker Compose](https://www.docker.com/docker-compose).

Create your Docker Compose file (docker-compose.yml) using the following YAML snippet:

```yaml
version: '3'
services:
  utorrent:
    image: ekho/utorrent:latest
    container_name: utorrent
    volumes:
      - /path/to/data/dir:/utorrent/data
      - utorrent-settings:/utorrent/settings
      - /path/to/utserver.conf:/utorrent/utserver.conf
    environment:
      HOST_UID: 1002
      HOST_GID: 1002
      NGWEBUI: 1
    ports:
      - 8080:8080
      - 6881:6881
    restart: always
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
volumes:
  utorrent-settings:
```

## Changes
* 2020-04-07 added alternative ui - utorrent-ui
* 2019-08-05 added alternative ui - psychowood/ng-torrent-ui
* 2018-01-03 added host uid/gid usage 
* 2017-12-24 changed directories layout
