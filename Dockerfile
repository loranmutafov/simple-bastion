FROM alpine:3.17.1

LABEL maintainer="Loran <hi@loran.dev>"

ARG HOME=/var/lib/bastion

ARG USER=bastion
ARG GROUP=bastion
ARG UID=4096
ARG GID=4096

ENV HOST_KEYS_PATH_PREFIX="/usr"
ENV HOST_KEYS_PATH="${HOST_KEYS_PATH_PREFIX}/etc/ssh"
ENV BASTION_USER=${USER}
ENV BASTION_GROUP=${GROUP}

COPY bastion /usr/sbin/bastion
COPY setup-keys.sh /usr/sbin/setup-keys.sh

RUN addgroup -S -g ${GID} ${GROUP} \
    && adduser -D -h ${HOME} -s /bin/ash -g "${USER} service" \
           -u ${UID} -G ${GROUP} ${USER} \
    && sed -i "s/${USER}:!/${USER}:*/g" /etc/shadow \
    && set -x \
    && apk add --no-cache openssh-server \
    && echo "Welcome to Bastion!" > /etc/motd \
    && chmod +x /usr/sbin/bastion \
    && chmod +x /usr/sbin/setup-keys.sh \
    && mkdir -p ${HOST_KEYS_PATH} \
    && mkdir /etc/ssh/auth_principals \
    && echo "bastion" > /etc/ssh/auth_principals/bastion

VOLUME ${HOST_KEYS_PATH}

ENTRYPOINT ["bastion"]
