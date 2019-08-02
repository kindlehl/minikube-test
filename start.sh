# Install kubectl if it isn't already
if ! command -v kubectl >/dev/null; then
  echo "[NOTICE] Installing kubectl"
  curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s \
  https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin
  echo "[NOTICE] Installed kubectl to /usr/local/bin"
fi

# Install minikube if it isn't already
if ! command -v minikube >/dev/null; then
  echo "[NOTICE] Installing minikube"
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 
  chmod +x minikube
  sudo mv minikube /usr/local/bin
  echo "[NOTICE] Installed minikube to /usr/local/bin"
fi

# Starts minikube
echo "[NOTICE] Starting Minikube!"
minikube start --insecure-registry 'minikube:5000'

# For some reason the option above doesn't work 100%
# Force Docker to use the insecure registry
minikube ssh "sudo grep EXTRA_ARGS /var/lib/boot2docker/profile || echo \"EXTRA_ARGS='--insecure-registry minikube:5000'\" | sudo tee -a /var/lib/boot2docker/profile && sudo systemctl restart docker"

echo "[NOTICE] Configuring Minikube and friends!"

# Configure kubectl to use the minikube cluster
kubectl config use-context minikube

# Enable registry on the minikube cluster
minikube addons enable registry 

# Stub minicube's IP
sudo sed -i "$ a $(minikube ip) minikube" /etc/hosts

# Use minikube's Docker daemon
eval $(minikube docker-env)
