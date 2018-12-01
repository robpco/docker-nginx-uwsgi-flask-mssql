FROM python:3.6-stretch

ENV NGINX_VERSION 1.15.7-1~stretch

# use multiple key servers to protect against build failure
RUN set -x && \
    curl -O https://nginx.org/keys/nginx_signing.key && apt-key add ./nginx_signing.key; \
    echo "deb http://nginx.org/packages/mainline/debian/ stretch nginx" >> /etc/apt/sources.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates \
    nginx=${NGINX_VERSION} \
    gettext-base \
    supervisor \
    apt-transport-https \
    apt-utils \
    locales

# Install Official Microsoft SQL Server Driver and ODBC
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y DEBIAN_FRONTEND=noninteractive apt-get install -y \
    msodbcsql17 \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/* \
    # Adjust Locales to prevemt MS SQL Driver error
    && touch /usr/share/locale/locale.alias \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen

# Install Python libraries
RUN pip install --no-cache-dir --disable-pip-version-check \
    uwsgi \
    flask \
    pyodbc

# setup log files
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# setup and copy config files
RUN rm /etc/nginx/conf.d/default.conf && \
    echo "daemon off;" >> /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/conf.d/
COPY uwsgi.ini /etc/uwsgi/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# set ENV variables and expose ports
ENV UWSGI_INI /app/uwsgi.ini
# Enable unlimited filesize uploads (restore nginx default by setting to 1m)
ENV NGINX_MAX_UPLOAD 0
# Enable changing default Nginx port
ENV LISTEN_PORT 80
# EXPOSE 80 443
EXPOSE 80

# Enable serving static files directly by Nginx
# Top-level URL where requests for static files originate
ENV STATIC_URL /static
# Container location of Static Files (absolute path)
ENV STATIC_PATH /app/static
# Specify "ENV STATIC_INDEX 1" to serve '/' directly from /static/index.html (or the static URL configured)
ENV STATIC_INDEX 0

# setup entrypoint.sh which generates Nginx configs at runtime
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

COPY ./app /app
WORKDIR /app

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
