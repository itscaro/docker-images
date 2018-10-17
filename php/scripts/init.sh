#!/usr/bin/env bash

set -e

SCRIPT_BUILD=/scripts/build.sh

# Fixes the permissions of volumes until user namespaces are a feature in Docker
if [[ -n "$USER_ID" && "`id -u www-data`" != "$USER_ID" ]]; then
    usermod -u ${USER_ID} www-data
fi

[ -f ${SCRIPT_BUILD} ] && ${SCRIPT_BUILD}

exec "$@"
