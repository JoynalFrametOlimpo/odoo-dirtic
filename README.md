# odoo-compose
Odoo+Docker+Postgreql+Pgadmin+wdb+Nginx+Certbot+letsecrypt

# Clonar el proyecto
git clone

# install Letscrypt certificate
apt-get install certbot

# create certificate
certbot certonly --standalone -d dominio.com

# copy certificates a /opt/odoo/certbot/conf/live/dominio.com/
cp /etc/letscrypt/live/dominio/fulchaim.pem
cp /etc/letscrypt/live/dominio/privkey.pem

cp odoo.conf /opt/odoo/conf

docker-compose up -d
