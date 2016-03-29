# bigtop
 
##About Apache BigTop v1.1 on Power: Ubuntu 14.04

####This README describes some scripts and tools to get the Apache BigTop v 1.1 bundle up and running quickly with minimum intervention required. IBM uses Apache BigTop for one of their Big Data Analytics Hadoop-Spark solutions. Zeppelin is an excellent notebook used to showcase benchmark workloads.

#####The install_bigtop.sh script downloads, installs, and configures the following components:

- Java Open JDK 1.8 
- Apache Bigtop  v1.1 
  * Hadoop  v2.7.1
  * Spark  v1.5.1
  * Zeppelin  v0.5.6
  * Bigtop-groovy  v2.4.4
  * jsvc  v1.0.15
  * Tomcat  v6.0.36
  * Zookeeper  v3.4.6
- Scala  v2.10.4

##### A Brief Outline of scripts included in this project and their function follows:

###### -	install_bigtop.sh
     	Downloads, installs, configures, and starts all of the components listed above.

###### -	cleanup.sh
      Prepares the system for the install_bigtop.sh.
  Note: If the ~/bigtop/source directory is present, remove it manually prior to running the install_bigtop.sh script 

###### -	restart-bigtop.sh
      A convenient way to restart all BigTop components.

###### -	Status.sh
     JPS does not automatically produce the component status. This script will report BigTop component current status.

###### -	sparkTest.sh
     A quick workload provided to verify that Spark is working as desired.

###### -	hadoopTest.sh
     A quick test script to aid in verifying the Hadoop configuration.




#### For System Minimum Requirements and installation procedures, visit the Apache BigTop v1.1 on IBM SoftLayer Ubuntu 14.04 Quick Start guide located in the /docs directory.

https://github.com/ibmsoe/bigtop/docs

# Documentation
Documentation is available in the docs/ directory.

##### The Apache BigTop v1.1 on IBM SoftLayer Ubuntu 14.04 Quick Start provides: has everything you need to:
-	Instructions on how to get started on IBM’s SoftLayer Bare Metal Systems 
-	Information on how to use the scripts provided in this folder to quickly download, install, and configure a BigTop Hadoop – Spark environment.
-	How to access Zeppelin notebooks and run a provided Tutorial workload.
-	Information on how to optimize Spark properties through the Zeppelin Interpret 
-	Directions to upload then run the Sample Stock_workload.

 
# License
Hadoop-Spark is licensed under the Apache License, Version 2.0    


