FROM nginx:latest 

RUN apt-get update -q && \ 
    apt-get dist-upgrade -y && \
    apt-get install openssl -y && \
    apt-get clean && \
    apt-get autoclean

ENV SRV_PATH /usr/share/nginx/html

COPY index.html $SRV_PATH/

