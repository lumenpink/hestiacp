FROM ubuntu:focal
LABEL maintainer="Lohn <j@lo.hn>"
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm 
RUN apt-get update \
    && apt-get -yf --no-install-recommends install \
    gnupg \
    software-properties-common \
    wget \
    curl \
    dpkg-dev \
    pwgen \
    ca-certificates \
    && rm -rf /tmp/* \
    && apt-get -yf autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 
RUN mv /usr/bin/systemctl /usr/bin/systemctl.original
COPY systemctl.wrapper /usr/bin/systemctl
RUN chmod +x /usr/bin/systemctl
RUN mkdir -p /etc/network/if-pre-up.d
RUN curl -O https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install-ubuntu.sh \
    && pwgen -c -n -1 12 > $HOME/password.txt \
    && bash hst-install-ubuntu.sh \
    -e admin@hestiacp.local -s hestiacp.local \
    --password $(cat $HOME/password.txt) \
    -y no -f \
    && rm -rf /tmp/* \
    && apt-get -yf autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
VOLUME ["/hestia", "/home", "/backup"]
EXPOSE 22 25 53 54 80 110 143 443 465 587 993 995 1194 3000 3306 5432 5984 6379 8083 10022 11211 27017