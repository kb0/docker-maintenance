FROM blacklabelops/jobber:latest
MAINTAINER Kirill Bychkov <kb@na.ru>

RUN set -x \
  && apk add --no-cache --update \
         ca-certificates \
		 openssl \
		 wget \
		 unzip \
		 perl \
		 perl-doc \
		 build-base \
		 flex \
		 bison \
		 libxml2-dev \
		 libxslt-dev \
  && rm -rf /var/cache/apk/*

RUN cd /opt \
	&& wget -c https://ftp.postgresql.org/pub/source/v7.4.30/postgresql-7.4.30.tar.gz \
	&& tar -zxvf postgresql-7.4.30.tar.gz \
	&& cd /opt/postgresql-7.4.30 \
	&& ./configure --without-readline \
	&& make \
	&& make -C src/bin install \
	&& make -C src/include install \
	&& make -C src/interfaces install \
	&& make -C doc install

ENV PATH /usr/local/pgsql/bin:$PATH