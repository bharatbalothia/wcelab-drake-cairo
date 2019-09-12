#!/bin/sh


cd /opt/ssfs/runtime/bin && ./deployer.sh -t resourcejar
cd /opt/ssfs/runtime/bin && ./deployer.sh -t entitydeployer
cd /opt/ssfs/runtime/docker-samples/imagebuild && ./generateImages.sh --MODE=agent
cd /opt/ssfs/runtime/docker-samples/imagebuild && ./generateImages.sh --MODE=app


