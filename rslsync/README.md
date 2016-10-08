# Resilio Sync

## Description

A Dockerfile for [Resilio Sync](https://www.resilio.com/). The default login is `admin` and the default password is `password`. These can be changed in `/data/rslsync.conf`.

## Volumes

### `/data`

Data storage.

### `/rslsync`

Configuration files and state for Resilio Sync.

## Ports

### 3369/udp

Sync protocol UDP port.

### 8888

WebUI port.

