FROM ubuntu:20.10
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
#RUN mv /usr/bin/systemctl /usr/bin/systemctl.original
COPY systemctl-wrapper /usr/bin/systemctl
COPY mysql-initd /etc/init.d/mysql
COPY hst-install-ubuntu.sh /tmp
COPY vsftpd-initd /tmp/vsftpd
RUN chmod +x /usr/bin/systemctl /etc/init.d/mysql
RUN mkdir /var/run/mysqld && chmod 777 /var/run/mysqld
RUN mkdir -p /etc/network/if-pre-up.d
RUN pwgen -c -n -1 12 > $HOME/password.txt \
    && bash /tmp/hst-install-ubuntu.sh \
    #-o yes -g yes -q yes \
    -c no -i no -b no \
    -e admin@hestiacp.local -s hestiacp.local \
    --password $(cat $HOME/password.txt) \
    -y no -f \
    && rm -rf /tmp/* \
    && apt-get -yf autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
VOLUME ["/usr/local/hestia", "/home", "/backup"]
EXPOSE 22 25 53 54 80 110 143 443 465 587 993 995 1194 3000 3306 5432 5984 6379 8083 10022 11211 27017