FROM cseelye/rpi-nginx-uwsgi-flask:latest
MAINTAINER Carl Seelye <cseelye@gmail.com>

COPY mycert.crt /etc/ssl/nginx.crt
COPY mycert.key /etc/ssl/nginx.key
COPY exampleapp /app
RUN pip install -U -r /app/requirements.txt
