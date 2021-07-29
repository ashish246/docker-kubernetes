# Docker Kubernetes Lbs

Repository contains a sample Golang application, an optimized way to dockerise the Golang app, and a sample way to deploy it using kubernetes deployment and service manifest.

## Running the Application Locally

- Switch to repository directory i.e. `docker-kubernetes/`
- Run below commands in the given order:`

```bash
go mod tidy
```

```bash
go mod vendor
```

```bash
go run .\main.go
```

## Running the Application using Docker Containers

- Switch to repository directory i.e. `docker-kubernetes/`
- Run below command to build the docker image (change the tag as needed and replace the docker hub user with a valid one):

```bash
docker build -t <dockerhub-user>/gotest:0.1 .
```

- Run the below command to spin up a container using above image:

```bash
docker run -p 8000:8000 --name gotest --rm <dockerhub-user>/gotest:0.1
```

- Test the application
- Stop the container using below command:

```bash
docker container stop gotest
```

- Push the docker image to the Docker Hub registry using below command:

```bash
docker push <dockerhub-user>/gotest:0.1
```

### Dockerfile Optimisations

Dockerfile is optimised by applying below best practices:

- Use latest Golang alpine base image
- Run `apk update --no-cache` and `apk upgrade --no-cache` to upgrade the OS with essentials. Use `--no-cahce` to not cache the indexes
- Do not include unnecessary packages like `git` if they are not required
- Keep minimum number of steps/layers, therefore, combined RUN statements if possible
- Use COPY instead of ADD to move files and source data
- Use multi-stage docker build to keep the final image as lean as possible
- Run the user with least privileges, if possible

## Deploying the Application in Kubernetes

Setup a local Kubernetes cluster either by using Minikube or Docker Desktop. This documentation is using Docker Desktop Kubeternetes cluster.

Switch to the repository directory and run the below command to deploy application using `gotest-deployment.yaml`:

```bash
kubectl config get-contexts
```

```bash
kubectl config use-context docker-desktop
```

Before running below command, replace the `<dockerhub-user>` with the user you used to build the docker image in the file `gotest-deployment.yaml`. Then run the command:

```bash
kubectl apply -f gotest-deployment.yaml
```

## Test the application

Once the HTTP server is up, below command should return HTTP status 200:

```bash
curl http://localhost:8000
```
