#!/bin/bash
#if [ -f ../.env ]; then
#  source ../.env
#fi

# login validation
ibmcloud login --apikey $IBM_CLOUD_API_KEY -q

# Power Workspace target
service_list_output=$(ibmcloud pi ws ls)
service_crn=$(echo "$service_list_output" | awk -v workspace="$IBM_POWER_WORKSPACE_NAME" '$0 ~ workspace {print $1}')
ibmcloud pi ws target "$service_crn"



#########################  Script 5: Detach subnet  ##########################

instance_crn=""

instances_list_output=$(ibmcloud pi instance list)
instance_crn=$(echo "$instances_list_output" | awk -v instance=$IBM_POWER_INSTANCE_NAME '$2 == instance {print $1}')

#Subnet ID target
subnet_id=""

subnets_output=$(ibmcloud pi subnet list)
subnet_id=$(echo "$subnets_output" | awk -v subnet="$IBM_POWER_SUBNET_NAME" '$2 == subnet {print $1}')


if [ -n "$instance_crn" ] && [ -n "$subnet_id" ]; then
    echo "Detaching subnet $IBM_POWER_SUBNET_NAME to LPAR $IBM_POWER_INSTANCE_NAME..."
        if ibmcloud pi instance subnet detach "$IBM_POWER_INSTANCE_NAME" --subnet "$subnet_id"; then
            echo "Subnet detached successfully."
        else
            echo "Error: Unable to detach subnet."
        fi
elif [ -n "$instance_crn" ]; then
  echo "Subnet ($IBM_POWER_SUBNET_NAME) doesn't exist."
elif [ -n "$subnet_id" ]; then
  echo "LPAR instance ($IBM_POWER_INSTANCE_NAME) doesn't exist."
fi