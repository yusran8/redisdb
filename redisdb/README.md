# redisdb

## Arsitektur 
![arsi](https://github.com/yusran8/redisdb/blob/master/redisdb/pict/arsi.png)

## Instalasi

1. Jalankan ```vagrant init``` untuk membuat vagrantfile kemudian isikan seperti berikut

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure("2") do |config|
  
  # MySQL Cluster dengan 3 node
  (1..3).each do |i|
    config.vm.define "redis#{i}" do |node|
      node.vm.hostname = "redis#{i}"
      node.vm.box = "bento/ubuntu-16.04"
      node.vm.network "private_network", ip: "192.168.17.10#{i+4}"

      # Opsional. Edit sesuai dengan nama network adapter di komputer
      #node.vm.network "public_network", bridge: "Qualcomm Atheros QCA9377 Wireless Network Adapter"
      
      node.vm.provider "virtualbox" do |vb|
        vb.name = "redis#{i}"
        vb.gui = false
        vb.memory = "512"
      end
  
      node.vm.provision "shell", path: "Redis#{i}.sh", privileged: false
    end
  end

  config.vm.define "web" do |proxy|
    proxy.vm.hostname = "web"
    proxy.vm.box = "bento/ubuntu-16.04"
    proxy.vm.network "private_network", ip: "192.168.17.108"
    #proxy.vm.network "public_network",  bridge: "Qualcomm Atheros QCA9377 Wireless Network Adapter"
    
    proxy.vm.provider "virtualbox" do |vb|
      vb.name = "web"
      vb.gui = false
      vb.memory = "512"
    end

    proxy.vm.synced_folder ".", "/usr/share/nginx/html"
    proxy.vm.provision "shell", path: "provision.sh", privileged: false
  end

  config.vm.define "web2" do |proxy|
    proxy.vm.hostname = "web2"
    proxy.vm.box = "bento/ubuntu-16.04"
    proxy.vm.network "private_network", ip: "192.168.17.109"
    #proxy.vm.network "public_network",  bridge: "Qualcomm Atheros QCA9377 Wireless Network Adapter"
    
    proxy.vm.provider "virtualbox" do |vb|
      vb.name = "web2"
      vb.gui = false
      vb.memory = "512"
    end

    proxy.vm.synced_folder ".", "/usr/share/nginx/html"
    proxy.vm.provision "shell", path: "provision.sh", privileged: false
  end

end
```

2. 
