# rpi-nginx-uwsgi-flask
Docker container for hosting python Flask/Flask-RESTPlus apps on Raspberry Pi using nginx and uWSGI.  
* Only python 2.7 is installed; if you want python 3 you will need to add it.
* nginx is only set up to serve SSL on port 443; if you want insecure serving look elsewhere.

### Building on Raspberri Pi
This image is set up for building on an x86_64 machine or automated building on dockerhub, so it will not build out of the box on a Raspberry Pi! Use these commands to backup the dockerfile and then modify it to build on a Pi:

```Shell
cp Dockerfile Dockerfile.x86_64
sed -e 's|FROM.*|FROM resin/rpi-raspbian:jessie-20160831|' -e '/cross-build/d' -i Dockerfile
```

## Usage

This container is not meaningful on its own; it needs to have your Flask app installed in it.  See the example directory for a fully working sample.

To create a container for your Flask app:

1. Create a ```uwsgi-app.ini``` in your application directory with the name of the module and app variable. For instance, a ```main.py``` with the Flask instance named ```app``` would mean the ini file would contain this:

    ```ini
    [uwsgi]
    module = main
    callable = app
    ```

2. Create an SSL certificate for nginx to use, or if you already have one copy it into the docker build directory. [DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04) has an excellent tutorial if you need more help.

    ```
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout mycert.key -out mycert.crt
    ```

3. Make sure your application prerequisites are saved in a standard ```requirements.txt``` in your application directory.

4. Copy your application directory to a subdirectory of the docker build directory.  

5. Create a Dockerfile to build a container from this one, with your app and SSL certificate:

    ```Dockerfile
    FROM cseelye/rpi-nginx-uwsgi-flask:latest
    COPY mycert.crt /etc/ssl/nginx.crt
    COPY mycert.key /etc/ssl/nginx.key
    COPY myappdirectory /app
    RUN pip install -U -r /app/requirements.txt
    ```

6. Build and run your container, forwarding the container port 443 to wherever you want it on your container host. For instance, to forward to port 4343:

    ```Shell
    docker build -t myapp .  
    docker run -p 4343:443 myapp
    ```

Now if you visit https://hostIP:4343/ in your browser you should see your Flask app.
