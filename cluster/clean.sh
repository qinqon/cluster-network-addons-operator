#!/bin/bash -e

script_root=$( cd $( dirname ${BASH_SOURCE[0]} ) && pwd )

echo 'Cleaning up ...'

$script_root/kubectl.sh delete --ignore-not-found -f _out/cluster-network-addons/${VERSION}/namespace.yaml
$script_root/kubectl.sh delete --ignore-not-found -f _out/cluster-network-addons/${VERSION}/network-addons-config.crd.yaml
$script_root/kubectl.sh delete --ignore-not-found -f _out/cluster-network-addons/${VERSION}/operator.yaml

sleep 2

echo 'Done'
