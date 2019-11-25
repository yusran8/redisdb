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

2. buat beberapa file .sh pada direktori yang sama:
  a. Redis1.sh
  ```
  sudo cp '/vagrant/source/sources.list' '/etc/apt/sources.list'
  sudo apt-get update -y
  sudo apt-get install build-essential tcl -y
  sudo apt-get install libjemalloc-dev -y #(Optional)
  sudo apt-get install redis -y

  sudo mkdir /etc/redis

  sudo ufw allow 6380
  sudo ufw allow 26380

  sudo cp /vagrant/redis1.conf /etc/redis/redis.conf
  sudo cp /vagrant/sentinel1.conf /etc/redis/sentinel.conf

  sudo redis-server /etc/redis/redis.conf
  ```
  
  b. Redis2.sh
  ```
  sudo cp '/vagrant/source/sources.list' '/etc/apt/sources.list'

  sudo apt-get update -y
  sudo apt-get install build-essential tcl -y
  sudo apt-get install libjemalloc-dev -y #(Optional)
  sudo apt-get install redis -y

  sudo mkdir /etc/redis

  sudo ufw allow 6380
  sudo ufw allow 26380

  sudo cp /vagrant/redis2.conf /etc/redis/redis.conf
  sudo cp /vagrant/sentinel2.conf /etc/redis/sentinel.conf

  sudo redis-server /etc/redis/redis.conf
  ```
  
  c. Redis3.sh
  ```
  sudo cp '/vagrant/source/sources.list' '/etc/apt/sources.list'

  sudo apt-get update -y
  sudo apt-get install build-essential tcl -y
  sudo apt-get install libjemalloc-dev -y #(Optional)
  sudo apt-get install redis -y

  sudo mkdir /etc/redis

  sudo ufw allow 6380
  sudo ufw allow 26380

  sudo cp /vagrant/redis3.conf /etc/redis/redis.conf
  sudo cp /vagrant/sentinel3.conf /etc/redis/sentinel.conf

  sudo redis-server /etc/redis/redis.conf
  ```

3. buat beberapa file .conf pada direktori yang sama:
  a. redis1.conf
  ```
  bind 192.168.17.105
  port 6380

  dir "/etc/redis"
  ```
  
  b. sentinel1.conf
  ```
  # Host and port we will listen for requests on
  bind 192.168.17.105
  port 26380

  #
  # "redis-cluster" is the name of our cluster
  #
  # each sentinel process is paired with a redis-server process
  #
  sentinel monitor redis-cluster 192.168.17.105 6380 2
  sentinel down-after-milliseconds redis-cluster 5000
  sentinel parallel-syncs redis-cluster 1
  sentinel failover-timeout redis-cluster 10000
  ```
  
  c. redis2.conf
  ```
  bind 192.168.17.106
  port 6380

  dir "/etc/redis"

  slaveof 192.168.17.105 6380
  ```
  
  d. sentinel2.conf
  ```
  # Host and port we will listen for requests on
  bind 192.168.17.106
  port 26380

  #
  # "redis-cluster" is the name of our cluster
  #
  # each sentinel process is paired with a redis-server process
  #
  sentinel monitor redis-cluster 192.168.17.105 6380 2
  sentinel down-after-milliseconds redis-cluster 5000
  sentinel parallel-syncs redis-cluster 1
  sentinel failover-timeout redis-cluster 10000
  ```
  
  e. redis3.conf
  ```
  bind 192.168.17.107
  port 6380

  dir "/etc/redis"

  slaveof 192.168.17.105 6380
  ```
  
  f. sentinel3.conf
  ```
  # Host and port we will listen for requests on
  bind 192.168.17.107
  port 26380

  #
  # "redis-cluster" is the name of our cluster
  #
  # each sentinel process is paired with a redis-server process
  #
  sentinel monitor redis-cluster 192.168.17.105 6380 2
  sentinel down-after-milliseconds redis-cluster 5000
  sentinel parallel-syncs redis-cluster 1
  sentinel failover-timeout redis-cluster 10000
  ```
  
3. jalankan perintah ```vagrant up```

4. pada setiap server jalankan perintah ```sudo redis-server /etc/redis/redis.conf``` dan juga ```sudo redis-server /etc/redis/sentinel.conf --sentinel``` pada terminal yang berbeda

  saat sentinel dijalankan, maka akan terlihat bahwa slave1 telah terkoneksi dengan master
  ![connect](https://github.com/yusran8/redisdb/blob/master/redisdb/pict/connectslave1.PNG)
  
  begitu juga dengan slave2
  ![connect2](https://github.com/yusran8/redisdb/blob/master/redisdb/pict/connetslave2.PNG)
  
5. pastikan semua terhubung dengan cara masuk ke salah satu server dan ping redis dan sentinel pada semua server
![ping](https://github.com/yusran8/redisdb/blob/master/redisdb/pict/ping-redisconf.PNG)
![pingsentinel](https://github.com/yusran8/redisdb/blob/master/redisdb/pict/ping-redissentinel.PNG)

6. untuk melihat server master, jalankan perintah ```redis-cli -h 192.168.17.105 -p 26380 sentinel-get-master-addr-by-name redis-cluster```
![master](https://github.com/yusran8/redisdb/blob/master/redisdb/pict/findmaster.PNG)


## Wordpress

1. untuk setiap web server, file .sh yang akan digunakan untuk provisioning :
  ```
  sudo cp '/vagrant/source/sources.list' '/etc/apt/sources.list'

  sudo apt-get update -y

  # Install Apache2
  sudo apt install apache2 -y

  # Install PHP
  sudo apt install php libapache2-mod-php php-mysql php-pear php-dev -y
  sudo a2enmod mpm_prefork && sudo a2enmod php7.0
  sudo pecl install redis
  sudo echo 'extension=redis.so' >> /etc/php/7.2/apache2/php.ini

  # Install MySQL
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password admin'
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password admin'
  sudo apt install mysql-server -y
  sudo mysql_secure_installation -y
  sudo ufw allow 3306

  # Configure MySQL for Wordpress
  sudo mysql -u root -padmin < /vagrant/wordpress.sql

  # Install Wordpress
  cd /tmp
  wget -c http://wordpress.org/latest.tar.gz
  tar -xzvf latest.tar.gz
  sudo mkdir -p /var/www/html
  sudo mv wordpress/* /var/www/html
  sudo cp /vagrant/wp-config.php /var/www/html/
  sudo chown -R www-data:www-data /var/www/html/
  sudo chmod -R 755 /var/www/html/
  sudo systemctl restart apache2
  ```

2. buka <alamat_ip_web_server>/index.php di browser. kemudian ikuti perintah untuk menginstall wordpress
![inswordpress](https://github.com/yusran8/redisdb/blob/master/redisdb/pict/install_wordpress.png)
![inswordpress2](https://github.com/yusran8/redisdb/blob/master/redisdb/pict/install_wordpress2.png)

3. setelah instalasi selesai, install plugin redis cache object pada salah satu web server.

4. setelah tahap instalasi selesai, masuk ssh web server melalui terminal dan buka file ```sudo nano /var/www/html/wp-config.php``` dan tambahkan 
 ```
 define('FS_METHOD', 'direct');
 define('WP_REDIS_SENTINEL', 'redis-cluster');
 define('WP_REDIS_SERVERS', ['tcp://192.168.17.105:26380', 'tcp://192.168.17.106:26380', 'tcp://192.168.17.107:26380']);
 ```
 
 kemudian restart apache2
 
5. kembali pada wordpress di browser dan lihat pada detil plugin, sekarang terdapat 3 host
![enablecache](https://github.com/yusran8/redisdb/blob/master/redisdb/pict/enablingrediscacheobject.png)


## Uji jmeter

1. Pastikan jmeter telah terinstall.

 a. uji 50 koneksi dengan redis cache
 ![](https://github.com/yusran8/redisdb/blob/master/redisdb/pict/50jmeter-enable.png)
 
 b. uji 50 koneksi tanpa redis cache
 ![](https://github.com/yusran8/redisdb/blob/master/redisdb/pict/50jmeter-disable.png)
 
 c. uji 205 koneksi dengan redis cache
 ![](https://github.com/yusran8/redisdb/blob/master/redisdb/pict/205jmeter-enable.png)
 
 d. uji 205 koneksi tanpa redis cache
 ![](https://github.com/yusran8/redisdb/blob/master/redisdb/pict/205jmeter-disable.png)
 
 e. uji 305 koneksi dengan redis cache
 ![](https://github.com/yusran8/redisdb/blob/master/redisdb/pict/305jmeter-enable.png)
 
 f. uji 305 koneksi tanpa redis cache
 ![](https://github.com/yusran8/redisdb/blob/master/redisdb/pict/305jmeter-disable.png)
 
 tampak perbedaan tidak terlalu signifikan pada keduanya. namun disini terlihat bahwa server tanpa redis cache lebih lambat dibanding dengan redis cache. hal ini mungkin dikarenakan penggunaan chace mempercepat akses ke web werver.
 
 
 ## fail over
 
