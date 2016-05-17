FROM wordpress:4.5.0

USER root 
ADD run.sh /run.sh 
RUN chmod +x /*.sh 
CMD ["/run.sh"] 
