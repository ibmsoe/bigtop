#!/bin/bash
set -x
sudo apt-get update
if [ -f /etc/os-release ]; then
    . /etc/os-release
else
        echo "Unknown Linux Distribution."
        exit 1
fi

case ${ID}-${VERSION_ID} in
    ubuntu-14.04)
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository -y  ppa:openjdk-r/ppa
        ;;
    *)
        echo "unsupported OS ${ID}-${VERSION_ID}."
        exit
esac

sudo apt-get update
sudo apt-get install -y wget libsnappy1 libsnappy-dev openssl liblzo2-2 openjdk-8-jdk unzip netcat-openbsd apt-utils openssh-server
wget -O- http://archive.apache.org/dist/bigtop/bigtop-1.1.0/repos/GPG-KEY-bigtop | sudo apt-key add -


#mkdir -p ~/.ssh
#echo -e "Host *\n\tStrictHostKeyChecking no" > ~/.ssh/config
#ssh-keygen -q -N "" -t rsa -f ~/.ssh/id_rsa
#cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

if [ ! -d source  ] ; then
mkdir source; cd $_

if [ $HOSTTYPE = "powerpc64le" ] ; then
 sudo wget -O /etc/apt/sources.list.d/bigtop-1.1.0.list  http://bigtop-repos.s3.amazonaws.com/releases/1.1.0/ubuntu/vivid/ppc64el/bigtop.list
fi
if [ $HOSTTYPE = "x86_64" ] ; then
 sudo wget -O /etc/apt/sources.list.d/bigtop-1.1.0.list  http://www.apache.org/dist/bigtop/bigtop-1.1.0/repos/trusty/bigtop.list
fi
sudo apt-get update
wget https://ci.bigtop.apache.org/job/Bigtop-trunk-packages/BUILD_ENVIRONMENTS=ubuntu-14.04,COMPONENTS=zeppelin,label=docker-slave/lastSuccessfulBuild/artifact/output/zeppelin/zeppelin_0.5.6-1_all.deb
fi

#sudo ps -aux | grep java | awk '{print $2}' | sudo xargs kill
sudo RUNLEVEL=1 apt-get install -y hadoop hadoop-hdfs hadoop-yarn* hadoop-mapred* hadoop-conf* libhdfs_* 
sudo RUNLEVEL=1 apt-get install -y spark-core spark-datanucleus spark-extras spark-history-server spark-master spark-python spark-thriftserver spark-worker spark-yarn-shuffle

sudo /usr/lib/zookeeper/bin/zkServer.sh restart

export HADOOP_PREFIX=/usr/lib/hadoop
export JAVA_HOME=`sudo find /usr/ -name java-8-openjdk-*`
export HADOOP_CONF_DIR=/etc/hadoop/conf

echo "export JAVA_HOME=`sudo find /usr/ -name java-8-openjdk-*`" | sudo tee -a  /etc/environment $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_CONF_DIR=/etc/hadoop/conf"  | sudo tee -a $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_PREFIX=/usr/lib/hadoop"  | sudo tee -a $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_LIBEXEC_DIR=/usr/lib/hadoop/libexec" | $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_LOGS=/usr/lib/hadoop/logs"  | sudo tee -a $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_COMMON_HOME=/usr/lib/hadoop" | sudo tee -a  $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_HDFS_HOME=/usr/lib/hadoop-hdfs" | sudo tee -a  $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce" | sudo tee -a $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_YARN_HOME=/usr/lib/hadoop-yarn" | sudo tee -a $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh

sudo sed -i s/localhost/$HOSTNAME/ /etc/hadoop/conf/core-site.xml
#sudo ps -aux | grep java | awk '{print $2}' | sudo xargs kill
sudo chown -R $USER:hadoop /usr/lib/hadoop*
sudo chown -R hdfs:hadoop /var/log/hadoop-hdfs*
sudo chown -R yarn:hadoop /var/log/hadoop-yarn*
sudo chown -R mapred:hadoop /var/log/hadoop-mapred*
sudo chown -R $USER:hadoop /etc/hadoop
sudo -u hdfs hdfs namenode -format -force
sudo rm -rf /var/lib/hadoop-hdfs/cache/hdfs/dfs/data
for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do sudo service $x start ; done

sudo -u hdfs hadoop fs -mkdir -p /tmp/hadoop-yarn/staging/history/done_intermediate
sudo -u hdfs hadoop fs -chown -R mapred:mapred /tmp/hadoop-yarn/staging
sudo -u hdfs hadoop fs -chmod -R 1777 /tmp
sudo -u hdfs hadoop fs -mkdir -p /var/log/hadoop-yarn
sudo -u hdfs hadoop fs -chown yarn:mapred /var/log/hadoop-yarn

sudo service hadoop-yarn-resourcemanager start
sudo service hadoop-yarn-nodemanager start
sudo service hadoop-mapreduce-historyserver start
sudo service hadoop-yarn-timelineserver restart

sudo -u hdfs hadoop fs -mkdir -p /user/$USER
sudo -u hdfs hadoop fs -chown $USER /user/$USER


### Spark configuration 
echo "export SPARK_MASTER_IP=`hostname`"  |sudo tee -a /etc/spark/conf/spark-env.sh
sudo chown -R $USER:hadoop /etc/spark
cp /etc/spark/conf/spark-defaults.conf.template /etc/spark/conf/spark-defaults.conf
echo "spark.master                     spark://$(hostname):7077" >>/etc/spark/conf/spark-defaults.conf
echo "spark.eventLog.enabled           true" >>/etc/spark/conf/spark-defaults.conf
echo "spark.eventLog.dir               hdfs://$(hostname):8020/directory" >>/etc/spark/conf/spark-defaults.conf
echo "spark.yarn.am.memory             1024m" >>/etc/spark/conf/spark-defaults.conf

cp /etc/spark/conf/log4j.properties.template /etc/spark/conf/log4j.properties
echo "log4j.rootCategory=ERROR, console">>/etc/spark/conf/log4j.properties

sudo -u hdfs hadoop fs -mkdir -p /directory
sudo -u hdfs hadoop fs -chown -R spark:hadoop /directory
sudo -u hdfs hdfs dfs -chmod -R 1777 /directory
sudo -u hdfs hdfs dfs -mkdir -p  /var/log/spark/apps
sudo -u hdfs hdfs dfs -chown -R $USER:hadoop /var/log/spark

for x in `cd /etc/init.d ; ls spark-*` ; do sudo service $x start ; done

cd source
sudo RUNLEVEL=1 dpkg -i zeppelin_0.5.6-1_all.deb
sudo sed -i -e 's|yarn-client|spark://$(hostname):7077|g' /etc/zeppelin/conf/zeppelin-env.sh
echo "export ZEPPELIN_JAVA_OPTS=\"-Dspark.executor.memory=1G -Dspark.cores.max=4\"" |sudo tee -a /etc/zeppelin/conf/zeppelin-env.sh
cd ~ 
sudo chmod -R 1777 /tmp
sudo -u hdfs hdfs dfs -mkdir /user/zeppelin
sudo -u hdfs hdfs dfs -chown -R zeppelin /user/zeppelin
sudo rm /etc/zeppelin/conf.dist/interpreter.json
#rm -rf source
sudo service zeppelin restart


