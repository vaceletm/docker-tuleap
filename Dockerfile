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

RUN rpm -i http://mir01.syntis.net/epel/6/i386/epel-release-6-8.noarch.rpm

#RUN yum install glibc.i686 openssh-server httpd passwd -y

## Tweak configuration ##
RUN chkconfig iptables off
RUN echo "SELINUX=disabled" > /etc/selinux/config

## Deploy Tuleap ##
ADD Tuleap.repo /etc/yum.repos.d/

RUN yum install -y which redhat-lsb-core mysql-server openssh-server
RUN yum install -y --enablerepo=rpmforge-extras tuleap tuleap-plugin-git tuleap-plugin-tracker tuleap-theme-experimental tuleap-core-subversion tuleap-theme-tuleap
RUN echo "NETWORKING=yes" > /etc/sysconfig/network
RUN bash /usr/share/tuleap/tools/setup.sh --sys-default-domain=localhost --sys-org-name=Tuleap --sys-long-org-name=Tuleap

RUN yum -y install supervisor
ADD supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord"]

EXPOSE 22 80 443
