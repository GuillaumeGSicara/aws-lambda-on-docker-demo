# Repository description 

This repo aims to demonstrate the use of AWS lambda function using a Dockerized image.
It uses the following tools

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) (MakeFile interaction)
- An AWS account with sufficient permissions
- [Terraform](https://www.terraform.io/) (IaC)
- [Docker](https://www.docker.com/) (container)

## :wrench: Using MakeFile

:warning: Don't forget to use a `.set-env.sh` file in the `tf/` folder

the whole infrastructure can be deployed with the following make commands

```bash
make create-registry
```

```bash
make deploy-lambda
```

## :bomb: Without the MakeFile

#### 1. Create the ECR and deploy with terraform

in `tf/ecr` you will find the terraform configuration to deploy the ecr registry.
The config will create an output `registry_url` that can be reused when deploying the lambda function

#### 2. Build and push the docker image

:fast_forward: refer to the [official documentation for more information](https://docs.aws.amazon.com/lambda/latest/dg/images-create.html)

First login to the created ECR 

```bash
docker login --username AWS --password-stdin $REPO_URL
```

Build & Push the image

```bash
docker build --no-cache --platform linux/amd64 -t $REPOSITORY_NAME:latest .; \
docker tag $REPOSITORY_NAME:latest $REPO_URL:latest; \
docker push $$REPO_URL:latest
```

Where:
- `$REPOSITORY_NAME` is the tag (name) of your docker image
- `$REPO_URL` is the full url to access your image (<\$AWS_ECR_URL/$REPOSITORY_NAME>)

#### 3. Deploy your lambda function

in the `tf/lambda` folder your will find the information to deploy your lambda function

:information_desk_person: Terraform will prompt you for `registry_url` you can fetch the value from 2.


## To test

- Use poetry in the Dockerfile, poetry files have been added if you want to use these in the `DockerFile`
