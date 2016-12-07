#!/bin/sh

set -x

halt() {
    echo $@ >&2
    exit 1
}

cd ${BASEDIR}

# locking
LOCKFILE="$0"
lockfile-create ${LOCKFILE} || exit 1
lockfile-touch ${LOCKFILE} &

# Save the PID of the lockfile-touch process
BADGER="$!"

OPTIONS="--checksum --recursive --compress --verbose"
OPTIONS="${OPTIONS} --partial --partial-dir=${PARTIALDIR}"
OPTIONS="${OPTIONS} --exclude-from=${EXCLUDEFILE}"
OPTIONS="${OPTIONS} --password-file=${PASSWDFILE}"

# syncing
rsync ${OPTIONS} "${REMOTEDIR}" "${LOCALDIR}"
EXITCODE="$?"

# unlocking
kill "${BADGER}"
lockfile-remove ${LOCKFILE} || exit 1

exit ${EXITCODE}