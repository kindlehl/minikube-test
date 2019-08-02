# Deconfigure Networking configuration
#sudo sysctl -w net.ipv4.conf.all.route_localnet=0
#sudo iptables -t nat -D OUTPUT -p tcp --dport 5000 -j DNAT --to-destination $(minikube ip):5000
#sudo iptables -t nat -D POSTROUTING -j MASQUERADE

# remove minikube DNS stub
sudo sed -i '/minikube/d' /etc/hosts

# Delete Minikube cluster

minikube delete

# Print message stating that the configuration cannot be 100% reversed

cat <<EOF
Your kubectl is still configured to use the minikube context. 
Your kubectl instance will be configured to communicate with the minikube instance until you change it back
Your shell's docker environment was also modified, so you may want to resource your dotfiles.
EOF


