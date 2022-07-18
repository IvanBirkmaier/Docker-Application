FROM nginx:1.21.6-alpine
LABEL Zouia Alkurdi <aklkurdiz@htw-berlin.de>
COPY default.conf /etc/nginx/conf.d/
COPY index.html /usr/share/nginx/html
COPY style.css /usr/share/nginx/html
COPY forecast.js /usr/share/nginx/html
COPY forecast.html /usr/share/nginx/html
COPY scraper.html /usr/share/nginx/html
COPY index.css /usr/share/nginx/html
COPY scraper.js /usr/share/nginx/html


RUN apk add --upgrade apk-tools && \
 apk update && \
 apk upgrade --available && \
 rm -rf /var/cache/apk/*
RUN chgrp -R 0 \
 /var/cache/nginx \
 /var/run \
 /usr/lib/nginx/ \
 /etc/nginx \
 /var/log/nginx && \
 chmod -R g=u \
 /var/cache/nginx \
 /var/run \
 /usr/lib/nginx/ \
 /etc/nginx \
 /var/log/nginx \
 /etc/passwd
USER 1001
CMD ["nginx", "-g", "daemon off;"]