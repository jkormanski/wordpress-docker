FROM wordpress:4.5.0
#FROM php:5.6-apache

USER root

ENV HOME /var/www/html
VOLUME /var/www/html/wp-content

RUN a2enmod rewrite expires

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
 	&& docker-php-ext-install gd mysqli opcache

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

ENV WORDPRESS_VERSION 4.5.2
ENV WORDPRESS_SHA1 bab94003a5d2285f6ae76407e7b1bbb75382c36e

#ADD http://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz /wordpress.tar.gz
#RUN tar -xzf /wordpress.tar.gz --strip-components=1 -C /opt/app-root/wordpress 
#RUN tar xzvf /wordpress.tar.gz 

RUN cd /tmp && curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
    && mkdir -p /var/www/html/wordpress \
    && echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
    && tar -xzf wordpress.tar.gz --strip-components=1 -C /var/www/html/wordpress \
    && rm wordpress.tar.gz \
  && fix-permissions /var/www/html/wordpress \
    && fix-permissions /var/www/html/wp-content && chmod -R 0777 /var/www/html/wp-content



#RUN mv /usr/src/wordpress/* /var/www/html/
RUN chown -R $USER:www-data /var/www/html

EXPOSE 80
EXPOSE 22

ADD ./docker-entrypoint.sh /entrypoint.sh
#COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# grr, ENTRYPOINT resets CMD now
#CMD ["/bin/bash", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]

ADD run.sh /run.sh 
RUN chmod +x /*.sh 
CMD ["/run.sh"]

USER 1001
