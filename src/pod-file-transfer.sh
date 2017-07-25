#!/bin/bash

# This is a small bash script to parse command line arguments for a file and a destination path. The file is then 
# transfered to all pods.
# The file is transfered to each respective pod via kubectl cp. Each pod's IP is dynamic dynamically determined 
# for this process.

# The command line arguments are as follows:
# -f: contains the name of the file to be transfered.
# -p: the remote path where the file should land on the pod

usage() { echo "Usage: $0 [-f <name of file to transfer>] [-p <remote path on pods for the file to land>]" 1>&2; exit 1;  }

# Parse the command line options out and assign them to variables
while getopts ":f:p:" o; do
  case "${o}" in
    f)
      file=${OPTARG}
      [[ -e "${file}"  ]] || { echo "could not find file" 1>&2; exit 1; }
      ;;
    p)
      path=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done
shift "$((OPTIND-1))"

if [ -z "${file}"  ] || [ -z "${path}"  ]; then
  usage
fi

# Contains the external IP's for all k8 pods
pod_ips=$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="ExternalIP")].address}')

# Loop through the pod IP's and copy the file to the destination path
IFS=' ' read -ra ip <<< "${pod_ips}"
for i in "${ip[@]}"; do
  echo "copying ${file} to ${path} on pod ip ${i}."
  kubectl cp ${file} ${i}:${path}
done
