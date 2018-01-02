#!/bin/bash
set -e

# we find the host uid/gid by assuming the app directory belongs to the host
HOST_UID=$(stat -c %u /utorrent/data)
HOST_GID=$(stat -c %g /utorrent/data)

# If the docker user doesn't share the same uid, change it so that it does
if [ ! "${HOST_UID}" = "$(id -u utorrent)" ] && [[ ${HOST_UID} != 0 ]]; then
  usermod -o -u ${HOST_UID} utorrent
  groupmod -o -g ${HOST_GID} utorrent

  # also update the file uid/gid for files in the docker home directory
  # skip the mounted "app" dir because we don't want any changes to mounted file ownership
  shopt -s dotglob
  for file in /utorrent/*; do
    if [ $file != "/utorrent/utserver" ]; then
      chown -R utorrent:utorrent $file
    fi
  done
fi

"$@"