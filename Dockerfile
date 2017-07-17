#
# INFRA-RELAY-PHP CentOS with Web Application Components on Codeship
#
FROM centos:6
MAINTAINER Louie Miranda <lmiranda@gmail.com>

RUN yum -y install epel-release
RUN yum -y install wget
RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
RUN wget https://centos6.iuscommunity.org/ius-release.rpm
RUN rpm -Uvh ius-release*.rpm
RUN yum -y update

# Installing web application components
RUN yum -y install php56u-fpm php56u php56u-opcache php56u-xml php56u-mcrypt php56u-gd php56u-devel php56u-mysql php56u-intl php56u-mbstring php56u-bcmath php56u-pecl-memcache

# Installing mysql
# RUN yum -y install mysql-server mysql-client

# Install MariaDB
RUN echo -e "[mariadb]" >> /etc/yum.repos.d/MariaDB.repo && \
    echo -e "name = MariaDB" >> /etc/yum.repos.d/MariaDB.repo && \
    echo -e "baseurl = http://yum.mariadb.org/10.0/centos6-amd64" >> /etc/yum.repos.d/MariaDB.repo && \
    echo -e "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/MariaDB.repo && \
    echo -e "gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo && \
    yum -y install MariaDB-Galera-server MariaDB-client galera

# Installing nginx 
RUN yum -y install nginx

# Installing compiler, git 
RUN yum -y install git gcc

# Installing other utilities
RUN yum -y install git software-properties-common zip unzip

# Install Composer and make it available in the PATH
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Other configs / timezone, short tags, etc
COPY settings/php.d /etc/php.d

# Adding the configuration file of the nginx
COPY settings/nginx/conf.d /etc/nginx/conf.d
ADD  settings/nginx/nginx.conf /etc/nginx/nginx.conf

CMD ["sh","scripts/start.sh"]