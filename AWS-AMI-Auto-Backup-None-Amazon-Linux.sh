#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

# You can find your instance ID at AWS Manage Console
instanceID="YOUR-INSTANCE-ID"

# Your can find your owner ID at AWS Manage Console
ownerID="YOUR-OWNER-ID"

# Your prefer AMI Name prefix
amiNamePrefix="AMI_"

# Your prefer AMI Description
amiDescription="Daily AMI backup"

# Sun, Mon, Tue...
weekday=$(date +%a)

# Setup AMI Name
amiName=$amiNamePrefix$weekday

# Get AMI Image and Snapshot ID
amiInfo=$(aws ec2 describe-images --owners $ownerID --output text --query "Images[*].[ImageId,BlockDeviceMappings[*].Ebs[].SnapshotId]" --filters "Name=name, Values=$amiName" | xargs -r)
set -- "$amiInfo"
IFS=" "; declare -a Array=($*)
amiIDs="${Array[0]}"
snapshotIDs="${Array[1]}"

# Delete old image and snapshot
if [[ ! -z $amiIDs ]]; then
    # Deregister AMI
    for amiID in $amiIDs
    do
        aws ec2 deregister-image --image-id $amiID
    done

    # Delete snapshot
    for snapshotID in $snapshotIDs
    do
        aws ec2 delete-snapshot --snapshot-id $snapshotID
    done
fi

# Create AMI
aws ec2 create-image --instance-id $instanceID --name "$amiName" --description "$amiDescription" --no-reboot
