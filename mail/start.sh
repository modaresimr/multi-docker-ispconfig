#!/bin/bash
# DOCKERPASS=$(openssl rand -base64 32)
# sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

if [ ! -f /usr/local/ispconfig/interface/lib/config.inc.php ]; then
	if [ ! -z "$DEFAULT_EMAIL_HOST" ]; then
		sed -i "s/^\(DEFAULT_EMAIL_HOST\) = .*$/\1 = '$MAILMAN_EMAIL_HOST'/g" /etc/mailman/mm_cfg.py
		newlist -q mailman $(MAILMAN_EMAIL) $(MAILMAN_PASS)
		newaliases
	fi

	if [ ! -z "$MYSQL_HOST" ]; then
		sed -i "s/^mysql_hostname=localhost$/mysql_hostname=$MYSQL_HOST/g" /root/ispconfig3_install/install/autoinstall.ini
		sed -i "s/^mysql_master_hostname=localhost$/mysql_master_hostname=$MYSQL_HOST/g" /root/ispconfig3_install/install/autoinstall.ini
	fi

	if [ ! -z "$MYSQL_PASSWORD" ]; then
		sed -i "s/^mysql_root_password=pass$/mysql_root_password=$MYSQL_PASSWORD/g" /root/ispconfig3_install/install/autoinstall.ini
		sed -i "s/^mysql_master_root_password=pass$/mysql_master_root_password=$MYSQL_PASSWORD/g" /root/ispconfig3_install/install/autoinstall.ini
	fi

	if [ ! -z "$MYSQL_PORT" ]; then
		sed -i "s/^mysql_port=3306$/mysql_port=$MYSQL_PORT/g" /root/ispconfig3_install/install/autoinstall.ini
		sed -i "s/^mysql_master_port=3306$/mysql_master_port=$MYSQL_PORT/g" /root/ispconfig3_install/install/autoinstall.ini
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

	sed -i "s/^hostname=server1.example.com$/hostname=$HOSTNAME/g" /root/ispconfig3_install/install/autoinstall.ini
	# RUN mysqladmin -u root password pass
	php -q /root/ispconfig3_install/install/install.php --autoinstall=/root/ispconfig3_install/install/autoinstall.ini
	
	mysql -h $MYSQL_HOST -uroot -p${MYSQL_PASSWORD} -e "update mysql.user set Host='%' where user='ispconfig';"&&\
	mysql -h $MYSQL_HOST -uroot -p${MYSQL_PASSWORD} -e "update mysql.db set Host='%' where db='dbispconfig';"&&\
	mysql -h $MYSQL_HOST -uroot -p${MYSQL_PASSWORD} -e "FLUSH PRIVILEGES;"
	
	#rm -r /root/ispconfig3_install
fi



screenfetch

service supervisor stop
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

tail -f /var/log/nginx/* /var/log/php7.2-fpm.log /var/log/auth.log /var/log/cron.log