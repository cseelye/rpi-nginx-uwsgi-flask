FROM cseelye/rpi-nginx-base
MAINTAINER Carl Seelye <cseelye@gmail.com>

RUN [ "cross-build-start" ]
RUN apt-get update && \
    apt-get --assume-yes upgrade && \
    apt-get --assume-yes install curl python python-dev build-essential&& \
    curl https://bootstrap.pypa.io/get-pip.py | python && \
    pip install uwsgi && \
    pip install flask_restplus Flask-BasicAuth requests && \
    mkdir --parents /app && \
    apt-get autoremove && \
    apt-get clean && \
    rm --force --recursive /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY uwsgi-common.ini /etc/uwsgi/uwsgi-common.ini
COPY app.conf /etc/nginx/conf.d/app.conf
RUN [ "cross-build-end" ]

WORKDIR /app
CMD ["/usr/bin/supervisord"]
