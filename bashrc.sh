# Shortcuts
alias gp='grep -rn --color=auto'
alias gpi='grep -rni --color=auto'

alias tarfolder='tar -zcvf'
alias untarfolder='tar -zxvf'

# Delete all running containers or images.
# NOTE: This will break Kubernetes if enabled within Docker Desktop on Mac.
alias dockerrm='docker rm $(docker ps -aq)'
alias dockerrmi='docker rmi $(docker images -q)'

# Terraform shortcuts for GCP.
tfinit() {
    terraform init
}

tfplan() {
    terraform plan
}

tfapply() {
    terraform apply -var account=${GCP_ACCOUNT} -var project=${GCP_PROJECT} -var region=${GCP_REGION} --var bucket=${GCP_BUCKET}
}

tfrefresh() {
    terraform refresh
}

tfdestroy() {
    terraform destroy
}

switch_cluster() {
    if [ $# -eq 1 ]; then
        gcloud container clusters get-credentials $1 --zone $GCP_REGION
    else
        echo $"Usage: $0 cluster-name"
    fi
}
