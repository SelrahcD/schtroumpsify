FROM phpdockerio/php56-fpm AS base

RUN apt-get update && apt-get install --yes perl libxml-libxml-perl


FROM base AS builder

RUN set -xe         && echo '#!/bin/sh' > /usr/sbin/policy-rc.d     && echo 'exit 101' >> /usr/sbin/policy-rc.d     && chmod +x /usr/sbin/policy-rc.d       && dpkg-divert --local --rename --add /sbin/initctl     && cp -a /usr/sbin/policy-rc.d /sbin/initctl    && sed -i 's/^exit.*/exit 0/' /sbin/initctl         && echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup         && echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean   && echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean   && echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean      && echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages      && echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes       && echo 'Apt::AutoRemove::SuggestsImportant "false";' > /etc/apt/apt.conf.d/docker-autoremove-suggests

RUN rm -rf /var/lib/apt/lists/*

RUN sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list

RUN mkdir -p /run/systemd && echo 'docker' > /run/systemd/container

WORKDIR /app

RUN apt-get update &&  apt-get install --yes build-essential apt-utils &&  apt-get install --yes git  wget  subversion  autotools-dev  autoconf  libxml-libxml-perl libtool  cpanminus pkg-config  python-setuptools curl python-pip

RUN cpanm App::FatPacker AppConfig IPC::Run Variable::Magic Regexp::List XML::Twig XML::Simple DBI DBD::SQLite CGI Text::Scan Devel::Declare IO::All

RUN git clone https://gitlab.inria.fr/almanach/alpi.git . && git checkout alpi_update && perl alpi.builder.pl

RUN ./alpi --pkg=syntax; exit 0 #this command will fail and it is normal

RUN ./alpi && ./alpi --pkg=DepXML && mkdir /root/frmg && cp -r /root/exportbuild/src/frmg/* /root/frmg/ && rm -rf /root/exportbuild/src || cat alpi.log

RUN apt-get remove --purge --yes curl subversion git autotools-dev autoconf libtool cpanminus pkg-config python-setuptools build-essential

WORKDIR /root

EXPOSE 9000

RUN chown www-data /root && mkdir /var/www && chown www-data /var/www

COPY ./index.php /var/html/index.php
