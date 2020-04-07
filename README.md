Bionova PBX call logs viewer

Local env:
pip3 install virtualenv
virtualenv -p python3 venv
source venv/bin/activate

Docker/Portainer deployment:

>> We use nginx-lets-encrypt companion - so for seamless integration we need pre-create webproxy network
>> #docker network create webproxy --opt encrypted=true

PROD:
1. Copy env.dev file to env.prod. Modife variables inside env.prod
2. Source env file
#source env.prod
3. Run deploy to portainer via deploy.py script
#python deploy.py
