FROM python:3.8.13-slim-bullseye
LABEL Zouia Alkurdi <aklkurdiz@htw-berlin.de>

# Update system packages
RUN apt update -y && \
    apt upgrade -y && \
    apt dist-upgrade -y

# Install time package
RUN apt install -y \
        tzdata \
        iputils-ping

# Cleanup
RUN apt clean && \
    apt autoremove && \
    rm -rf /var/cache/apk/*

# Install python components
RUN pip3 install --no-cache-dir numpy \ 
                               pandas \
                               scikit-learn \
                               minio \
                               plotly.express

# Create app dir
RUN mkdir app

# Copy data to image
COPY forecast.py /app

# Start forecast
CMD python3 /app/forecast.py && tail -f /dev/null
#CMD tail -f /dev/null