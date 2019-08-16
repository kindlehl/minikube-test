# Kubernetes Testing Platform

This repo provides two scripts and a buildable docker image to setup a minikube cluster and private registry.

## How To Use?

To get started, source `./start.sh`. You must source the file (using `.` or `source`) so it modifies your shell
environment.

Next, `cd` into the `test` directory. This directory contains a Dockerfile, a simple bash script, a k8s pod manifest,
and a script called `run` that will:
* Build a Docker container
* Push it to the minikube cluster's registry
* Apply the manifest to Kubernetes to start up a pod.
* Show progress as kubernetes schedules, pulls, and runs the container.
* Creates an environment file `k8s_env`

To verify that this setup works, run the `run` script and wait. If kubernetes spins up a pod called `bash`, then it
works!

You can build images and push them as minikube:5000/`anything`/`anything` to make them accessible to the cluster. 

If you want to use another shell, you can source the environment file `k8s_env`. If you don't you will be using the
local docker daemon. This is fine, but the test script won't work, and you'll have to run docker commands as root or
make yourself a part of the `docker` group.

When you're done, run the `cleanup.sh` script to free up most resources. 

## Scripts

`./start.sh`

* Installs minikube and kubectl if need be.
* Starts minikube cluster with a local image registry
* Configures kubectl to use the Minikube cluster
* Modifies Docker environment to use Minikube's Docker daemon
* Stubs hostname 'minikube' to point to the cluster

`./cleanup.sh`

* Removes 'minikube' hostname stub
* Destroys Minikube cluster

`./test/run`

**Should be ran with test as the CWD**

* Builds Docker container from `.`
* Pushes container to registry
* Deploys container as a Pod
