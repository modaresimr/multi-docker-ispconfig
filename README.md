# multi-docker-ispconfig
A very simple docker compose file for deploying ispconfig. It has a container for mail, one for database and one for webserver, ssl and ftp server

# Usage
`
Please edit db.env, mail.env and web.env
docker-compose up -d
`

# Features
## WEB
It is base on https://www.howtoforge.com/tutorial/perfect-server-ubuntu-18-04-nginx-bind-dovecot-and-ispconfig-3/
## MAIL
Please edit mail/env-mailserver
Docker image is base on github.com/tomav/docker-mailserver/
## DNS (TODO)


# config
Please edit db.env, mail.env and web.env

