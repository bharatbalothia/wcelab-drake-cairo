#!/bin/sh

echo 'executing the drake-cairo build script'

sudo yum install maven
echo 'Done installing the maven package'

cd /opt/ssfs/sources/draike-cairo/cairo-drake/
mvn clean package
mkdir runtime/extensions/global/jar && cp target/cairo-drake-0.0.1-SNAPSHOT.jar runtime/extensions/global/jar
cd runtime/extensions/global && jar 
cd /opt/ssfs/runtime/bin && ./InstallExtension.sh /
