FROM fedora

USER root

RUN dnf -y update && dnf clean all
RUN dnf -y install httpd php php-mysql php-gd pwgen supervisor bash-completion openssh-server psmisc tar && dnf clean all
ADD ./start.sh /start.sh
ADD ./foreground.sh /etc/apache2/foreground.sh
ADD ./supervisord.conf /etc/supervisord.conf
RUN echo %sudo	ALL=NOPASSWD: ALL >> /etc/sudoers
ADD http://wordpress.org/latest.tar.gz /wordpress.tar.gz
RUN tar xvzf /wordpress.tar.gz 
RUN mv /wordpress/* /var/www/html/.
RUN adduser $USER apache 
RUN chown -R $USER:apache /var/www 
RUN chmod u=rwX,g=srX,o=rX -R /var/www 
RUN chmod 755 /start.sh
RUN chmod 755 /etc/apache2/foreground.sh
RUN mkdir /var/run/sshd
EXPOSE 80
EXPOSE 22
CMD ["/bin/bash", "/start.sh"]

#ADD run.sh /run.sh 
#RUN chmod +x /*.sh 
#CMD ["/run.sh"]
