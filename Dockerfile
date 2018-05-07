FROM debian:stretch-slim

MAINTAINER blueapple <blueapple1120@qq.com>

RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        ca-certificates build-essential wget libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev unzip uuid-dev \
	&& apt-get clean all \
	&& cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&& apt-get install -y http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm \
	&& apt-get install -y https://extras.getpagespeed.com/redhat/7/noarch/RPMS/getpagespeed-extras-7-0.el7.gps.noarch.rpm \
	&& apt-get install -y nginx \
	&& apt-get install -y nginx-module-nps \
	&& rm -rf /tmp/* \
	# Forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

COPY ./conf.d /etc/nginx/conf.d
COPY ./nginx.conf /etc/nginx/nginx.conf

VOLUME ["/var/cache/ngx_pagespeed"]
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
