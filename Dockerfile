FROM cseelye/rpi-raspbian-cross
MAINTAINER Carl Seelye <cseelye@gmail.com>

RUN [ "cross-build-start" ]
RUN apt-get update && \
    apt-get --assume-yes upgrade && \
    apt-get --assume-yes install curl python python-dev build-essential nginx ca-certificates supervisor && \
    curl https://bootstrap.pypa.io/get-pip.py | python && \
    pip install uwsgi && \
    pip install flask_restplus Flask-BasicAuth requests && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    rm --force /etc/nginx/conf.d/default.conf && \
    mkdir --parents /app && \
    rm --force --recursive /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY uwsgi-common.ini /etc/uwsgi/uwsgi-common.ini
COPY nginx-ssl.conf /etc/nginx/conf.d/nginx-ssl.conf
RUN [ "cross-build-end" ]

WORKDIR /app
CMD ["/usr/bin/supervisord"]
