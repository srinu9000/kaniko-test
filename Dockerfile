FROM python:3.9-slim

ENV DEBIAN_FRONTEND="noninteractive"

SHELL ["/bin/bash", "-c"]

WORKDIR /app
#RUN dpkg --configure -a
#RUN apt-get update
RUN dpkg --add-architecture arm64

RUN apt-get update && \
    apt-get install --no-install-recommends -y 
    apt-get install mime-support git curl libcurl4-openssl-dev libssl-dev make g++ procps tzdata xmlsec1 -y
    
COPY requirements.txt/ /app/scripts/
COPY requirements.txt/ /app/scripts/test/

RUN chmod +x /app/scripts/requirements.txt

RUN /app/scripts/requirements.txt --production

RUN apt-get remove --purge -y git libcurl4-openssl-dev libssl-dev make g++ && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /root/.cache

COPY . /app

RUN echo 'alias pm="python manage.py"' >> ~/.bashrc
RUN echo 'alias d="python manage.py"' >> ~/.bashrc
