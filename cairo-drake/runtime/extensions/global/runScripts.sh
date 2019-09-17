#!/bin/sh

sed -i 's/NO_DBVERIFY=false/NO_DBVERIFY=true/g' /opt/ssfs/runtime/properties/sandbox.cfg
#cd /opt/ssfs/runtime/bin && ./deployer.sh -t resourcejar
#cd /opt/ssfs/runtime/bin && ./deployer.sh -t entitydeployer
cd /opt/ssfs/runtime && ./runSed.sh 
cd /opt/ssfs/runtime/docker-samples/imagebuild && ./generateImages.sh --MODE=agent
#cd /opt/ssfs/runtime/docker-samples/imagebuild && ./generateImages.sh --MODE=app


