FROM wordpress:4.5.0

#USER root 
#ADD run.sh /run.sh 
#RUN chmod +x /*.sh 
#CMD ["/run.sh"] 

USER root

ADD scripts /scripts
RUN chmod 755 /scripts/*

VOLUME ["/var/www/html/wp-content", "/var/log/httpd"]
EXPOSE 80

CMD ["/bin/bash", "/scripts/start.sh"]

ADD run.sh /run.sh 
RUN chmod +x /*.sh 
CMD ["/run.sh"]
