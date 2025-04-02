clear

echo
echo
echo
echo
echo
region="us-east-1"

# configure
# AWS configure

# user in IAM role and add necessary permission
# AmazonEC2ContainerRegistryFullAccess


# 📍 2.1: Authenticate with AWS ECR
echo "< ---------------------- 21. Authenticate with AWS ECR ----------------------->"
echo
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin 123456789098.dkr.ecr.us-east-1.amazonaws.com
echo

# login
'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com'


#list all existing repositories
echo "< ---------------------- 22. list all existing repositories ----------------------->"
echo
aws ecr list-repositories --region $region
aws ecr describe-repositories --region us-east-1
echo

echo
echo "< ---------------------- 23. delete all existing repositories ----------------------->"
echo
aws ecr delete-repository --repository-name fastapi-app --force
echo

#list all existing repositories
echo "< ---------------------- 24. list all existing repositories after deletion ----------------------->"
echo
aws ecr list-repositories --region $region
aws ecr describe-repositories --region us-east-1
echo


# <--- Push Docker Images to AWS Elastic Container Registry (ECR) --->
# 📍 2.2: Create an ECR Repository
echo "< ---------------------- 25. Create an ECR Repository ----------------------->"
aws ecr create-repository --repository-name fastapi-app
echo


# 📍 2.3: Tag and Push Docker Images
echo "< ---------------------- 26. Tag Docker Images for AWS ECR----------------------->"
echo
# Tag images
docker tag 0f3b84928b65 123456789098.dkr.ecr.us-east-1.amazonaws.com/fastapi-app:v1


# Push images to AWS ECR
echo "< ---------------------- 27. Push images to AWS ECR ----------------------->"
echo
docker push 123456789098.dkr.ecr.us-east-1.amazonaws.com/fastapi-app:v1

echo






# # <-------- configure kubernetes clusters --------->


# echo
# echo
# echo
# echo
# echo
# # # Step 1: Configure AWS CLI 
# echo "< ----------------------  31. Configure AWS CLI ----------------------->"
# #!/bin/bash

# # Load environment variables from .env file
# if [ -f .env ]; then
#     export $(grep -v '^#' .env | xargs)
# else
#     echo "❌ Error: .env file not found!"
#     exit 1
# fi

# # Verify environment variables (mask sensitive values)
# echo "🔍 Verifying loaded environment variables..."
# echo "AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID:0:4}****"   # Masked for security
# echo "AWS_SECRET_ACCESS_KEY: ********"                  # Do NOT print secrets
# echo "AWS_REGION: $AWS_REGION"
# echo "CLUSTER_NAME: $CLUSTER_NAME"

# # Configure AWS CLI
# echo "🚀 Configuring AWS CLI..."
# aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
# aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
# aws configure set region "$AWS_REGION"

# # Verify AWS configuration
# echo "🔍 Checking AWS CLI configuration..."
# aws configure list



# # list all existing clusters and nodegroups
# echo "< ---------------------- 32. list all existing clusters and nodegroups----------------------->"
# echo
# aws eks list-clusters --region $region --query "clusters" --output text
# aws eks list-nodegroups --cluster-name django-cluster --region $region --query "nodegroups" --output text
# echo


# # create a new cluster and connect to it
# echo "< ---------------------- 33. create a new cluster and connect to it ----------------------->"

# # already created the cluster in create_eks_cluster.sh
# echo
# echo "< ---------------------- 34. connect to the cluster ----------------------->"
# aws eks update-kubeconfig --region $region --name django-cluster 
# echo
# echo "< ---------------------- 35. check the nodes ----------------------->"
# kubectl get nodes
# echo


# list all existing clusters and nodegroups after creation
# echo "< ---------------------- 36. list all existing clusters and nodegroups after creation ------------>"
# echo
# aws eks list-clusters --region $region --query "clusters" --output text
# aws eks list-nodegroups --cluster-name django-cluster --region $region --query "nodegroups" --output text
# echo

# # create a secret for the django app
# echo "< ---------------------- 37. create a secret for the django app ----------------------->"
# echo
# kubectl create secret generic django-secret \
#   --from-literal=DATABASE_NAME=$DATABASE_NAME \
#   --from-literal=DATABASE_USER=$DATABASE_USER \
#   --from-literal=DATABASE_PASSWORD=$DATABASE_PASSWORD \
#   --from-literal=DATABASE_HOST=$DATABASE_HOST \
#   --from-literal=DATABASE_PORT=$DATABASE_PORT

# kubectl get secret django-secret


# # create a secret for the postgres app
# echo "< ---------------------- 38. create a secret for the postgres app ----------------------->"
# echo
# kubectl create secret generic postgres-secret \
#   --from-literal=DATABASE_NAME=$POSTGRES_DB \
#   --from-literal=DATABASE_USER=$POSTGRES_USER \
#   --from-literal=DATABASE_PASSWORD=$POSTGRES_PASSWORD


# # Step 5: Deploy PostgreSQL Database
# echo "< ---------------------- 37. Deploy PostgreSQL Database ----------------------->"
# echo    
# kubectl get pods
# kubectl apply -f postgres-deployment.yaml
# kubectl apply -f django-deployment.yaml
# kubectl apply -f service.yaml
# # kubectl apply -f postgres-service.yaml
# # kubectl apply -f django-service.yaml
# kubectl get pods
# echo

# echo "< ---------------------- 38. get the services ----------------------->"
# kubectl get svc
# echo



























# echo "< ---------------------- delete all existing resources ----------------------->"
# echo


# #  list out all aws clusters
# echo "< ---------------------- list out all aws clusters ----------------------->"
# echo
# aws eks list-clusters --region $region
# echo

# # list out all aws node groups
# echo "< ---------------------- list out all aws node groups ----------------------->"
# echo
# aws eks list-nodegroups --cluster-name django-cluster --region $region  
# echo

# # delete all aws paid resources if exists
# echo "< ---------------------- delete all django cluster if exists ----------------------->"
# echo
# aws eks delete-cluster --name django-cluster --region $region --force
# aws eks delete-nodegroup --cluster-name django-cluster --nodegroup-name django-nodes --region $region --force
# echo

# #  list out all aws clusters
# echo "< ---------------------- list out all aws clusters after deletion ----------------------->"
# echo
# aws eks list-clusters --region $region
# echo

# # list out all aws node groups
# echo "< ---------------------- list out all aws node groups after deletion ----------------------->"
# echo
# aws eks list-nodegroups --cluster-name django-cluster --region $region  
# echo



# echo
# echo
# echo
# echo
# echo



# echo "< ---------------------- delete existing clusters if exists ----------------------->"
# aws eks delete-cluster --name django-cluster --region $region --force   
# echo

# # delete all existing nodes
# echo "< ---------------------- delete all existing nodes ----------------------->"
# aws eks delete-nodegroup --cluster-name django-cluster --nodegroup-name django-nodes --region $region --force
# echo