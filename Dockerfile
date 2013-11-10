####################
##### TULEAP #######
####################
### VERSION   1.0 ##
####################

## Use the official docker centos distribution ##
FROM centos

## Get some karma ##
MAINTAINER Martin Goyot (Erwyn/Gnouf), martin@piwany.com

## Add the Tuleap Repository to the yum repositories ##
ADD Tuleap.repo /etc/yum.repos.d/

## Install glibc ##
RUN yum install glibc.i686 -y

## Install Tuleap ##
RUN yum install tuleap-all -y
