#!/bin/bash
# DOCKERPASS=$(openssl rand -base64 32)

if [ ! -f /usr/local/ispconfig/interface/lib/config.inc.php ]; then
        # Fix issue for connecting from remote my sql server
	sed -i 's/from_host = $'"conf\['hostname'\]/from_host = '%'/g" /root/ispconfig3_install/install/lib/installer_base.lib.php
        while ! mysqladmin ping -h"$MYSQL_HOST" --silent; do
                echo waiting for mysql at $MYSQL_HOST
                sleep 1
        done

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
	rndpass=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 ; echo ''`
        sed -i "s/^mysql_ispconfig_password=pass$/mysql_ispconfig_password=$rndpass/g" /root/ispconfig3_install/install/autoinstall.ini
	if [ ! -z "$MYSQL_PORT" ]; then
		sed -i "s/^mysql_port=3306$/mysql_port=$MYSQL_PORT/g" /root/ispconfig3_install/install/autoinstall.ini
		sed -i "s/^mysql_master_port=3306$/mysql_master_port=$MYSQL_PORT/g" /root/ispconfig3_install/install/autoinstall.ini
	fi

	if [ ! -z "$LANGUAGE" ]; then
		sed -i "s/^language=en$/language=$LANGUAGE/g" /root/ispconfig3_install/install/autoinstall.ini
	fi

	if [ ! -z "$HOSTNAME" ]; then
		sed -i "s/^hostname=server1.example.com$/hostname=$HOSTNAME.$DOMAINNAME/g" /root/ispconfig3_install/install/autoinstall.ini
	fi

	# RUN mysqladmin -u root password pass
	php -q /root/ispconfig3_install/install/install.php --autoinstall=/root/ispconfig3_install/install/autoinstall.ini
	
	#rm -r /root/ispconfig3_install
fi



#screenfetch

service supervisor stop
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

