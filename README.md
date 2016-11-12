# VagrantRepos

vagrant是一个造福后人的神器.php的环境搭建坑比较多,为了不让每个开发在开发之前先吃一坨翔,这里就配好了一套环境可以直接使用.

这个库中包含一个标准的vagrant镜像文件,其中集成centOS-7.2 + tengine-2.1.2 + php-5.6.27 + mysql 15.1 + mariadb-5.5.50 + redis-3.2.5 + mongodb3.4.0 以及相应的连接驱动, 可以直接使用.

在新的镜像搞定后,你可以利用package功能自定义镜像给别人使用.

这个镜像还要做两处修改, 第一是在php.ini的配置中 mysqli.default_socker的字段需要配置一下防止找不到mysql.sock. 第二是可以在 /etc/rc.d/rc.local中配置开机启动nginx, php-fpm, mariadb.service, redis, mongo的服务.具体添加语句如下:
```[shell]
su -c "/srv/nginx/sbin/nginx -c /srv/nginx/conf/nginx.conf"
su -c "/srv/php/sbin/php-fpm"
su -c "systemctl start mariadb.service"
su -c "/srv/redis/bin/redis-server /usr/local/src/redis-3.2.5/redis.conf"
su -c "/usr/bin/mongod -dbpath=/data/mongo/ --port=27017 --fork --logpath=/var/log/mongodb/mongodb.log"
```

有关更详细的使用方法,请参考[我的博客](https://flame4.github.io).

