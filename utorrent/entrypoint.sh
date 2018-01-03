#!/bin/bash

set -e

if [ ! -z "${DEBUG}" ]; then
    set -x
fi

CURRENT_UID=$(id -u)
if [[ ${CURRENT_UID} != 0 ]]; then
    echo "[WARN] Host UID/GID usage disabled because the container is not running under the root (current uid: ${CURRENT_UID})"
    "$@"
    exit $?
fi

# we find the host uid/gid by assuming the app directory belongs to the host
if [ -z "${HOST_UID}" ]; then
  HOST_UID=$(stat -c %u /utorrent/data)
fi
if [ -z "${HOST_GID}" ]; then
  HOST_GID=$(stat -c %g /utorrent/data)
fi

DO_CHOWN=0

# If the docker user doesn't share the same uid, change it so that it does
if [ ! "${HOST_UID}" = "$(id -u utorrent)" ] && [[ ${HOST_UID} != 0 ]]; then
  usermod -o -u ${HOST_UID} utorrent
  DO_CHOWN=1
fi

if [ ! "${HOST_GID}" = "$(id -g utorrent)" ] && [[ ${HOST_GID} != 0 ]]; then
  groupmod -o -g ${HOST_GID} utorrent
  DO_CHOWN=1
fi

# also update the file uid/gid for files in the docker home directory
# skip the mounted "app" dir because we don't want any changes to mounted file ownership
if [[ ${DO_CHOWN} != 0 ]]; then
  shopt -s dotglob
  for file in /utorrent/*; do
    if [ $file != "/utorrent/utserver" ]; then
      chown -R utorrent:utorrent $file
    fi
  done
fi

sudo -u utorrent -g utorrent -- "$@"
