####################
##### TULEAP #######
####################
### VERSION   1.0 ##
####################

## Use the official docker centos distribution ##
FROM centos

## Get some karma ##
MAINTAINER Manuel Vacelet, manuel.vacelet@enalean.com

## Install dependencies ##
RUN yum install -y wget
RUN wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
RUN rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
RUN rpm -i rpmforge-release-0.5.3-1.el6.rf.*.rpm
ADD rpmforge.repo /etc/yum.repos.d/

RUN rpm -i http://mir01.syntis.net/epel/6/i386/epel-release-6-8.noarch.rpm

## Tweak configuration ##
RUN echo "SELINUX=disabled" > /etc/selinux/config

## Deploy Tuleap ##
RUN yum install -y which redhat-lsb-core mysql-server openssh-server

ADD Tuleap.repo /etc/yum.repos.d/
RUN yum install -y tuleap
RUN yum install -y tuleap-plugin-tracker
RUN yum install -y tuleap-theme-experimental
RUN yum install -y tuleap-theme-tuleap	
RUN yum install -y tuleap-core-subversion

# Fix centos defaults
# Cron: http://stackoverflow.com/a/21928878/1528413
RUN sed -i '/session    required   pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/crond
RUN sed -i '/session    required     pam_loginuid.so/c\#session    required     pam_loginuid.so' /etc/pam.d/sshd

RUN /sbin/service sshd start && yum install -y --enablerepo=rpmforge-extras tuleap-plugin-git

RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# Install Tuleap
RUN bash /usr/share/tuleap/tools/setup.sh --sys-default-domain=localhost --sys-org-name=Tuleap --sys-long-org-name=Tuleap

RUN yum -y install supervisor
ADD supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord"]

EXPOSE 22 80 443
