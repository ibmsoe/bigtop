#!/bin/bash

for x in `cd /etc/init.d ; ls hadoop-*` ; do sudo service $x stop ; done
for x in `cd /etc/init.d ; ls spark-*` ; do sudo service $x stop ; done
sudo service zeppelin stop

sudo ps -aux | grep java | awk '{print $2}' | sudo xargs kill
sudo apt-get purge -y hadoop*
sudo apt-get purge -y spark-*
sudo apt-get purge -y zeppelin*
sudo apt-get purge -y zookeeper*

sudo rm -rf /var/lib/hadoop-* /var/run/hadoop-* /var/log/hadoop-* /usr/lib/hadoop*
sudo rm -rf /usr/lib/zeppelin /etc/zeppelin /var/run/zeppelin/webapps /var/log/zeppelin /var/lib/zeppelin
sudo rm -rf /var/lib/spark /var/run/spark* /var/log/spark* /usr/lib/spark*


