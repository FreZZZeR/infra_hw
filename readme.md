## Requirments

- Google CLoud:\
    - account\
    - project\
    - service account with Full GKE and Networks privileges\
    - installed Google Cloud SDK (gcloud)

- terraform 0.13.0 and above\

- kubectl\

- Exported JSON with GCP service account key.

## Pre-Deployment

git clone this_repo\
cd infra_hw\
touch terraform.tfvars\

Set up in the terraform.tfvars your values for variables from variables.tf\
Variable "creds" must contain a path to JSON file with GCP service account key

## Deployment

terraform init\

terraform plan\

terraform apply

## Post-Deployment

Navigate to GCP site in web-browser\
Select your project in project list\
Select Kubernetes Engine -> Clusters\
Touch "Connect" button instead your cluster name\
Copy and execute command to have kubectl GKE management\

kubectl get namespaces