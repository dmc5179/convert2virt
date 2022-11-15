#!/bin/bash

# Label bare metal nodes
MACHINES=$(oc get -A machines | grep metal | awk '{print $2}')
for m in ${MACHINES}
do
  NODE=$(oc get -o yaml machine ${m} | grep -A 2 nodeRef | tail -1 | awk '{print $NF}')
  oc label node "${NODE}" metal=true
done

# Create kubevirt namespace
oc apply -f 01_namespace.yaml

# Create kubevirt operator group
oc apply -f 02_operator_group.yaml

# Create kubevirt subscription
oc apply -f 03_subscription.yaml

# Wait for operator to deploy
sleep 120

# Create hyperconverged
oc apply -f 04_hyperconverged.yaml

# Create host path provisioner: Not always required
# oc apply -f 05_host_path_provisioner.yaml
