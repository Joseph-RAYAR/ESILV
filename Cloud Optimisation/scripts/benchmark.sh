#!/bin/bash
WORKLOAD=$1
SIZE=$2
RUNS=$3
OUT_CSV="data/benchmark_local.csv"

if [ ! -x "bin/$WORKLOAD" ]; then
    echo "Error: bin/$WORKLOAD not found or not executable!"
    exit 1
fi

for i in $(seq 1 $RUNS); do
    # %e = elapsed time in seconds, %M = max resident set size in KB
    /usr/bin/time -f "$WORKLOAD,$SIZE,$i,%e,%M" -o /tmp/bench_time.txt ./bin/$WORKLOAD --size $SIZE > /dev/null
    
    if [ $? -ne 0 ]; then
        echo "Error: execution failed for $WORKLOAD."
        exit 1
    fi
    
    cat /tmp/bench_time.txt >> $OUT_CSV
done
echo "Finished $RUNS runs of $WORKLOAD with size $SIZE."
