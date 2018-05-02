FROM ubuntu:bionic
MAINTAINER Tillmann Heidsieck <theidsieck@leenox.de>

ENV DEBIAN_FRONTEND noninteractive 

RUN apt-get update && apt-get dist-upgrade -yqq && apt-get install -yqq \
	apt-utils \
	locales \
	tzdata

COPY keyboard /etc/default/keyboard

RUN echo "Europe/Berlin" | tee /etc/timezone && \
    ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata  

RUN echo en_US.UTF-8 UTF-8 >> /etc/locale.gen && \
    locale-gen && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get install -yqq \
	bash \
	bash-completion \
	cryptsetup \
	gpg \
	ssmtp \
	signing-party \
	tmux

COPY bash.bashrc /etc/bash.bashrc
COPY entrypoint.sh /entrypoint.sh
RUN useradd -d /home/gpg --user-group gpg 

ENTRYPOINT ["/entrypoint.sh"]
