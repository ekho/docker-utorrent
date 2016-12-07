#!/bin/sh

#set -x

BASEDIR=/eursync
DATADIR=${BASEDIR}/data
UPDDIR=${DATADIR}/updates

halt() {
    echo $@ >&2
    exit 1
}

[ -z "${REMOTEDIR}" ] && halt 'REMOTEDIR empty'
[ -z "${PASSWORD}" ] && halt 'PASSWORD empty'
[ -z "${LOCALDIR}" ] && halt 'LOCALDIR empty'

mkdir -p ${UPDDIR}

# preparing local data dir
LOCALDIR=$(realpath ${UPDDIR}/${LOCALDIR})
echo "Preparing local data dir ${LOCALDIR}"
[ -d "${LOCALDIR}" ] || mkdir -p ${LOCALDIR}

PARTIALDIR=${DATADIR}/partial
echo "Preparing partial dir ${PARTIALDIR}"
[ -d "${PARTIALDIR}" ] || mkdir -p ${PARTIALDIR}

# making passwd file
PASSWDFILE="${BASEDIR}/eursync.passwd"
echo "Storing passwod in file ${PASSWDFILE}"
echo "${PASSWORD}" > ${PASSWDFILE} || halt
chmod 0400 ${PASSWDFILE} || halt

# install cron job
CRON_DIR=/etc/periodic/custom
mkdir -p ${CRON_DIR}
CRON_SCRIPT=${CRON_DIR}/eursync
CRON_TIMER="$(( $RANDOM % 60 )) */3 * * *"

echo "Initializing cron at ${CRON_DIR} on '${CRON_TIMER}'"
crontab -l | { cat; echo "${CRON_TIMER} run-parts ${CRON_DIR}"; } | crontab -

echo "Installing cron job ${CRON_SCRIPT}"
echo "#!/bin/sh \

BASEDIR=${BASEDIR} \
REMOTEDIR=${REMOTEDIR} \
PASSWDFILE=${PASSWDFILE} \
LOCALDIR=${LOCALDIR} \
PARTIALDIR=${PARTIALDIR} \
EXCLUDEFILE=${BASEDIR}/eursync.exclude \

. ${BASEDIR}/eursync.sh
" > ${CRON_SCRIPT}
chmod +x ${CRON_SCRIPT}

if [ "${1}" == "full" ]; then
  echo "Starting lighttpd"
  [ -f "${UPDDIR}/index.html" ] || cp /etc/lighttpd/index.html "${UPDDIR}/index.html"
  mkdir -p ${DATADIR}/logs
  chown -R lighttpd:lighttpd ${DATADIR}/logs
  lighttpd -f /etc/lighttpd/lighttpd.conf || halt
fi

echo "Running initial update ..."
${CRON_SCRIPT} || halt 'FAILED'

# Start Cron
echo "Starting Cron ... "
crond -f -l 0
