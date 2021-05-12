#!/bin/bash
#
# Garbage collect completed (or very old) jobs
#
for ctx in $(kubectl config get-contexts --output=name); do
    KUBECTL="kubectl --context=$ctx"

    echo "# ===== $ctx ===== "
    # cleanup successful jobs
    $KUBECTL delete jobs --field-selector status.successful==1

    # Cleanup failed pods
    $KUBECTL delete pods --field-selector status.phase=Failed

    # delete jobs older than 1d (have 'd' in the AGE field)
    $KUBECTL delete job $($KUBECTL get job | awk 'match($4,/[0-9]+d/) {print $1}')
done
