FROM ubuntu:18.04


MAINTAINER Ali Modaresi <modaresi.mr@gmail.com> version: 1.0




USER root

### BASICS ###
# Technical Environment Variables
ENV \
	SHELL="/bin/bash" \
	HOME="/root"  \
	USER_GID=0 \
	DEBIAN_FRONTEND=noninteractive \
	SQL_HOST=172.17.1.2:3369 \
	DNS_HOST=172.17.1.3:53 \
	MAIL_HOST=172.17.1.4:
	
	

WORKDIR $HOME



# Layer cleanup script
COPY clean-layer.sh	/usr/bin/clean-layer.sh
COPY fix-permissions.sh	/usr/bin/fix-permissions.sh



RUN \
	
	# --- 0 Update Your Ubuntu Installation
	echo "deb http://de.archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse">>/etc/apt/sources.list && \
	echo "deb http://security.ubuntu.com/ubuntu bionic-security multiverse">>/etc/apt/sources.list && \
	apt-get update && \
	apt-get -y upgrade && \
	
	# Generate and Set locals
	# https://stackoverflow.com/questions/28405902/how-to-set-the-locale-inside-a-debian-ubuntu-docker-container#38553499
	apt-get install -y locales && \
	# install locales-all?
	sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	locale-gen && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8 && \
	
	# --- 1 Preliminary
	apt-get -y install rsyslog rsyslog-relp logrotate supervisor screenfetch &&\
	# Create the log file to be able to run tail
	touch /var/log/cron.log /var/log/auth.log&&\

	# --- 2 Install the SSH server
	apt-get -y install ssh openssh-server rsync &&\

	# --- 3 Install a shell text editor
	apt-get -y install nano vim-nox &&\
	echo "dash	dash/sh boolean no" | debconf-set-selections && dpkg-reconfigure dash &&\
	
	# --- 7 Synchronize the System Clock
	apt-get -y install ntp ntpdate &&\
	
	# https://www.howtoforge.com/tutorial/perfect-server-ubuntu-18-04-nginx-bind-dovecot-and-ispconfig-3/
	
	# --- STEP 4
	#service apparmor stop &&\
	#update-rc.d -f apparmor remove &&\
	#apt-get remove apparmor apparmor-utils &&\
	
	# --- MYSQL CLIENT
	apt-get -y install mysql-client &&\
	# --- NGINX
	apt-get -y install nginx &&\
	service nginx start &&\
	apt-get -y install php7.2-fpm &&\
	apt-get -y install php7.2-mysql &&\
	apt-get -y install fcgiwrap &&\
	apt-get -y install hhvm &&\
	apt-get -y install certbot &&\
	apt-get -y install vlogger webalizer awstats geoip-database libclass-dbi-mysql-perl &&\
	apt-get -y install build-essential autoconf automake libtool flex bison debhelper binutils &&\
	# Install PureFTPd And Quota
	apt-get -y install pure-ftpd-common pure-ftpd-mysql quota quotatool&&\
	#echo 1 > /etc/pure-ftpd/conf/TLS &&\
	#FIREWALL
	apt-get -y install ufw
	
ADD awstats /etc/cron.d/
ADD autoinstall.ini /root/
ADD pure-ftpd-common /etc/default/
ADD supervisord.conf /etc/supervisord/supervisord.conf

RUN \
	# --- 17 Install Jailkit
	cd /tmp &&\
	wget http://olivier.sessink.nl/jailkit/jailkit-2.19.tar.gz &&\
	tar xvfz jailkit-2.19.tar.gz &&\
	cd jailkit-2.19 &&\
	echo 5 > debian/compat &&\
	./debian/rules binary &&\
	cd /tmp &&\
	dpkg -i jailkit_2.19-1_*.deb &&\
	supervisorctl reload
	
	
	# Cleanup
	#chmod a+rwx /usr/bin/clean-layer.sh && \ 
	#chmod a+rwx /usr/bin/fix-permissions.sh






EXPOSE 20/tcp 21/tcp 22/tcp 80/tcp 443/tcp 8080/tcp
