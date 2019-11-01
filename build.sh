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





cp /var/run/secrets/openshift.io/push/.dockercfg /tmp
(echo "{ \"auths\": " ; cat /var/run/secrets/openshift.io/push/.dockercfg ; echo "}") > /tmp/.dockercfg

if [ $BUILD_MODE = "agent" ]
then 
    cd /opt/ssfs/runtime/docker-samples/imagebuild && ./generateImages.sh --MODE=agent
    buildah push --authfile /tmp/.dockercfg --cert-dir /var/run/secrets/kubernetes.io/serviceaccount localhost/oms-agent:10.0 docker://${OUTPUT_REGISTRY}/${OUTPUT_AGENT_IMAGE}
elif [ $BUILD_MODE = "agent" ]
then
    cd /opt/ssfs/runtime/docker-samples/imagebuild && ./generateImages.sh --MODE=app
    buildah push --authfile /tmp/.dockercfg --cert-dir /var/run/secrets/kubernetes.io/serviceaccount localhost/oms-app:10.0 docker://${OUTPUT_REGISTRY}/${OUTPUT_APP_IMAGE}
elif [ $BUILD_MODE = "base" ]
then
    cd /opt/ssfs/runtime/docker-samples/imagebuild && ./generateImages.sh --MODE=base
    buildah push --authfile /tmp/.dockercfg --cert-dir /var/run/secrets/kubernetes.io/serviceaccount localhost/oms-base:10.0 docker://${OUTPUT_REGISTRY}/${OUTPUT_BASE_IMAGE}
elif [ $BUILD_MODE = "cdt_import" ]
then
    export SOURCE_DB=${SOURCE_DB:-"MC_XML"}
    export SOURCE_PASSWORD=${SOURCE_PASSWORD:-""}
    sed -i 's/SOURCE_DB/SOURCE_DB=${SOURCE_DB}/g' /opt/ssfs/runtime/bin/cdtshell.sh
    sed -i 's/SOURCE_PASSWORD/SOURCE_PASSWORD=${SOURCE_PASSWORD}/g' /opt/ssfs/runtime/bin/cdtshell.sh
    sed -i 's/TARGET_DB/TARGET_DB=${TARGET_DB}/g' /opt/ssfs/runtime/bin/cdtshell.sh
    sed -i 's/TARGET_PASSWORD/TARGET_PASSWORD=${TARGET_PASSWORD}/g' /opt/ssfs/runtime/bin/cdtshell.sh
    cd /opt/ssfs/runtime/bin && ./cdtshell.sh 
fi 



