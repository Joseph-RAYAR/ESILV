**Gcp Command to connect from ubuntu**
>
> gcloud config set project peak-eon-510814-m4
>
> gcloud compute ssh cloudopt-vm1 --zone=europe-west1-b
>
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

