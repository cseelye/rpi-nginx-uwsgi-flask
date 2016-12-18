FROM resin/rpi-raspbian:jessie-20160831
MAINTAINER Carl Seelye <cseelye@gmail.com>

RUN apt-get update && \
    apt-get upgrade && \
    apt-get -y install curl python python-dev build-essential nginx ca-certificates supervisor && \
    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install uwsgi && \
    pip install flask_restplus Flask-BasicAuth requests && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    rm -f /etc/nginx/conf.d/default.conf && \
    mkdir -p /app && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY uwsgi-common.ini /etc/uwsgi/uwsgi-common.ini
COPY nginx-ssl.conf /etc/nginx/conf.d/nginx-ssl.conf

WORKDIR /app
CMD ["/usr/bin/supervisord"]
