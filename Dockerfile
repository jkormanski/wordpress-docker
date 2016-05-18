FROM wordpress:4.5.0

USER root

COPY docker-entrypoint.sh /entrypoint.sh 
ENTRYPOINT ["/entrypoint.sh"] 
CMD ["apache2-foreground"]

#ADD run.sh /run.sh 
#RUN chmod +x /*.sh 
#CMD ["/run.sh"]
