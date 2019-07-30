FROM python:latest

ENV PYTHONUNBUFFERED 1

COPY src /opt/src/
COPY docker-reqs.txt /opt/requirements.txt
COPY docker-settings.json /etc/django-settings.json

RUN apt-get update \
        && apt-get install -y libsasl2-dev libldap2-dev \
        && rm -rf /var/lib/apt/lists/*
RUN pip install -r /opt/requirements.txt --index-url https://net07.stats.umanitoba.ca/localpypi/simple
RUN rm -rf /root/.ssh
