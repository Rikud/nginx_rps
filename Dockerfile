FROM ubuntu:16.04

MAINTAINER Ivan Nemshilov

# Обвновление списка пакетов
RUN apt-get -y update

# install nginx
RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update -y
RUN apt-get install -y nginx
# deamon mode off
RUN echo nginx -V 2>&1 | grep -o with-http_stub_status_module
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN chown -R www-data:www-data /var/lib/nginx
# volume
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/var/log/nginx"]
# expose ports
EXPOSE 80 443
# add nginx conf
RUN rm /etc/nginx/conf.d/default.conf
ADD config/default.conf /etc/nginx/conf.d/default.conf
ADD config/nginx_status.conf /etc/nginx-sp/vhosts.d/APPNAME.d/nginx_status.conf
WORKDIR /etc/nginx
CMD ["nginx"]