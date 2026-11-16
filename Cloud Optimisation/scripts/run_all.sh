#!/bin/bash
mkdir -p results

# Use the provided file argument, or default to the manual file
INPUT="${1:-data/allocation_manual.csv}"

tail -n +2 "$INPUT" | while IFS=, read -r task_id workload size vm; do
    [ -z "$task_id" ] && continue
    vm=$(echo "$vm" | tr -d '\r')
    echo "Launching $task_id on $vm..."
    ./scripts/run_task.sh "$task_id" "$workload" "$size" "$vm" &
done

wait
echo "All tasks completed!"
