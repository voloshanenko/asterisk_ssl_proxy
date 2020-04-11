Bionova PBX nginx config and cert script (use docker-prxy nginx to serve ACME requests directly to PBX and redirect PBX UCP without external IP

Deployment
1. Copy pbx.voloshanenko.com.conf to nginx-data/conf.d
2. Add next entry to crontab (crontab -e)
0 * * * * cd /home/docker-proxy-companion && /bin/bash get_pbx_certificate.sh > /var/log/get_pbx_certificate.log
3. Add next strings to /etc/rc.local
cd /home/docker-proxy-companion && /bin/bash get_pbx_certificate.sh > /var/log/get_pbx_certificate.log
4. Run script once
# /bin/bash get_pbx_certificate.sh
5. Restart docker-compose
#docker-compose restart
