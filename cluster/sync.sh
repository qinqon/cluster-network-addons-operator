#!/bin/bash -e
script_root=$( cd $( dirname ${BASH_SOURCE[0]} ) && pwd )

registry_port=$($script_root/cli.sh ports registry | tr -d '\r')
registry=localhost:$registry_port

# Cleanup previously generated manifests
rm -rf _out/
# Copy release manifests as a base for generated ones, this should make it possible to upgrade
cp -r manifests/ _out/
IMAGE_REGISTRY=registry:5000 DEPLOY_DIR=_out make generate-manifests

make cluster-clean

IMAGE_REGISTRY=$registry make docker-build-operator docker-push-operator

for i in $(seq 1 ${CLUSTER_NUM_NODES}); do
    $script_root/cli.sh ssh "node$(printf "%02d" ${i})" 'sudo docker pull registry:5000/cluster-network-addons-operator'
    # Temporary until image is updated with provisioner that sets this field
    # This field is required by buildah tool
    $script_root/cli.sh ssh "node$(printf "%02d" ${i})" 'sudo sysctl -w user.max_user_namespaces=1024'
done

$script_root/kubectl.sh create -f _out/cluster-network-addons/${VERSION}/namespace.yaml
$script_root/kubectl.sh create -f _out/cluster-network-addons/${VERSION}/network-addons-config.crd.yaml
$script_root/kubectl.sh create -f _out/cluster-network-addons/${VERSION}/operator.yaml
