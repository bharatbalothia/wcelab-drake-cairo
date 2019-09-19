#!/bin/sh

echo 'executing the drake-cairo build script'

sudo yum install maven
echo 'Done installing the maven package'

cd /opt/ssfs/sources/draike-cairo/cairo-drake/
mvn clean package
mkdir runtime/extensions/global/jar && cp target/cairo-drake-0.0.1-SNAPSHOT.jar runtime/extensions/global/jar
cd runtime/extensions/global && jar cvf oms-custom-extension.jar .  && cp oms-custom-extensions.jar /opt/ssfs/runtime
cd /opt/ssfs/runtime/bin && ./InstallExtension.sh /opt/ssfs/runtime/oms-custom-extension.jar

echo 'Done installing extensions'

echo 'Starting the Image Generation scripts'

BUILD_MODE=${BUILD_MODE:-"all"}
cd /opt/ssfs/runtime/docker-samples/imagebuild && ./generateImages.sh --MODE=${MODE} 

echo 'Done generated Images...'

cp /var/run/secrets/openshift.io/push/.dockercfg /tmp
(echo "{ \"auths\": " ; cat /var/run/secrets/openshift.io/push/.dockercfg ; echo "}") > /tmp/.dockercfg

if [ $BUILD_MODE = "agent" ]
then 


fi
buildah push --authfile /tmp/.dockercfg --cert-dir /var/run/secrets/kubernetes.io/serviceaccount localhost:oms-agent:10.0 docker://${OUTPUT_REGISTRY}:${OUTPUT_IMAGE}


