#!/bin/sh
# Escape into (subshell), because we're modifying the IFS
(
    while IFS= read -r line
    # Yet another (subshell), because we're modifying the IFS we're using
    do (
        IFS=':' read -r username publickey <<EOF
$line
EOF
        adduser -D -h "/home/${username}" -s /bin/ash -g "${username} service" \
            -G "${BASTION_GROUP}" "${username}"

        mkdir -p "/home/${username}/.ssh"
        echo "${publickey}" > "/home/${username}/.ssh/authorized_keys"

        chown -R "${username}":"${BASTION_GROUP}" "/home/${username}/.ssh"
        chmod 700 "/home/${username}/.ssh"
        chmod 600 "/home/${username}/.ssh/authorized_keys"
    ) done <"${SETUP_KEYS_PATH}"
)
