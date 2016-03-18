#!/bin/bash
for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x restart ; done
sudo service hadoop-yarn-resourcemanager restart
sudo service hadoop-yarn-nodemanager restart
sudo service hadoop-mapreduce-historyserver restart
sudo service hadoop-yarn-timelineserver restart

for x in `cd /etc/init.d ; ls spark-*` ; do sudo service $x restart ; done
sudo service zeppelin restart
