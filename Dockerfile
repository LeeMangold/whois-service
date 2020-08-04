# vim:set ft=dockerfile:

# VERSION 1.0
# AUTHOR:         Lee Mangold <lee@mangoldsecurity.com>
# DESCRIPTION:    whois (by Marco d'Itri) in a Docker container with JSON wrapper
# TO_BUILD:       docker build --rm -t LeeMangold/whois-service .
# SOURCE:         https://github.com/LeeMangold/whois-service

# Pull base image.
FROM debian:buster
MAINTAINER Lee Mangold <lee@mangoldsecurity.com>

# Compile whois
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    whois \
    php-cli \
    phpunit \
    composer \
    bash && \
  git clone https://github.com/LeeMangold/phpWhois.git /opt/phpWhois && \
  cd /opt/phpWhois && \
  composer install && \
  apt-get -y purge && \ 
  apt-get -y autoremove --purge && \
  rm -rf /var/lib/apt/lists/* 

RUN \
  export uid=1000 gid=1000 && \
  groupadd --gid ${gid} user && \
  useradd --uid ${uid} --gid ${gid} --create-home user

USER user
WORKDIR /home/user
ENTRYPOINT ["/usr/bin/php", "-f", "/opt/phpWhois/app/go.php"]
