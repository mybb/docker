FROM unit:php8.2

ARG BUILD_SHA512SUM
ARG BUILD_VERSION

ENV MYBB_VERSION $BUILD_VERSION
ENV MYBB_SHA512 $BUILD_SHA512SUM

RUN set -ex; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libicu-dev \
		libjpeg-dev \
		libmagickwand-dev \
		libmemcached-dev \
		libpng-dev \
		libpq-dev \
		libwebp-dev \
		libzip-dev \
	; \
	\
	docker-php-ext-configure gd \
		--with-freetype \
		--with-jpeg \
		--with-webp \
	; \
	docker-php-ext-install -j "$(nproc)" \
		gd \
		intl \
		mysqli \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		pgsql \
		zip \
	; \
	pecl install igbinary-3.2.14 imagick-3.7.0 memcached-3.2.0 redis-5.3.7; \
	docker-php-ext-enable igbinary imagick memcached redis; \
	rm -r /tmp/pear; \
	\
	out="$(php -r 'exit(0);')"; \
	[ -z "$out" ]; \
	err="$(php -r 'exit(0);' 3>&1 1>&2 2>&3)"; \
	[ -z "$err" ]; \
	\
	extDir="$(php -r 'echo ini_get("extension_dir");')"; \
	[ -d "$extDir" ]; \
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$extDir"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; \
	\
	! { ldd "$extDir"/*.so | grep 'not found'; }; \
	err="$(php --version 3>&1 1>&2 2>&3)"; \
	[ -z "$err" ]

RUN set -ex; \
	curl -o mybb.tar.gz -fSL "https://github.com/mybb/mybb/archive/refs/tags/mybb_${MYBB_VERSION}.tar.gz"; \
	echo "$MYBB_SHA512 *mybb.tar.gz" | sha512sum -c -; \
	tar -xzf mybb.tar.gz -C /usr/src/; \
	rm mybb.tar.gz; \
	chown -R www-data:www-data /usr/src/mybb-mybb_${MYBB_VERSION}

WORKDIR /var/www/html/

COPY mybb.json /docker-entrypoint.d/
COPY docker-entrypoint.sh /docker-entrypoint.d/

CMD ["unitd-debug","--no-daemon","--control","unix:/var/run/control.unit.sock"]
