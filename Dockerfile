FROM wordpress:4.5.0

USER root

ADD scripts /scripts
RUN curl -LO http://wordpress.org/latest.tar.gz                   && \
    tar xvzf /latest.tar.gz -C /var/www/html --strip-components=1 && \
    rm /latest.tar.gz                                             && \
    chmod 755 /scripts/*

VOLUME ["/var/www/html/wp-content", "/var/log/httpd"]
EXPOSE 80

CMD ["/bin/bash", "/scripts/start.sh"]

ADD run.sh /run.sh 
RUN chmod +x /*.sh 
CMD ["/run.sh"]
