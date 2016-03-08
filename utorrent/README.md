# docker-utorrent

Docker image to run the [utorrent server](http://www.utorrent.com/).

## Run

### Run via Docker CLI client

To run the utorrent container you can execute:

```bash
docker run                  \
    --name utorrent         \
    -v <data dir>:/data     \
    -v <work dir>:/utorrent \
    -p 8080:8080            \
    -p 6881:6881            \
    ekho/utorrent
```

Open a browser and point your to [http://docker-host:8080/gui](http://docker-host:8080/gui)

### Run via Docker Compose

You can also run the utorrent container by using [Docker Compose](https://www.docker.com/docker-compose).

Create your Docker Compose file (docker-compose.yml) using the following YAML snippet:

```yaml
utorrent:
    image: ekho/utorrent
    container_name: utorrent
    volumes:
        - <data dir>:/data
        - <work dir>:/utorrent
    ports:
        - 8080:8080
        - 6881:6881
    restart: always
```

## Configuration

### Volumes

Please mount the following volumes inside your utorrent container:

* `/utorrent`: Holds all the utorrent settings files and databases
* `/data`: Directory for your downloaded media

