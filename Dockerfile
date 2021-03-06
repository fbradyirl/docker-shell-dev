FROM gcr.io/google_containers/ubuntu-slim:0.3

ENV BATS_VERSION 0.4.0
ENV SHELLCHECK_VERSION 0.4.3

RUN addgroup --gid 999 shelly
RUN adduser --system \
	--shell /bin/bash \
	--disabled-password \
	--gid 999 \
	--uid 999 \
	shelly

RUN apt-get update -q \
	&& apt-get install -y -q --no-install-recommends bash make curl ca-certificates jq \
	&& curl -L https://s3-us-west-2.amazonaws.com/get-deis/shellcheck-${SHELLCHECK_VERSION}-linux-amd64 -o /usr/local/bin/shellcheck \
	&& chmod +x /usr/local/bin/shellcheck \
	&& curl -o "/tmp/v${BATS_VERSION}.tar.gz" -L \
		"https://github.com/sstephenson/bats/archive/v${BATS_VERSION}.tar.gz" \
	&& tar -x -z -f "/tmp/v${BATS_VERSION}.tar.gz" -C /tmp/ \
	&& bash "/tmp/bats-${BATS_VERSION}/install.sh" /usr/local \
	&& rm -rf /tmp/*

USER shelly
