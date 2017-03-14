#!/usr/bin/env bash

###环境安装脚本
 
### create user/group
sudo useradd -g vagrant work


### cc environment
sudo yum -y install gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers pcre-devel zlib-devel gd-devel libjped-devel libpng-devel freetype-devel libxml2-devel curl-devel libacl-devel libc-client-devel libicu-devel libmcrypt-devel 
 
#######################################
###              tengine            ###
#######################################
cd /usr/local/src
wget http://tengine.taobao.org/download/tengine-2.1.2.tar.gz
tar zxvf tengine-2.1.2.tar.gz
cd tengine-2.1.2
./configure \
    --prefix=/srv/nginx \
    --user=work \
    --group=work \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-http_slice_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-file-aio \
    --with-http_v2_module \
    --with-ipv6 \
sudo make
sudo make install

######################################
###              php               ###
######################################

#安装libiconv扩展
cd /usr/local/src
wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz
tar -zxvf libiconv-1.14.tar.gz
cd libiconv-1.14
./configure --prefix=/usr/local/
make && make install

#安装libmcrypt扩展
cd /usr/local/src
wget http://downloads.sourceforge.net/mcrypt/libmcrypt-2.5.8.tar.gz
tar -zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure --prefix=/usr/local/libmcrypt
make && make install

#安装mhash扩展
cd /usr/local/src
wget http://downloads.sourceforge.net/mhash/mhash-0.9.9.9.tar.gz
tar -zxvf mhash-0.9.9.9.tar.gz
cd mhash-0.9.9.9
./configure --prefix=/usr/local/mhash
make
make install

#加载软连接,类库的路径要与上面的对应
ln -s /usr/local/libmcrypt/lib/libmcrypt.la /usr/lib64/libmcrypt.la
ln -s /usr/local/libmcrypt/lib/libmcrypt.so /usr/lib64/libmcrypt.so
ln -s /usr/local/libmcrypt/lib/libmcrypt.so.4 /usr/lib64/libmcrypt.so.4
ln -s /usr/local/libmcrypt/lib/libmcrypt.so.4.4.8 /usr/lib64/libmcrypt.so.4.4.8
ln -s /usr/local/mhash/lib/libmhash.a /usr/lib64/libmhash.a
ln -s /usr/local/mhash/lib/libmhash.la /usr/lib64/libmhash.la
ln -s /usr/local/mhash/lib/libmhash.so /usr/lib64/libmhash.so
ln -s /usr/local/mhash/lib/libmhash.so.2 /usr/lib64/libmhash.so.2
ln -s /usr/local/mhash/lib/libmhash.so.2.0.1 /usr/lib64/libmhash.so.2.0.1
ln -s /usr/local/libmcrypt/bin/libmcrypt-config /usr/bin/libmcrypt-config

#安装mcrypt扩展
cd /usr/local/src
wget http://downloads.sourceforge.net/mcrypt/mcrypt-2.6.8.tar.gz
tar -zxvf mcrypt-2.6.8.tar.gz
cd mcrypt-2.6.8
LD_LIBRARY_PATH=/usr/local/lib
export LD_LIBRARY_PATH=/usr/local/libmcrypt/lib:/usr/local/mhash/lib
export LDFLAGS="-L/usr/local/mhash/lib/ -I/usr/local/mhash/include/"
export CFLAGS="-I/usr/local/mhash/include/"
/sbin/ldconfig
./configure --prefix=/usr/local/mcrypt/ --with-libmcrypt-prefix=/usr/local/libmcrypt
make
make install

#安装imap的依赖
cd /usr/local/src
wget ftp://ftp.cac.washington.edu/imap/imap-2007f.tar.gz
tar -zxvf imap-2007f.tar.gz
cd imap-2007f
make lr5 PASSWDTYPE=std SSLTYPE=unix.nopwd IP6=4
echo "set disable-plaintext nil" > /etc/c-client.cf
mkdir /usr/local/imap-2007f
mkdir /usr/local/imap-2007f/include/
mkdir /usr/local/imap-2007f/lib/
chmod -R 077 /usr/local/imap-2007f
rm -rf /usr/local/imap-2007f/include/*
rm -rf /usr/local/imap-2007f/lib/*
cp imapd/imapd /usr/sbin/
cp c-client/*.h /usr/local/imap-2007f/include/
cp c-client/*.c /usr/local/imap-2007f/lib/
cp c-client/c-client.a /usr/local/imap-2007f/lib/libc-client.a



#增加软连接，防止出现这个错误 make: *** [ext/phar/phar.php] Error 127
ln -s /usr/local/lib/libiconv.so /usr/bin/libiconv.so
ln -s /usr/local/lib/libiconv.so.2 /usr/bin/libiconv.so.2
ln -s /usr/local/mysql/lib/libmysqlclient.so /usr/lib64/libmysqlclient.so
ln -s /usr/local/mysql/lib/libmysqlclient.so.18 /usr/lib64/libmysqlclient.so.18
ln -s /usr/local/lib/libiconv.so.2 /usr/lib/libiconv.so.2

#防止出现make: *** [sapi/cli/php] Error 1
ln -s /usr/local/lib/libiconv.so.2 /usr/lib64/libiconv.so.2


### php
cd /usr/local/src
wget http://am1.php.net/get/php-5.6.27.tar.gz/from/this/mirror
mv mirror php-5.6.27.tar.gz
tar zxvf php-5.6.27.tar.gz
cd php-5.6.27
cp -frp /usr/lib64/libldap* /usr/lib/
./configure --prefix=/srv/php \
		--with-pic \
		--with-layout=GNU \
		--enable-inline-optimization \
		--disable-phpdbg \
		--disable-cli \
		--enable-cli \
		--enable-cgi \
	        --enable-fpm \
		--with-fpm-acl \
		--enable-mbstring \
	        --enable-zip \
	        --with-curl \
	        --with-mcrypt \
	        --with-iconv \
	        --with-iconv-dir=/usr/local \
	        --with-gd \
		--enable-gd-native-ttf \
		--with-freetype-dir \
		--with-curl \
	        --with-mysql=mysqlnd \
	        --with-mysqli=mysqlnd \
	        --with-pdo-mysql=mysqlnd \
	        --enable-opcache \
	        --with-jpeg-dir \
	        --with-png-dir \
	        --with-zlib-dir \
	        --with-xpm-dir \
	        --with-freetype-dir \
	        --enable-gd-native-ttf \
	        --enable-gd-jis-conv \
	        --with-openssl \
	        --with-zlib \
	        --enable-intl \
	        --disable-debug \
	    	--disable-rpath \
	    	--disable-static \
	    	--disable-pcntl \
	    	--enable-ftp \
	    	--enable-shared \
	    	--enable-soap \
	    	--with-imap=/usr/local/imap-2007f \
		--with-imap-ssl=/usr/local/imap-2007f \
	    	--with-config-file-path=/srv/php \
	    	--with-config-file-scan-dir=/srv/php/conf.d \
	    	--sysconfdir=/srv/php \
	    	--without-pear \
	    	--enable-sockets
 
make ZEND_EXTRA_LIBS='-liconv'
make install 
### php with mysql
yum -y install php-mysql php-gd libjpeg* php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-bcmath php-mhash



######################################
###             mysql              ###
######################################

yum -y install mariadb-server mariadb-devel
sudo systemctl start mariadb.service



#######################################
###              redis              ###
#######################################



cd /usr/local/src
wget http://download.redis.io/releases/redis-3.2.5.tar.gz
tar zxvf redis-3.2.5.tar.gz
cd redis-3.2.5
sudo mkdir /srv/redis
sudo make
sudo make PREFIX=/srv/redis install

#######################################
###		mongo		    ###
#######################################
sudo echo "[mongodb-org-3.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/testing/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc" >> /etc/yum.repos.d/mongodb-org-3.4.repo
sudo yum -y install mongodb-org







