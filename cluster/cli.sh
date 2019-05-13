#!/bin/bash -e

script_root=$( cd $( dirname ${BASH_SOURCE[0]} ) && pwd )

source ${script_root}/gocli.sh

if [[ -t 1 ]]; then
    $gocli_interactive "$@"
else
    $gocli "$@"
fi
