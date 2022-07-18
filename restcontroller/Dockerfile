FROM python:3.8.13-slim-bullseye
LABEL Ivan Birkmaier <s0574204@htw-berlin.de>
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
RUN pip3 install --no-cache-dir fastapi \
                                pydantic \
                                uvicorn \
                                snscrape  \ 
                                pandas \
                                fastapi.responses
# Create app dir
RUN mkdir app

COPY controller.py /app                        


CMD ["uvicorn", "app.controller:app", "--host", "0.0.0.0", "--port", "12345"]


