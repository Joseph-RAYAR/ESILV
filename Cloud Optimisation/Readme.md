**Gcp Command to connect from ubuntu**
>
> gcloud config set project peak-eon-510814-m4
>
> gcloud compute ssh cloudopt-vm1 --zone=europe-west1-b
>
> gcloud compute instances list **To list the Instance vm**
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
