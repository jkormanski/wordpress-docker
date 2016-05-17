FROM wordpress:4.5.0

USER root

ENV WORDPRESS_SHA1 9bf09e0ca8f656b650b3056339e2d3eb28c6355e
ENV WORDPRESS_VERSION 4.5.1

ADD scripts /scripts

RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
	&& echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
	&& tar -xzf wordpress.tar.gz -C /var/www/html \
	&& rm wordpress.tar.gz \
	&& chmod 755 /scripts/*

VOLUME ["/var/www/html/wp-content", "/var/log/httpd"]
EXPOSE 80

CMD ["/bin/bash", "/scripts/start.sh"]

ADD run.sh /run.sh 
RUN chmod +x /*.sh 
CMD ["/run.sh"]
