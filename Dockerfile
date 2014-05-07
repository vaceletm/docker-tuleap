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

## Tweak configuration ##
RUN echo "SELINUX=disabled" > /etc/selinux/config

# Fix centos defaults
# Cron: http://stackoverflow.com/a/21928878/1528413
RUN yum install -y cronie; yum clean all
RUN sed -i '/session    required   pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/crond

# Gitolite will not work out-of-the-box with an error like 
# "User gitolite not allowed because account is locked"
# Given http://stackoverflow.com/a/15761971/1528413 you might want to trick
# /etc/shadown but the following pam modification seems to do the trick too
# It's better for as as it can be done before installing gitolite, hence
# creating the user.
# I still not understand why it's needed (just work without comment or tricks
# on a fresh centos install)
RUN yum install -y openssh-server; yum clean all
RUN sed -i '/session    required     pam_loginuid.so/c\#session    required     pam_loginuid.so' /etc/pam.d/sshd

RUN echo "NETWORKING=yes" > /etc/sysconfig/network

ADD vagrant-tuleap /root/vagrant-tuleap

# Install Chef
RUN yum install curl; yum clean all
RUN curl -L https://www.opscode.com/chef/install.sh | bash

RUN /sbin/service sshd start && chef-solo -c /root/vagrant-tuleap/solo/solo.rb -j /root/vagrant-tuleap/solo/rpm.json

# install supervisord
RUN yum install -y python-pip && pip install pip --upgrade
RUN pip install supervisor

ADD supervisord.conf /etc/supervisord.conf

EXPOSE 22 80 443

CMD ["supervisord", "-n"]