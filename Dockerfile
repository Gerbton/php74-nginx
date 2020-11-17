FROM ubuntu:20.04
LABEL maintainer="gerbton@gmail.com"
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update --fix-missing && \
    apt-get install -y \
    nginx \
    php7.4 php7.4-cli php7.4-fpm php7.4-dev php7.4-json php7.4-pdo php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath && \
    pecl install xdebug && \
    apt-get clean

ADD ./nginx/sites-available/default /etc/nginx/sites-available/default
ADD ./nginx/snippets /etc/nginx/snippets
ADD ./php/7.4/mods-available/xdebug.ini /etc/php/7.4/mods-available/xdebug.ini

WORKDIR /var/www/html

EXPOSE 80
CMD service php7.4-fpm start && nginx -g 'daemon off;'
