#Version: 1.3.2
FROM ubuntu:20.04

ENV TZ=America/Sao_Paulo

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update --fix-missing && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update --fix-missing && \
    \
    apt-get install -y --no-install-recommends  \
    build-essential \
    python \
    vim  \
    nginx  \
    curl  \
    composer \
    \
    php7.4 php7.4-cli php7.4-fpm php7.4-dev php7.4-json php7.4-pdo php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring \
    php7.4-curl php7.4-xml php7.4-bcmath php7.4-xdebug && \
    \
    curl -fsSL https://deb.nodesource.com/setup_14.x | bash -  && \
    apt-get install -y nodejs && \
    npm install --global yarn && \
    \
    apt-get clean

ADD ./nginx/sites-available/default /etc/nginx/sites-available/default
ADD ./nginx/snippets /etc/nginx/snippets
ADD ./php/7.4/mods-available/xdebug.ini /etc/php/7.4/mods-available/xdebug.ini
ADD ./php/7.4/fpm/php.ini /etc/php/7.4/fpm/php.ini
ADD ./ioncube/ioncube_loader_lin_7.4.so /usr/lib/php/20190902/ioncube_loader_lin_7.4.so
ADD ./php/7.4/mods-available/ioncube.ini /etc/php/7.4/mods-available/ioncube.ini

RUN ln -s /etc/php/7.4/mods-available/ioncube.ini /etc/php/7.4/fpm/conf.d/10-ioncube.ini

WORKDIR /var/www/html

EXPOSE 80
CMD service php7.4-fpm start && nginx -g 'daemon off;'