#!/bin/sh
while IFS= read -r line
do
    IFS=';' read -r username publickey <<EOF
$line
EOF
    adduser -D -h "/home/${username}" -s /bin/ash -g "${username} service" \
        -G "${GROUP}" "${username}"

    mkdir -p "/home/${username}/.ssh"
    echo "${publickey}" > "/home/${username}/.ssh/authorized_keys"

    chown -R "${username}":"${GROUP}" "/home/${username}/.ssh"
    chmod 700 "/home/${username}/.ssh"
    chmod 600 "/home/${username}/.ssh/authorized_keys"
done <"${SETUP_KEYS_PATH}"
