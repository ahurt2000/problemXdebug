FROM debian:latest

RUN usermod --non-unique --uid 1000 www-data
RUN groupmod --non-unique --gid 1000 www-data

RUN apt-get update \
    && apt-get -y install apt-utils apache2

RUN rm /etc/apache2/sites-enabled/*

ENV VIRTUALHOST localhost

ADD conf-available /etc/apache2/conf-available

ADD apache.sh /usr/bin/apache.sh
RUN chmod +x /usr/bin/apache.sh
ENTRYPOINT apache.sh