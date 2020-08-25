#!/bin/bash -xe

# This script should be able to execute KubeMacPool
# functional tests against Kubernetes cluster with
# CNAO built with latest changes, on any
# environment with basic dependencies listed in
# check-patch.packages installed and docker running.
#
# yum -y install automation/check-patch.packages
# automation/check-patch.e2e-kubemacpool-functests.sh

teardown() {
    make cluster-down
    rm -rf "${TMP_COMPONENT_PATH}"
}

main() {
    # Setup CNAO and artifacts temp directory
    source automation/check-patch.setup.sh
    cd ${TMP_PROJECT_PATH}

    # Spin-up ephemeral cluster with latest CNAO
    # this script also exports KUBECONFIG, and fetch $COMPONENT repository
    COMPONENT="nmstate" source automation/components-functests.setup.sh

    trap teardown EXIT

    # Run KubeMacPool functional tests
    cd ${TMP_COMPONENT_PATH}
    KUBECONFIG=${KUBECONFIG} make E2E_TEST_TIMEOUT=1h E2E_TEST_ARGS="-ginkgo.noColor --junit-output=$ARTIFACTS/junit.functest.xml" test-e2e-handler
}

[[ "${BASH_SOURCE[0]}" == "$0" ]] && main "$@"
