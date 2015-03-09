# AWS-AMI-Auto-Backup-None-Amazon-Linux
Shell Script to auto make AMI backup and delete old backups for none Amazon Linux.

Pre-request
-----------
1. Please install AWS CLI and setup.<br />
Reference: http://docs.aws.amazon.com/cli/latest/userguide/installing.html
2. Please add IAM role with appropriate permissions and launch instance with this IAM Role.<br />If you are not familiar with IAM Role, you can create a admin IAM Role for quick use.

About routine
-------------
1. If you set routine false, this script will delete all your exist AMIs and Snapshots.<br />
2. If you set routine true, AMI name will be $amiNamePrefix+$weekday.<br />for example, if you set $amiNamePrefix as "My AMI Backup " and set routine true.<br />then your AMI name will be "My AMI Backup Mon" (without quotation marks).

Amazon Linux
------------
If you use Amazon Linux please visit: https://github.com/henrychen95/AWS-AMI-Auto-Backup
