#!/bin/bash
set -eo pipefail

NAMESPACE=$1
if [ "${NAMESPACE}" == "" ]; then
    echo "Usage: ${0} <namespace>"
    exit 1
fi

if [ ! -f "/opt/muna/.enabled" ]; then
    echo "Muna not enabled, exiting"
    exit 1
fi

/opt/muna/scripts/setup_ssenv "${NAMESPACE}"
/opt/muna/scripts/setup_secrets "${NAMESPACE}"
/opt/muna/scripts/setup_ssl "${NAMESPACE}"

systemctl reload apache2

# Only try to reload nginx if it is installed and running
(systemctl is-active --quiet nginx && nginx -t && systemctl reload nginx) || true