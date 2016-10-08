#! /bin/sh

set -e

[ ! -f /rslsync/rslsync.conf ] && cat > /rslsync/rslsync.conf <<EOF
{
  "device_name": "Resilio Sync Server",
  "listening_port": 3369,
  "storage_path": "/rslsync",
  "pid_file": "/var/run/rslsync.pid",
  "use_upnp": false,
  "download_limit": 0,
  "upload_limit": 0,
  "directory_root": "/data",
  "directory_root_policy": "all",
  "webui": {
    "listen": "0.0.0.0:8888",
    "login": "admin",
    "password": "password"
  }
}
EOF

mkdir -p /data
mkdir -p /rslsync

/opt/rslsync --nodaemon --config /rslsync/rslsync.conf
