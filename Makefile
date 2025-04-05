account_id = 271271282883
region = us-east-1
tag = v1
name = logistics-forked
image = $(account_id).dkr.ecr.$(region).amazonaws.com/$(name):$(tag)
install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

test:
	python -m pytest -vv --cov=main --cov=calCLI --cov=mylib test_*.py

format:	
	black *.py mylib/*.py

lint:
	pylint --disable=R,C --extension-pkg-whitelist='pydantic' main.py --ignore-patterns=test_.*?py *.py  mylib/*.py

container-lint:
	docker run --rm -i hadolint/hadolint < Dockerfile

refactor: format lint

login:
    # Authenticate Docker to the Amazon ECR registry
	@echo "Authenticating Docker to the Amazon ECR registry..."
	aws ecr get-login-password --region $(region) | docker login --username AWS --password-stdin $(account_id).dkr.ecr.$(region).amazonaws.com                                                                                            
	
build:
    # Build the Docker image locally
	@echo "Building the Docker image locally..."
	docker build -t $(name) .
create-ecr:
    # Create an Amazon ECR repository if it doesn't already exist
	@echo "Creating an Amazon ECR repository if it doesn't already exist..."
	aws ecr create-repository --repository-name $(name) --region $(region) || echo "Repository already exists"
tag:
    # Tag the Docker image with the full ECR repository URI
	@echo "Tagging the Docker image with the full ECR repository URI..."
	docker tag $(name) $(account_id).dkr.ecr.us-east-1.amazonaws.com/$(name):$(tag)

push:
    # Push the Docker image to the Amazon ECR repository
	@echo "Pushing the Docker image to the Amazon ECR repository..."
	docker push $(image)

deploy: login build create-ecr tag push
all: install lint test format deploy

# python -m venv .logi
# source .logi/bin/activate
# docker run -p 127.0.0.1:8080:8080 <image_id>
# pip install --upgrade awscli
# 
