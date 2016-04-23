#!/bin/bash

aws_type=$1
aws_path=inven/ec2/${aws_type}

#export ANSIBLE_HOSTS=${aws_path}/ec2.py
#export EC2_INI_PATH=${aws_path}/ec2.ini
source ${aws_path}/aws_access_key.sh

${aws_path}/ec2.py --refresh-cache