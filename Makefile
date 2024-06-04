
create-registry:
	source ./tf/set-env.sh; cd ./tf/ecr/; \
	terraform init; \
	terraform destroy; \
	terraform apply; \
	cd -; \
	source ./tf/set-env.sh; \
		cd ./tf/ecr/; terraform refresh; \
		REPO_URL=$$(terraform output -raw repository_url); \
   		REPO_URL=$${REPO_URL//\"}; \
		REPOSITORY_NAME=$$(echo $$REPO_URL | awk -F/ '{print $$NF}'); \
		aws ecr get-login-password --region $$AWS_REGION | docker login --username AWS --password-stdin $$REPO_URL; \
		cd -; docker build --no-cache --platform linux/amd64 -t lambda-function-demo-image:latest .; \
		docker tag $$REPOSITORY_NAME:latest $$REPO_URL:latest; \
		docker push $$REPO_URL:latest


deploy-lambda:
	source ./tf/set-env.sh; \
		cd ./tf/ecr/; terraform refresh; \
		export REGISTRY_URL=$$(terraform output -raw repository_url):latest; \
		cd -; \
		cd ./tf/lambda/; \
		terraform init; \
		terraform destroy --var "registry_url=$$REGISTRY_URL"; \
		terraform apply --var "registry_url=$$REGISTRY_URL"; \