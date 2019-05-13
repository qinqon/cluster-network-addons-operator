#!/bin/bash -e
script_root=$( cd $( dirname ${BASH_SOURCE[0]} ) && pwd )

function _kubectl() {
    export KUBECONFIG=$script_dir/.kubeconfig
    $script_root/.kubectl "$@"
}

_kubectl "$@"
