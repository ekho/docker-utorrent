#!/bin/bash

#
# Copying config to work dir.
#

if [[ ! -e /utorrent/utserver.conf ]]; then
    printf 'Copying utorrent.conf to /utorrent ...'
    cp /opt/utorrent/utorrent.conf /utorrent/utorrent.conf
    echo "[DONE]"
fi

#
# Finally, start utorrent.
#

ls -alh /utorrent/utserver

echo 'Starting utorrent server...'
/opt/utorrent/utserver -settingspath /utorrent -configfile /utorrent/utorrent.conf -logfile /utorrent/utserver.log

echo $?