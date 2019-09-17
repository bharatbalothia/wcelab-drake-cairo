#!/bin/sh

sed -i 's/NO_DBVERIFY=false/NO_DBVERIFY=true/g' /opt/ssfs/runtime/properties/sandbox.cfg
#cd /opt/ssfs/runtime/bin && ./deployer.sh -t resourcejar
#cd /opt/ssfs/runtime/bin && ./deployer.sh -t entitydeployer
cd /opt/ssfs/runtime && ./runSed.sh 
mkdir -p /home/omsuser/.docker
ln -s /var/run/secrets/openshift.io/push /home/omsuser/.docker/config.json

env
echo "Agent Repo : ${AGENT_REPO}  Agent Tag: ${AGENT_TAG}"
cd /opt/ssfs/runtime/docker-samples/imagebuild && ./generateImages.sh --MODE=agent --AGENT_REPO=oms-agent-custom --AGENT_TAG=latest 
#cd /opt/ssfs/runtime/docker-samples/imagebuild && ./generateImages.sh --MODE=app
buildah --storage-driver vfs images
buildah --storage-driver vfs push --cert-dir /var/run/secrets/kubernetes.io/serviceaccount localhost/oms-agent-custom:latest docker://${AGENT_REPO}:${AGENT_TAG} 


