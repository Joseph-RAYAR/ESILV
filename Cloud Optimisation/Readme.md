**Gcp Command to connect from ubuntu**
>
> gcloud config set project peak-eon-510814-m4
>
> gcloud compute ssh cloudopt-vm1 --zone=europe-west1-b

**To Start VM from terminal**

>gcloud compute instances start cloudopt-vm1 cloudopt-vm2 cloudopt-vm3 --zone=europe-west1-b

**To Stop VM from terminal**

>gcloud compute instances stop cloudopt-vm1 cloudopt-vm2 cloudopt-vm3 --zone=europe-west1-b

 **To list the Instance vm**

> gcloud compute instances list
<img width="469" height="53" alt="image" src="https://github.com/user-attachments/assets/c47a557d-ddcf-4f83-ab27-4d6e9e38e0fe" />

>
Step 2 Inside GCP 

> su - rayarjosephd
>
> cd ~/cloud-optimization

>sudo apt update

>sudo apt install -y golang-go time

>cd ~/cloud-optimization

>go build -o bin/cpu_task workloads/cpu_task.go

>go build -o bin/memory_task workloads/memory_task.go

>go build -o bin/matrix_task workloads/matrix_task.go

>go build -o bin/sort_task workloads/sort_task.go

**TD 3**

TD3 Overview: Distributed Orchestration
In TD1 and TD2, you ran workloads on a single machine. TD3 shifts your project to a distributed orchestration system where your local Ubuntu machine acts as a controller that automatically launches multiple independent tasks across a cluster of three Google Cloud VMs.

Why we are doing this: You are building the mechanism to reliably execute and track distributed tasks concurrently. You are not measuring performance or building an optimization algorithm yet. Crucially, multiple tasks assigned to the same VM must be allowed to run at the exact same time and share that VM's resources.

1.Deploy Workloads to the New VMs:Copy your compiled bin directory from your local machine to cloudopt-vm2 and cloudopt-vm3 so they have the executables required to run the tasks.

>gcloud compute scp --recurse bin/ cloudopt-vm2:~/cloud-optimization/ --zone=europe-west1-b

<img width="1030" height="143" alt="image" src="https://github.com/user-attachments/assets/1413d1af-f67e-4815-bd7b-af10e9d8fb3c" />

>gcloud compute scp --recurse bin/ cloudopt-vm3:~/cloud-optimization/ --zone=europe-west1-b
>
<img width="1030" height="181" alt="image" src="https://github.com/user-attachments/assets/a2c20a09-0279-44f9-861a-c8f0050f1555" />

<img width="1030" height="287" alt="image" src="https://github.com/user-attachments/assets/8812567d-ddb6-4e8a-8b2a-4d9ae9f37179" />


1. Create the remote execution script (run_task.sh)

Bash
cat << 'EOF' > scripts/run_task.sh
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
EOF
chmod +x scripts/run_task.sh
>

<img width="592" height="469" alt="image" src="https://github.com/user-attachments/assets/99c4fbd1-eba7-42b0-8a9d-ef280f3171de" />

2. Create the main orchestrator (run_all.sh)

Bash
cat << 'EOF' > scripts/run_all.sh
#!/bin/bash
mkdir -p results

# Read the CSV row by row, skipping the header
tail -n +2 data/allocation_manual.csv | while IFS=, read -r task_id workload size vm; do
    # Skip empty lines
    [ -z "$task_id" ] && continue
    # Clean hidden carriage returns from the VM name
    vm=$(echo "$vm" | tr -d '\r')
    
    echo "Launching $task_id on $vm..."
    ./scripts/run_task.sh "$task_id" "$workload" "$size" "$vm" &
done

# Wait for all background tasks to finish
wait
echo "All tasks completed!"
EOF
chmod +x scripts/run_all.sh

<img width="824" height="504" alt="image" src="https://github.com/user-attachments/assets/80c99b38-417c-45ca-a486-afeede36d920" />
<img width="376" height="203" alt="image" src="https://github.com/user-attachments/assets/837ec52e-9cec-4763-a34c-46d8f3992574" />





## Project Overview (TD1 to TD4)
Here is the step-by-step progression of the cloud optimization architecture built in this project:

* **TD1 (Local Baseline):** Set up a local Linux environment, compiled Go workloads (CPU, memory, matrix, sort), and built a bash script (`benchmark.sh`) to measure local execution time and memory footprint (`benchmark_local.csv`).
* **TD2 (Cloud Migration):** Provisioned a Google Compute Engine VM (`cloudopt-vm1`), transferred the project, and ran the same benchmarks in the cloud (`benchmark_cloud_vm1.csv`) to compare local vs. cloud hardware performance.
* **TD3 (Distributed Orchestration):** Scaled to a cluster of three worker VMs. Created a manual CSV allocation and built orchestrator scripts (`run_task.sh` and `run_all.sh`) that use background SSH processes (`&`) to launch multiple tasks concurrently across the VMs and collect the logs.
* **TD4 (Automated Scheduling):** Replaced the manual CSV with an automated scheduler. Wrote a Go program (`round_robin.go`) that reads available tasks and machines, generates an allocation CSV using a Round-Robin sequence, and feeds it seamlessly into the TD3 orchestrator.
