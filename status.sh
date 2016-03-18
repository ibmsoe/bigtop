#!/bin/bash
#### BigTOP Services Status
GREEN='\033[0;32m'
NC='\033[0m' # No Color
printf ">>>> ${GREEN}Apache BigTop Spark${NC} Services Status\n"
for x in `cd /etc/init.d ; ls spark*` ; do sudo service $x status ; done
printf ">>>> ${GREEN}Apache BigTop Hadoop-HDFS${NC} Services Status\n"
for x in `cd /etc/init.d ; ls hadoop-hdfs*` ; do sudo service $x status ; done
printf ">>>> ${GREEN}Apache BigTop Hadoop-MAPREDUCE${NC} Services Status\n"
for x in `cd /etc/init.d ; ls hadoop-map*` ; do sudo service $x status ; done
printf ">>>> ${GREEN}Apache BigTop HADOOP-YARN${NC} Services Status\n"
sudo service hadoop-yarn-resourcemanager status
sudo service hadoop-yarn-nodemanager status
sudo service hadoop-mapreduce-historyserver status
sudo service hadoop-yarn-timelineserver status
printf ">>>> ${GREEN}Apache BigTop Zeppelin${NC} Services Status\n"
sudo service zeppelin status

