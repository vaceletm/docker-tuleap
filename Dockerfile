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
RUN wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
RUN rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
RUN rpm -i rpmforge-release-0.5.3-1.el6.rf.*.rpm
ADD rpmforge.repo /etc/yum.repos.d/
RUN yum install glibc.i686 openssh-server httpd passwd -y

## Tweak configuration ##
RUN chkconfig iptables off
RUN echo "SELINUX=disabled" > /etc/selinux/config

## Deploy Tuleap ##
ADD Tuleap.repo /etc/yum.repos.d/
RUN service sshd restart && service httpd restart && yum install --enablerepo=rpmforge-extras tuleap-all -y
