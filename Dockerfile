FROM nginx:alpine

RUN apk update

WORKDIR /

COPY entrypoint.sh entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf

RUN chmod 777 /entrypoint.sh

EXPOSE 80

CMD /entrypoint.sh
