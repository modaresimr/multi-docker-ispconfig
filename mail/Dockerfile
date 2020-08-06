FROM tvial/docker-mailserver:latest
#https://github.com/tomav/docker-mailserver

MAINTAINER Ali Modaresi <modaresi.mr@gmail.com> version: 1.0


RUN \
	apt-get update -q --fix-missing && \
	apt-get -y install --no-install-recommends \
		wget php-cli php-mysql php-xml php-mbstring 

RUN \
	cd /root &&\
	wget -O ispconfig.tar.gz https://git.ispconfig.org/ispconfig/ispconfig3/repository/archive.tar.gz?ref=stable-3.1 &&\
	tar xfz ispconfig.tar.gz &&\
	mv ispconfig3* ispconfig3_install 

ADD ./start.sh /start.sh
ADD ./autoinstall.ini /root/ispconfig3_install/install/autoinstall.ini

	

EXPOSE 25 587 143 465 993 110 995 4190

CMD ["/bin/bash", "/start.sh"]

