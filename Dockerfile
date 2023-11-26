# This dockerfile uses the ubuntu image
# VERSION 0 - EDITION 1
# Author:  Yen-Chin, Lee <yenchin@weintek.com>
# Modified: Ping Wu
# Command format: Instruction [arguments / command] ..

FROM ubuntu:22.04
MAINTAINER Yen-Chin, Lee, coldnew.tw@gmail.com
MAINTAINER Ping Wu, pingwu@mail.com

# Check env
RUN env

# Set TimeZone
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# Using mirrors for apt
RUN \
 mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
 echo "deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted" > /etc/apt/sources.list && \
 echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted" >> /etc/apt/sources.list && \
 echo "deb http://mirrors.aliyun.com/ubuntu/ jammy universe" >> /etc/apt/sources.list && \
 echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-updates universe" >> /etc/apt/sources.list && \
 echo "deb http://mirrors.aliyun.com/ubuntu/ jammy multiverse" >> /etc/apt/sources.list && \
 echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-updates multiverse" >> /etc/apt/sources.list && \
 echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
 echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted" >> /etc/apt/sources.list && \
 echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-security universe" >> /etc/apt/sources.list && \
 echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-security multiverse" >> /etc/apt/sources.list

RUN cat /etc/apt/sources.list

# Add 32bit package in package list
#RUN dpkg --add-architecture i386

# Update package infos first
RUN apt-get update -y

## Install requred packages:
# http://www.yoctoproject.org/docs/current/ref-manual/ref-manual.html

# Essentials
RUN apt-get install -y curl wget sudo vim
#RUN apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
#     build-essential chrpath socat cpio python2 python3 python3-pip python3-pexpect \
#     xz-utils debianutils iputils-ping vim bc g++-multilib bash sudo flex bison

# Graphical and Eclipse Plug-In Extras
#RUN apt-get install -y libsdl1.2-dev xterm

# Documentation
#RUN apt-get install -y make xsltproc docbook-utils fop dblatex xmlto

# OpenEmbedded Self-Test
#RUN apt-get install -y python-git

# Extra package for build with NXP's images
#RUN apt-get install -y \
#    sed cvs subversion coreutils texi2html \
#     help2man  gcc g++ \
#    desktop-file-utils libgl1-mesa-dev libglu1-mesa-dev mercurial \
#    autoconf automake groff curl lzop asciidoc u-boot-tools busybox

# Extra package for Xilinx PetaLinux
#RUN apt-get install -y xvfb libtool libncurses5-dev libssl-dev zlib1g-dev:i386 tftpd

# Install repo tool for some bsp case, like NXP's yocto
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo
RUN chmod a+x /usr/bin/repo

# Install Java
#RUN \
#  echo oracle-java11-installer shared/accepted-oracle-license-v1-2 select true | debconf-set-selections && \
#  apt-get install -y software-properties-common && \
#  add-apt-repository -y ppa:linuxuprising/java && \
#  apt-get update && \
#  apt-get install -y oracle-java11-installer-local && \
#  rm -rf /var/lib/apt/lists/* && \
#  rm -rf /var/cache/oracle-jdk11-installer-local

# Set the locale, else yocto will complain
RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Extra package for VLC
RUN apt-get install -y net-tools openssh-server gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 mingw-w64-tools \
  lua5.2 libtool automake autoconf autopoint make gettext pkg-config \
  git subversion cmake cvs wget bzip2 file \
  libwine-dev wine zip p7zip nsis bzip2 \
  yasm ragel ant default-jdk protobuf-compiler dos2unix vim \
  ninja-build gperf python3 libfftw3-3 nasm qtbase5-dev libfuse2 \
  meson gtk-doc-tools python-is-python3 flex bison python3.10-venv \
  texinfo

#RUN apt-get install -y net-tools openssh-server \
#  git wget bzip2 file libwine-dev unzip libtool libtool-bin libltdl-dev pkg-config ant \
#  build-essential automake texinfo ragel yasm p7zip-full autopoint \
#  gettext cmake zip wine nsis g++-mingw-w64-i686 curl gperf flex bison \
#  libcurl4-gnutls-dev python3 python3-setuptools python3-mako python3-requests \
#  gcc make procps ca-certificates \
#  openjdk-11-jdk-headless nasm jq gnupg meson autoconf \
#  gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 mingw-w64-tools \
#  lua5.2 libtool automake autopoint make gettext pkg-config \
#  git subversion cmake cvs \
#  zip p7zip nsis bzip2 \
#  yasm ragel ant default-jdk protobuf-compiler dos2unix vim \
#  ninja-build gperf python3 libfftw3-3 nasm qtbase5-dev libfuse2 \
#  gtk-doc-tools python-is-python3 flex bison python3.10-venv \
#  texinfo

# make /bin/sh symlink to bash instead of dash
# Xilinx's petalinux need this
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# default workdir is /yocto
WORKDIR /yocto

# Add entry point, we use entrypoint.sh to mapping host user to
# container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

