#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

# Regions reference: http://docs.aws.amazon.com/general/latest/gr/rande.html
#region="us-west-1b"

# You can find your instance ID at AWS Manage Console
instanceID="YOUR-INSTANCE-ID"

# Your can find your owner ID at AWS Manage Console
ownerID="YOUR-OWNER-ID"

# Your prefer AMI Name prefix
amiNamePrefix="AMI_"

# Your prefer AMI Description
amiDescription="Daily AMI backup"

# If you want to keep 7 days AMI backups, please set routine true otherwise set it false
routine=true

# Variable for routine is true
weekday=$(date +%a)

if [ $routine = true ]; then
    # Setup AMI Name
    amiName=$amiNamePrefix$weekday

    # Get AMI ID
    amiIDs=$(aws ec2 describe-images --owners $ownerID --output text --query 'Images[*].ImageId')

    # Get Snapshot ID
    if [[ ! -z $amiIDs ]]; then
        snapshotIDs=$(aws ec2 describe-snapshots --owner-ids $ownerID --output text --query 'Snapshots[*].SnapshotId')
    fi
else
    # Setup AMI Name
    amiName=$amiNamePrefix

    # Get AMI ID
    amiIDs=$(aws ec2 describe-images --owners $ownerID --output text --query 'Images[*].ImageId')

    # Get Snapshot ID
    if [[ ! -z $amiIDs ]]; then
        snapshotIDs=$(aws ec2 describe-snapshots --owner-ids $ownerID --output text --query 'Snapshots[*].SnapshotId')
    fi
fi

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