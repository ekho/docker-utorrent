# docker-utorrent
![Docker Pulls](https://img.shields.io/docker/pulls/ekho/utorrent?style=flat-square)
![Docker Stars](https://img.shields.io/docker/stars/ekho/utorrent?style=flat-square)
![Docker Image Version (latest semver)](https://img.shields.io/docker/v/ekho/utorrent?sort=semver&style=flat-square)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/ekho/utorrent?sort=semver&style=flat-square)
![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/ekho/utorrent?style=flat-square)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/ekho/utorrent?style=flat-square)

Docker image to run the [utorrent server](http://www.utorrent.com/).

**NOTE:** Image has been refactored. You should update your configs. Or you can use `ekho/utorrent:legacy` image instead of `ekho/utorrent:latest`

## Run

### Run via Docker CLI client

To run the utorrent container you can execute:

```bash
docker run                                            \
    --name utorrent                                   \
    -v /path/to/data/dir:/data                        \
    -p 8080:8080                                      \
    -p 6881:6881                                      \
    -p 6881:6881/udp                                  \
    ekho/utorrent:<tag>
```

Open a browser and point your to [http://docker-host:8080/gui](http://docker-host:8080/gui)

### Settings persistence

#### Dir on host machine
```bash
docker run                                            \
    --name utorrent                                   \
    -v /path/to/data/dir:/data                        \
    -v /path/to/setting/dir:/utorrent/settings        \
    -p 8080:8080                                      \
    -p 6881:6881                                      \
    -p 6881:6881/udp                                  \
    ekho/utorrent:<tag>
```

#### Named volume
```bash
docker volume create utorrent-settings

docker run                                            \
    --name utorrent                                   \
    -v /path/to/data/dir:/data                        \
    -v utorrent-settings:/utorrent/settings           \
    -p 8080:8080                                      \
    -p 6881:6881                                      \
    -p 6881:6881/udp                                  \
    ekho/utorrent:<tag>
```

### Configure

All available settings you can find in [example config](./utserver.conf.example).
Almost all of these settings can be changed except:
- `bind_ip` - set as 0.0.0.0
- `dir_active`, `dir_completed` - /data
- `dir_torrent_files` - /utorrent/torrents
- `dir_temp_files` - /utorrent/temp
- `dir_autoload` - /utorrent/autoload
- `dir_request` - /utorrent/request
- `dir_root` - /data
- `preferred_interface` - empty
- `ut_webui_dir` - controlled by `webui` var
- `randomize_bind_port` - false

You can specify list of download dirs using `dir_download` var.

```bash
docker run                                            \
    --name utorrent                                   \
    -v /path/to/data/dir:/data                        \
    -v /path/to/data/dir2:/abs-path-dir               \
    -e dir_autoload_delete=true                       \
    -e dir_download=subdir1,/abs-path-dir             \
    -p 8080:8080                                      \
    -p 6881:6881                                      \
    -p 6881:6881/udp                                  \
    ekho/utorrent:<tag>
```

### Custom UID/GID

By default container tries to use uid/gid of owner of `/data` volume. But you can specify custom UID/GID by environment variables.

```bash
docker run                                            \
    --name utorrent                                   \
    -v /path/to/data/dir:/data                        \
    -e UID=1000 -e GID=1000                           \
    -p 8080:8080                                      \
    -p 6881:6881                                      \
    -p 6881:6881/udp                                  \
    ekho/utorrent:<tag>
```

### Alternative UI

- `ng` - [Angular + (flat) Boostrap (μ)Torrent Web UI](https://github.com/psychowood/ng-torrent-ui)
- `ut` - [(μ)Torrent Web UI](https://forum.utorrent.com/topic/49588-%C2%B5torrent-webui/)

Already bundled. You can activate it with env var `webui=<ng|ut>`.

```bash
docker run                                            \
    --name utorrent                                   \
    -v /path/to/data/dir:/data                        \
    -e webui=ng                                       \
    -p 8080:8080                                      \
    -p 6881:6881                                      \
    -p 6881:6881/udp                                  \
    ekho/utorrent:<tag>
```

## Run via Docker Compose

You can also run the utorrent container by using [Docker Compose](https://www.docker.com/docker-compose).

Create your Docker Compose file (docker-compose.yml) using the following YAML snippet:

```yaml
version: '3.7'
services:
  utorrent:
    image: ekho/utorrent:<tag>
    volumes:
      - utorrent-settings:/utorrent/settings
      - /path/to/data/dir:/data
      - /path/to/data/dir2:/abs-path-dir
    environment:
      UID: 1000
      GID: 1000
      webui: ng
      dir_autoload_delete: true
      dir_download: subdir1,/abs-path-dir
    ports:
      - 8080:8080
      - 6881:6881
      - 6881:6881/udp
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
* 2020-04-15 totally refactored; incompatible with previous setup
* 2020-04-08 minor build refactoring
* 2020-04-07 added alternative ui - utorrent-ui
* 2019-08-05 added alternative ui - psychowood/ng-torrent-ui
* 2018-01-03 added host uid/gid usage 
* 2017-12-24 changed directories layout
