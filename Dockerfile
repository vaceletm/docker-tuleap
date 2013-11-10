####################
##### TULEAP #######
####################
### VERSION   1.0 ##
####################

## Use the official docker centos distribution ##
FROM centos

## Get some karma ##
MAINTAINER Martin Goyot (Erwyn/Gnouf), martin@piwany.com

## Install dependencies ##
RUN yum install glibc.i686 openssh-server httpd passwd -y

## Tweak configuration ##
RUN echo "SELINUX=disabled" > /etc/selinux/config

## Deploy Tuleap ##
ADD Tuleap.repo /etc/yum.repos.d/
RUN service sshd restart && service httpd restart && yum install tuleap-all -y
