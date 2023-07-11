FROM python:3.9-slim

ENV DEBIAN_FRONTEND="noninteractive"

SHELL ["/bin/bash", "-c"]

WORKDIR /app

RUN set -eux; \
    apt-get update && \
    apt-get install --no-install-recommends -y mime-support git curl libcurl4-openssl-dev \
      libssl-dev make g++ tzdata xmlsec1 gettext

COPY requirements.txt/ /app/scripts/
COPY requirements.txt/ /app/scripts/test/
RUN dpkg --configure -a

RUN chmod +x /app/scripts/requirements.txt

RUN /app/scripts/requirements.txt --production

RUN apt-get remove --purge -y git libcurl4-openssl-dev libssl-dev make g++ && \
    apt-get autoremove -y && \
    apt-get clean -y 

COPY . /app

RUN echo 'alias pm="python manage.py"' >> ~/.bashrc
RUN echo 'alias d="python manage.py"' >> ~/.bashrc
