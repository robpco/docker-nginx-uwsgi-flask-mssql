# Supported tags and `Dockerfile` links

- `py2.7`, `python2.7` [_(python2.7/Dockerfile)_](https://github.com/robertpeteuil/docker-nginx-uwsgi-flask-mssql/blob/master/python2.7/Dockerfile)
- `py3.6`, `python3.6` [_(python3.6/Dockerfile)_](https://github.com/robertpeteuil/docker-nginx-uwsgi-flask-mssql/blob/master/python3.6/Dockerfile)

**You must explicitly use one of the tags above.**  The `latest` tag is not assigned since each tag represents a different variant, not an incremental version.

## NGINX-UWSGI-FLASK-MSSQL

**Docker** image for Python Apps with **Nginx**, **uWSGI**, **Flask**, **MS SQL Driver** and **pyodbc** running in a single container to enable Python Flask Web Apps that require MS SQL connectivity and scaling for production with Nginx.

**GitHub Repo**: <https://github.com/robertpeteuil/docker-nginx-uwsgi-flask-mssql>

**Docker Hub Images**: <https://hub.docker.com/r/robpco/nginx-uwsgi-flask-mssql/>

## Overview

This Docker image allow the creation of Python Web Apps with MS SQL connectivity to run on Nginx via uWSGI. It simplifies the task of using Flask Web Apps with MS SQL and serves web requests via Nginx which is recommended for production deployment.  These images use `pythonx.x-stretch` images as the base, so additional packages are installed from Debian stretch.

- This image is similar to my [nginx-uwsgi-flask](https://github.com/robertpeteuil/docker-nginx-uwsgi-flask) image but also includes the MS SQL Driver, unixODBC Driver and pyodbc library installed.
- Installing the MS Sql Driver in a container can be difficult as it requires installation from a specific Microsoft repository. installing and configuring `locales` with a specific configuration.

This repo auto-generates images to [Docker-Hub](https://hub.docker.com/r/robpco/nginx-uwsgi-flask-mssql/).  It currently supports Python 2.7 and 3.6.

## Usage

Basic usage information is provided below.

### Run a local application using the container

This is useful during development as you can edit the code on your local machine.

``` shell
docker run --name webapp -d -p 8080:80 -v ./app:/app robpco/nginx-uwsgi-flask-mssql:python2.7
```

- The name of your application should be `main.py`
- The folder containing it must be mapped to `/app` folder in the container.
- The default filename can be changed by creating a custom [`uwsgi.ini`](https://github.com/robertpeteuil/docker-nginx-uwsgi-flask-mssql/blob/master/python2.7/app/uwsgi.ini) file
  - place it into the folder containing the application.

### Create an image for your **Flask Web-App** using this image as a base

In this example, the app directory contains the application, named `main.py`, and any python library requirements are stated inside the `requirements.txt` file included in the app directory.

``` Dockerfile
FROM robpco/nginx-uwsgi-flask-mssql:python2.7

COPY ./app /app
WORKDIR /app

RUN pip install -r requirements.txt
```

## Custom Environment Variables

This image can be customized by setting the following custom environment variables:

The variables that begin with `STATIC_` allow configuring Nginx to relay "static content" directly without going through uWSGI or Flask.  This is advantageous for basic HTML pages, css and js files, that don't need their output adjusted by your Flask App.

- **STATIC_INDEX** - serve '/' directly from `/app/static/index.html`
  - 0 = disabled (default)
  - 1 = enabled - the file `index.html` located in the `/app/static` directory (in the container) will be forwarded to any requests to the root of your server (`/`) will
- **STATIC_URL** - external URL where requests for static files originate
- **STATIC_PATH** - container location of static files (absolute path)
- **UWSGI_INI** - the path and file of the configuration info
  - default: `/app/uwsgi.ini`
- **NGINX_MAX_UPLOAD** - the maximum file upload size allowed by Nginx
  - 0 = unlimited (image default)
  - 1m = normal Nginx default
- **LISTEN_PORT** - custom port that Nginx should listen on
  - 80 = Nginx default

## Setting Environment Variables

Environment variables can be set in multiple ways.  The following examples, demonstrate setting the `LISTEN_PORT` environment variable via three different methods.  These methods apply to the other Environment Variables as well.

### Setting in a `Dockerfile`

```dockerfile
# ... (snip) ...
ENV LISTEN_PORT 8080
# ... (snip) ...
```

### Setting during [`docker run`](https://docs.docker.com/engine/reference/commandline/run/#options) with the `-e` option

```shell
docker run -e LISTEN_PORT=8080 -p 8080:8080 myimage
```

### Setting in `docker-compose` file using the `environment:` keyword in a `docker-compose` file

```yml
version: '2.2'
services:
  web:
    image: myapp
  environment:
    LISTEN_PORT: 8080
```
