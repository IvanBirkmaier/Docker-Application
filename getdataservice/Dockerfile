FROM python:alpine3.15
LABEL Zouia Alkurdi <aklkurdiz@htw-berlin.de>

# Install need packages
RUN apk update && \
    apk upgrade && \
    apk add \
        curl \
        jq \
        bash \
    && rm -rf /var/cache/apk/*

# Create folder for data
RUN mkdir app

# Copy data to image
COPY dax-aktien.txt /app
COPY getData.sh /app

RUN dos2unix /app/dax-aktien.txt

RUN dos2unix /app/getData.sh

# Make scripts runable
RUN chmod 755 /app/getData.sh

CMD ./app/getData.sh	
# CMD tail -f /dev/null