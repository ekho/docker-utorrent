#!/bin/bash

#
# Copying config to work dir.
#

if [[ ! -e /utorrent/utserver.conf ]]; then
    printf 'Copying utserver.conf to /utorrent ...'
    cp /opt/utorrent/utserver.conf /utorrent/utserver.conf
    echo "[DONE]"
fi

#
# Finally, start utorrent.
#

echo 'Starting utorrent server...'
/opt/utorrent/utserver -settingspath /utorrent/ -configfile /utorrent/utserver.conf -logfile /utorrent/utserver.log
