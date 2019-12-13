#!/bin/bash
# DOCKERPASS=$(openssl rand -base64 32)
# sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
if [ ! -z "$MYSQL_HOST" ]; then
	sed -i "s/^mysql_hostname=localhost$/mysql_hostname=$MYSQL_HOST/g" /root/ispconfig3_install/install/autoinstall.ini
	sed -i "s/^mysql_master_hostname=localhost$/mysql_master_hostname=$MYSQL_HOST/g" /root/ispconfig3_install/install/autoinstall.ini
	
fi

if [ ! -z "$MYSQL_PASSWORD" ]; then
	sed -i "s/^mysql_root_password=pass$/mysql_root_password=$MYSQL_PASSWORD/g" /root/ispconfig3_install/install/autoinstall.ini
fi

if [ ! -z "$MYSQL_PORT" ]; then
	sed -i "s/^mysql_port=3306$/mysql_port=$MYSQL_PORT/g" /root/ispconfig3_install/install/autoinstall.ini
fi

if [ ! -z "$LANGUAGE" ]; then
	sed -i "s/^language=en$/language=$LANGUAGE/g" /root/ispconfig3_install/install/autoinstall.ini
fi
if [ ! -z "$COUNTRY" ]; then
	sed -i "s/^ssl_cert_country=US$/ssl_cert_country=$COUNTRY/g" /root/ispconfig3_install/install/autoinstall.ini
fi
if [ ! -z "$HOSTNAME" ]; then
	sed -i "s/^hostname=server1.example.com$/hostname=$HOSTNAME/g" /root/ispconfig3_install/install/autoinstall.ini
fi
if [ ! -f /usr/local/ispconfig/interface/lib/config.inc.php ]; then
	
	sed -i "s/^hostname=server1.example.com$/hostname=$HOSTNAME/g" /root/ispconfig3_install/install/autoinstall.ini
	# RUN mysqladmin -u root password pass
	service mysql start && php -q /root/ispconfig3_install/install/install.php --autoinstall=/root/ispconfig3_install/install/autoinstall.ini
	mkdir /var/www/html
	echo "" > /var/www/html/index.html
	rm -r /root/ispconfig3_install
fi



screenfetch

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
