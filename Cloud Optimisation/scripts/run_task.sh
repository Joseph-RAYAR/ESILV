#!/bin/bash
TASK_ID=$1
WORKLOAD=$2
SIZE=$3
VM=$4
ZONE="europe-west1-b"

# Execute remotely and save output/errors directly to local files
gcloud compute ssh $VM --zone=$ZONE \
  --command="cd ~/cloud-optimization && ./bin/$WORKLOAD --size $SIZE" \
  > results/${TASK_ID}.out 2> results/${TASK_ID}.err
