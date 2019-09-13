#!/bin/sh

cd /opt/ssfs/runtime/docker-samples/imagebuild && cp generateImages.sh.in generateImages.sh.in_bk
sed -i 's/buildah bud/buildah --storage-driver vfs --isolation chroot bud/g' generateImages.sh.in
sed -i 's/buildah tag/buildah --storage-driver vfs tag/g' generateImages.sh.in
sed -i 's/buildah images/buildah --storage-driver vfs images/g' generateImages.sh.in
sed -i 's/buildah rmi/buildah --storage-driver vfs rmi/g' generateImages.sh.in
sed -i 's/buildah push/buildah --storage-driver vfs push/g' generateImages.sh.in

cd /opt/ssfs/runtime/bin && ./setupfiles.sh

echo 'Done fixing the generateImages.sh script'
