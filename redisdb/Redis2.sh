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