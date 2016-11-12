# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # 配置box的镜像源
  config.vm.box = "bento/centos-7.2"
  # 初始化执行下载的脚本命令
  # config.vm.provision :shell, path: "bootstrap.sh"
  # 配置端口映射,guest为虚拟机,host为本机.
  config.vm.network :forwarded_port, guest: 80, host: 4321
  # 配置共享目录, 第一个为本机目录, 第二个为虚拟机目录
  config.vm.synced_folder "/home/work/share/helloworld", "/share"
  

  # 设置虚拟机的资源分配
   
  # 单机定义多个虚拟机的方法
  # config.vm.define "m1" do |m1|
  # 	m1.vm.box = "apache"
  # end
end
