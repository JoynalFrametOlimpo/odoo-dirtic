# Ticgobi Config and Install Odoo Server
# Author: JoynalFrametOlimpo

DOMINIO=dominio.com
SUBDOMINIOS=*.dominio.com
MAIL=admin@dominio.com

# Date Config
cp /usr/share/zoneinfo/America/Guayaquil /etc/localtime 

# Update and Upgrade
apt-get upgrade
apt-get update

# Install docker and docker-compose
apt-get -y install docker.io
apt-get -y install docker-compose

# Create and stop project
if [ ! -d /opt/odoo ]; then
    docker-compose up -d
    docker-compose stop
fi

# Copy odoo configuration file in new project
if [ ! -f /opt/odoo/conf/odoo.conf ]; then
   cp ./odoo.conf /opt/odoo/conf
fi

# Copy nginx configuration file in new project
if [ ! -f /opt/odoo/nginx/nginx.conf ]; then
   cp ./nginx.conf /opt/odoo/nginx
fi

# Install Certbot
apt-get -y install certbot

# Install certificates

if [ ! -d /etc/letsencrypt/live/$DOMINIO ]; then
   certbot certonly --manual \
   -d $SUBDOMINIOS \
   -d $DOMINIO \
   --preferred-challenges dns-01 \
   --server https://acme-v02.api.letsencrypt.org/directory \
   -m $MAIL
fi

# Copy certificates
if [ ! -d /opt/odoo/certbot/conf/live ]; then
    cp -R /etc/letsencrypt/live/ /opt/odoo/certbot/conf/
   
    rm -f /opt/odoo/certbot/conf/live/$DOMINIO/cert.pem
    cp /etc/letsencrypt/live/$DOMINIO/cert.pem /opt/odoo/certbot/conf/live/$DOMINIO/

    rm -f /opt/odoo/certbot/conf/live/$DOMINIO/chain.pem
    cp /etc/letsencrypt/live/$DOMINIO/chain.pem /opt/odoo/certbot/conf/live/$DOMINIO/

    rm -f /opt/odoo/certbot/conf/live/$DOMINIO/fullchain.pem
    cp /etc/letsencrypt/live/$DOMINIO/fullchain.pem /opt/odoo/certbot/conf/live/$DOMINIO/

    rm -f /opt/odoo/certbot/conf/live/$DOMINIO/privkey.pem
    cp /etc/letsencrypt/live/$DOMINIO/privkey.pem /opt/odoo/certbot/conf/live/$DOMINIO/

    cp ./certbot-conf/options-ssl-nginx.conf /opt/odoo/certbot/conf/
    openssl dhparam -dsaparam -out /opt/odoo/certbot/conf/ssl-dhparams.pem 4096
    echo "Proceder a cambiar contraseñas en .ENV... y configuracion en /opt/odoo/nginx/nginx.conf"
fi
chmod -R 777 /opt/odoo/


