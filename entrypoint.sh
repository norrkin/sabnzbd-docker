#!/bin/bash
#
# entrypoint.sh
set -e

# Create local user & map to host.
printf "Create SABnzbd user/group... "
groupadd -o -g ${GID} sabnzbd && useradd -o -M -u ${UID} -g ${GID} -d /sabnzbd sabnzbd
echo "[DONE]"


# Set a couple variables.
USER="sabnzbd"
CONFIG=/datadir/config.ini


# Set UID/GID for local sabnzbd user.
printf "Updating UID/GID... "
[[ $(id -u ${USER}) == ${UID} ]] || usermod  -o -u ${UID} ${USER}
[[ $(id -g ${USER}) == ${GID} ]] || groupmod -o -g ${GID} ${USER}
echo "[DONE]"


# Set directory permissions.
printf "Set permissions... "
touch ${CONFIG}
chown -R ${USER}: /sabnzbd
chown ${USER}: /datadir /download $(dirname ${CONFIG})
echo "[DONE]"

#
# Because SABnzbd runs in a container we've to make sure we've a proper
# listener on 0.0.0.0. We also have to deal with the port which by default is
# 8080 but can be changed by the user.
#

printf "Get listener port... "
PORT=$(sed -n '/^port *=/{s/port *= *//p;q}' ${CONFIG})
LISTENER="-s 0.0.0.0:${PORT:=8080}"
echo "[${PORT}]"


# start SABnzbd.
echo "Starting SABnzbd..."
exec su -pc "./SABnzbd.py -b 0 -f ${CONFIG} ${LISTENER}" ${USER}
