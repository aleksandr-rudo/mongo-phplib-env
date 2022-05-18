ARG DEBIAN_VERSION_NAME=buster

FROM python:3.10-${DEBIAN_VERSION_NAME}

RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		jq \
		numactl \
	; \
	if ! command -v ps > /dev/null; then \
		apt-get install -y --no-install-recommends procps; \
	fi; \
	rm -rf /var/lib/apt/lists/*

# grab gosu for easy step-down from root (https://github.com/tianon/gosu/releases)
ENV GOSU_VERSION 1.12
# grab "js-yaml" for parsing mongod's YAML config files (https://github.com/nodeca/js-yaml/releases)
ENV JSYAML_VERSION 3.13.1

RUN set -ex; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		wget \
	; \
	if ! command -v gpg > /dev/null; then \
		apt-get install -y --no-install-recommends gnupg dirmngr; \
		savedAptMark="$savedAptMark gnupg dirmngr"; \
	elif gpg --version | grep -q '^gpg (GnuPG) 1\.'; then \
# "This package provides support for HKPS keyservers." (GnuPG 1.x only)
		apt-get install -y --no-install-recommends gnupg-curl; \
	fi; \
	rm -rf /var/lib/apt/lists/*; \
	\
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	command -v gpgconf && gpgconf --kill all || :; \
	rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	\
	wget -O /js-yaml.js "https://github.com/nodeca/js-yaml/raw/${JSYAML_VERSION}/dist/js-yaml.js"; \
# TODO some sort of download verification here
	\
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	\
# smoke test
	chmod +x /usr/local/bin/gosu; \
	gosu --version; \
	gosu nobody true

RUN mkdir /docker-entrypoint-initdb.d

RUN set -ex; \
	export GNUPGHOME="$(mktemp -d)"; \
	set -- 'F5679A222C647C87527C2F8CB00A0BD1E2C63C11'; \
	for key; do \
		gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
	done; \
	mkdir -p /etc/apt/keyrings; \
	gpg --batch --export "$@" > /etc/apt/keyrings/mongodb.gpg; \
	command -v gpgconf && gpgconf --kill all || :; \
	rm -r "$GNUPGHOME"

ARG MONGO_MAJOR=1.0
ARG MONGO_VERSION=1.0.0
ARG MONGO_ORCH_VERSION_NAME=latest

ENV MONGODB_VERSION=${MONGO_ORCH_VERSION_NAME}
ENV MONGO_MAJOR=${MONGO_MAJOR}
ENV MONGO_VERSION=${MONGO_VERSION}
ENV DRIVERS_TOOLS=/etc/mongodb_pack
ENV PATH=/etc/mongodb_pack/mongodb/bin:$PATH



RUN apt-get update && apt-get install -y mc systemd htop git gnupg wget curl
RUN apt-get update && apt-get install -y libcurl4 libgssapi-krb5-2 libldap-2.4-2 libwrap0 libsasl2-2 libsasl2-modules libsasl2-modules-gssapi-mit snmp openssl liblzma5



RUN mkdir /etc/mongodb_pack
RUN chown -R mongodb:mongodb /etc/mongodb_pack

COPY install.sh /var/www/
WORKDIR /var/www/
RUN /var/www/install.sh



RUN set -x \
# installing "mongodb-enterprise" pulls in "tzdata" which prompts for input
	&& export DEBIAN_FRONTEND=noninteractive \
	&& apt-get -y update \
# starting with MongoDB 4.3 (and backported to 4.0 and 4.2 *and* 3.6??), the postinst for server includes an unconditional "systemctl daemon-reload" (and we don't have anything for "systemctl" to talk to leading to dbus errors and failed package installs)
	&& ln -s /bin/true /usr/local/bin/systemctl \
	&& rm -f /usr/local/bin/systemctl \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/lib/mongodb 

RUN mkdir -p /data/db /data/configdb \
	&& chown -R mongodb:mongodb /data/db /data/configdb
VOLUME /data/db /data/configdb

COPY docker-entrypoint-5.0.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint-5.0.sh"]

EXPOSE 27017
CMD ["mongod"]