FROM debian:latest

MAINTAINER Elias Torres <eltodi@gmail.com>

# Install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
apt-get -y install curl supervisor locales apache2 libapache2-mod-php5 php5-mysql pwgen php-apc php5-mcrypt php5-gd php5-curl php5-xmlrpc php5-intl

# Add image configuration and scripts
ADD start-apache2.sh /start-apache2.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf

# config to enable .htaccess
ADD apache_default /etc/apache2/sites-available/000-default.conf
ADD ports_default /etc/apache2/ports.conf
RUN a2enmod rewrite

#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 30M
ENV PHP_POST_MAX_SIZE 30M


# Configure locales
RUN locale-gen en_US en_US.UTF-8
RUN dpkg-reconfigure locales

RUN adduser --disabled-password --gecos moodle moodleuser

RUN mkdir /var/www/moodledata
RUN chmod 777 /var/www/moodledata

EXPOSE 3000
CMD ["/run.sh"]
