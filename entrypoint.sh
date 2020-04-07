sed -i "s/ASTERISK_HOST/${ASTERISK_HOST}/" /etc/nginx/nginx.conf
cat /etc/nginx/nginx.conf
nginx -g 'daemon off;'
