FROM alpine:3.5
MAINTAINER Pan Jiabang <panjiabang@gmail.com>

RUN apk --update --no-cache add python3 nginx curl git tzdata rsync ruby\
    php7 php7-fpm php7-ctype php7-curl php7-dom \
    php7-gd php7-iconv php7-json php7-mcrypt php7-openssl \
    php7-posix php7-sockets php7-xml php7-xmlreader \
    php7-zip php7-mbstring php7-session php7-opcache php7-phar \
    && pip3 install -U pip \
    && pip3 install --no-cache-dir envtpl chaperone \
    && echo 'gem: --no-document' >> ~/.gemrc \
    && gem install sass \
    && gem sources -c

ENV TZ=Asia/Shanghai

COPY bin/composer.phar /usr/local/bin/composer
RUN ln -s /usr/bin/php7 /usr/bin/php && chmod a+x /usr/local/bin/composer

COPY composer.json /var/www/html/
COPY composer.lock /var/www/html/
WORKDIR /var/www/html/
RUN composer install --no-dev -o

COPY mod/config/chaperone.conf /etc/chaperone.d/chaperone.conf
COPY mod/config/nginx.conf /etc/nginx/nginx.conf.tpl
COPY mod/config/fpm-pool.conf /etc/php7/php-fpm.d/grav.conf
COPY mod/config/www.conf /etc/php7/php-fpm.d/www.conf
COPY mod/config/php.ini /etc/php7/conf.d/grav.ini

COPY . /var/www/html/

EXPOSE 80

CMD ["/usr/bin/chaperone"]
