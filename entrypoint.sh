#!/bin/sh

function terminate() {
    echo "Detected SIGTERM, shuting down..."
    killall -9 openconnect &>/dev/null
    killall -9 socat &>/dev/null
    exit 0
}
trap terminate TERM INT

connect() {
    killall -9 openconnect &>/dev/null
    killall -9 socat &>/dev/null

    for NAME in $(awk "END { for (name in ENVIRON) { print name; }}" < /dev/null)
    do
        if test "${NAME#*PORT_MAP_}" != "$NAME"
        then
            VAL=$(awk "END { printf ENVIRON[\"$NAME\"]; }" < /dev/null)
            PORT="${VAL%|*}"
            TARGET="${VAL#*|}"
            socat TCP4-LISTEN:${PORT},fork TCP4:${TARGET} &
        fi
    done

    # Start openconnect
    if [[ -z "${PASSWORD}" ]]; then
        # Ask for password
        openconnect -u $USER $OPTIONS $URL
    elif [[ ! -z "${PASSWORD}" ]] && [[ ! -z "${MFA_CODE}" ]]; then
        # Multi factor authentication (MFA)
        (echo $PASSWORD echo $MFA_CODE) | openconnect -u $USER $OPTIONS --passwd-on-stdin $URL
    elif [[ ! -z "${PASSWORD}" ]]; then
        # Standard authentication
        echo $PASSWORD | openconnect -u $USER $OPTIONS --passwd-on-stdin $URL
    fi
}

until (connect); do
    echo "openconnect exited. Restarting process in 5 seconds…" >&2
    sleep 5
done
