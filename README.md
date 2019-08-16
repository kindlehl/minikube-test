## Using a Local Registry for Test Images

### Prerequisites

You need to have the following tools installed:

* `kubectl`
* `minikube`

They can be configured every which way, just have the binaries on your workstation and in your `PATH` variable.

### Starting up and configuring Minikube

Start up the Minikube cluster and allow connecting to an insecure registry.

```bash
minikube start --insecure-registry 'minikube:5000'
```
Login to the Minikube VM and open `/var/lib/boot2docker/profile` in a text editor. You need to add the following line if
it does not exist.

```bash
EXTRA_ARGS='--insecure-registry minikube:5000'
```

Then restart the docker daemon.

```bash
sudo systemctl restart docker
```

Every time a docker command is ran by Kubernetes, those `EXTRA_ARGS` are going to be added. This will ensure that
Kubernetes has no problems pulling down your test images from the local registry, since the Minikube registry plugin
operates over plaintext HTTP. Normally, Docker would throw an error about the registry being insecure.

You can automate this step by using this command.

```bash
minikube ssh "sudo grep EXTRA_ARGS /var/lib/boot2docker/profile || echo \"EXTRA_ARGS='--insecure-registry minikube:5000'\" | sudo tee -a /var/lib/boot2docker/profile && sudo systemctl restart docker"
```

Now just simply enable the registry.

```bash
minikube addons enable registry
```

### Configure Kubectl to use Minikube

When running the `minikube start` command, the Minikube process updates your kubectl configuration. In order to interact with the Minikube Kubernetes API, you need to tell `kubectl` to use it. 

```bash
kubectl config use-context minikube
```

### Setup Your Shell Environment

You can skip this step, but I don't recommend it. Just run this command.

```bash
eval "$(minikube docker-env)"
```

This command configures your environment so `docker` will connect to the daemon provided by the Minikube
VM. This is handy for a couple reasons:

* Your local setup won't get bloated with test images/layers
* You don't need to be in the `docker` group or use sudo to run Docker commands because the Minikube Docker daemon listens on a TCP socket without
  authentication

### Stub Local DNS for Minikube Registry

Make sure your `/etc/hosts` (or equivalent) has an entry for the name `minikube`.

```bash
sudo sed -i "$ a $(minikube ip) minikube" /etc/hosts
```

Make sure you don't already have an entry or you might find things not working so well.

### How to Use the Registry

You now have minikube running with a local registry at `minikube:5000`.  To push to the registry, tag an image with
`minikube:5000/{anything1}/{anything2}`. You can use whatever names you want for `anything1` and `anything2`. Then push
the image. You should be able use the image in Kubernetes. You'll have to specify the full image URI in the Kubernetes
manifests (ex. minikube:5000/test/postgresql)


### One Shot Setup

You probably don't want to run the same commands everytime to set this up. Heres a nice little script. Copy this and
`chmod +x` it.

```bash
#!/bin/bash
minikube start --insecure-registry 'minikube:5000'
minikube ssh "sudo grep EXTRA_ARGS /var/lib/boot2docker/profile || echo \"EXTRA_ARGS='--insecure-registry minikube:5000'\" | sudo tee -a /var/lib/boot2docker/profile && sudo systemctl restart docker"
kubectl config use-context minikube
minikube addons enable registry 
sudo sed -i "$ a $(minikube ip) minikube" /etc/hosts
eval "$(minikube docker-env)"
```
### Cleaning Up

Remove all entries in your `/etc/hosts` with the minikube name attached. You can do `sudo sed -i '/minikube/d' /etc/hosts` to accomplish this.

Then run `minikube delete`.

