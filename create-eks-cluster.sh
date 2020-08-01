eksctl create cluster \
--name capstone-project-udacity \
--version 1.16 \
--nodegroup-name standard-workers \
--node-type t2.micro \
--nodes 2 \
--nodes-min 1 \
--nodes-max 3 \
--node-ami auto \
--region ap-south-1