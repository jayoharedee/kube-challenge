# Kubernetes Stateful HA Postgresql Challenge

This challenge consisted of three parts. Parts 1 & 2 were completed on the Google Cloud Platform. Part 3 was to create a bash script that allowed for file transfers amongst the k8 pods.

  1. In the "challenge" project on Google Cloud create a 3 machine Kubernetes cluster. The machine sizes should be 1 CPU and about 4GB of memeory.
  2. Create a postgres Statefulset that runs on the Kubernetes stack you just created. The statefulset should have 1 master and 2 replicas.
  3. Write a bash script that takes a file name and a destination path as input, and can find the names/IPs of the kubernetes machines dynamically and then copy the file passed as input to the destination path on all three machines

# My thought process behind each challenge.

  1. Creating a cluster was very easy and straight forward. The GCE interface was very intuitive and easy to find my way around to ensure that I was able to create the cluster with the required system resource specifications. The GUI felt a little too easy so I dug a bit deeper into gcloud and using the GCP CLI for provisioning the requirements.
  2. This one was a little bit tricky. Having never worked with k8 database deployments before and unsure of what Stateful set was, I headed over to the Kubernetes documentation. Luckily there was a wealth of information in the docs along with tutorials to get me started on the right path. After some research and a little bit of tweaking, I was able to create a customized YAML template for my deployment. This file can be found in the `deployments` folder.
  3. As I was completing my research, I had this last step in mind and was looking for information on how to bring the third part of the challenge to life. The bash script was put together via the use of `getopts` to collect some command line arguments via switches. Dynamically determining the IP for each pod and also the command for copying the file to the remote path was completed in thanks to `kubectl`.

When launching the Stateful Postgres cluster, I ran into a slight issue that will need to be looked at a little closer. When launching the cluster, I am able to successfully launch the first pod but when the second comes up, I am currently running into an issue with mounting the drive as it is already in use, according to the logs. I opted for the GCE persistent disk since I was using Google Cloud Engine. Will have to take a closer look at the logs to determine the cause of this.

Over all this challenge was extremely fun to work with and I wish I had more time tonight to keep it going. Regardless if I pass the challenge or not, I will continue to work on what I have completed tonight to ensure that things are performing in an optimal fashion.

# Order Of Commands Used For This Project

  1. `gcloud config set project <project name>`
  2. `gcloud config set compute/zone <zone>`
  3. `gcloud container clusters create <container name>`
  4. `gcloud container clusters get-credentials pg-stateful`
  5. `kubectl create configmap pg-stateful-config \
  --from-literal=postgres_user=admin \
  --from-literal=postgres_password=mystrongpassword \ 
  --from-literal=postgres_host=postgres \
  --from-literal=pgdata=/var/lib/postgresql/data/pgdata`
  6. `gcloud compute disks create --size 200GB postgres-disk`
  7. `kubectl create -f deployment/postgres.yaml`
  8. `kubectl get pod -w -l app=postgres`
