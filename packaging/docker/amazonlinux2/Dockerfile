##############################################################################
##                                                                          ##
##    RPM Build Dockerfile: CentOS 7 Base image                             ##
##                                                                          ##
##    Purpose:                                                              ##
##       Build container for rpm package assembly                           ##
##                                                                          ##
##    Dependencies:  file list                                              ##
##      - bashrc                          - colors.sh                       ##
##      - .rpmmacros                      - motd-centos.sh                  ##
##      - docker-buildrpm.sh                                                ##
##                                                                          ##
##    Originally written by:                                                ##
##       "Blake Huber" <blakeca00@@gmail.com>                               ##
##                                                                          ##
##############################################################################

FROM amazonlinux:2
MAINTAINER Amazon AWS

RUN yum -y update; yum clean all
RUN yum -y groups mark convert
RUN yum -y groupinstall "Development Tools"
RUN yum -y install wget

RUN yum install -y gcc gcc-c++ \
                   libtool libtool-ltdl \
                   make cmake \
                   git vim \
                   pkgconfig which \
                   sudo man-pages shadow-utils \
                   automake autoconf \
                   yum-utils  && \
    yum clean all
RUN yum -y install rpm-build rpmdevtools

RUN useradd builder -d /home/builder -u 1000 -m -G users,wheel && \
    echo "# macros"                      >  /home/builder/.rpmmacros && \
    echo "%_topdir    /home/builder/rpmbuild" >> /home/builder/.rpmmacros && \
    echo "%_sourcedir %{_topdir}"        >> /home/builder/.rpmmacros && \
    echo "%_builddir  %{_topdir}"        >> /home/builder/.rpmmacros && \
    echo "%_specdir   %{_topdir}"        >> /home/builder/.rpmmacros && \
    echo "%_rpmdir    %{_topdir}"        >> /home/builder/.rpmmacros && \
    echo "%_srcrpmdir %{_topdir}"        >> /home/builder/.rpmmacros

# epel repository
#RUN wget -O epel.rpm –nv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#RUN yum -y install epel.rpm
#RUN yum -y install figlet
RUN yum -y update; yum clean all

# mount volume here to cp completed rpm to on the host
RUN mkdir /mnt/rpm
VOLUME /mnt/rpm

# configure sudoers
RUN sed -i '/Defaults    secure_path/d' /etc/sudoers
RUN echo "builder ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

# rpmbuild deps
RUN cd && rpmdev-setuptree
RUN mv ~/rpmbuild /home/builder/

ADD ./bashrc  /home/builder/.bashrc
ADD ./.rpmmacros /home/builder/
ADD ./docker-buildrpm.sh /home/builder/

RUN chown -R builder /home/builder

EXPOSE 8080

USER builder

# configure home for builder
RUN mkdir -p /home/builder/.config/bash
ADD ./colors.sh /home/builder/.config/bash/
ADD ./motd-amazonlinux2.sh /home/builder/.config/bash/motd.sh

# environment variables
ENV CONTAINER=rpmbuild OS=centos DIST=el7

##

# end rpm build Dockerfile
