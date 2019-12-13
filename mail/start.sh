#!/bin/bash
# DOCKERPASS=$(openssl rand -base64 32)
# sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
if [ ! -z "$DEFAULT_EMAIL_HOST" ]; then
	sed -i "s/^\(DEFAULT_EMAIL_HOST\) = .*$/\1 = '$MAILMAN_EMAIL_HOST'/g" /etc/mailman/mm_cfg.py
	newlist -q mailman $(MAILMAN_EMAIL) $(MAILMAN_PASS)
	newaliases
fi
if [ ! -z "$LANGUAGE" ]; then
	sed -i "s/^language=en$/language=$LANGUAGE/g" /root/ispconfig3_install/install/autoinstall.ini
fi
if [ ! -z "$COUNTRY" ]; then
	sed -i "s/^ssl_cert_country=AU$/ssl_cert_country=$COUNTRY/g" /root/ispconfig3_install/install/autoinstall.ini
fi
if [ ! -z "$HOSTNAME" ]; then
	sed -i "s/^hostname=server1.example.com$/hostname=$HOSTNAME/g" /root/ispconfig3_install/install/autoinstall.ini
fi
if [ ! -f /usr/local/ispconfig/interface/lib/config.inc.php ]; then
	sed -i "s/^hostname=server1.example.com$/hostname=$HOSTNAME/g" /root/ispconfig3_install/install/autoinstall.ini

	rm -r /root/ispconfig3_install
fi



screenfetch

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
