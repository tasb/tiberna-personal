#!/bin/bash

echo "# Added entries by install-vm.sh" >> ~/.bashrc
echo "" >> ~/.bashrc

sudo apt update
sudo apt -y upgrade

# Install tools
sudo apt install -y jq unzip dnsutils

# Install dotnet 6
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb


sudo apt-get update; \
sudo apt-get install -y apt-transport-https && \
sudo apt-get update && \
sudo apt-get install -y dotnet-sdk-6.0

sudo dotnet tool install --global dotnet-ef

# Install docker

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo groupadd docker
sudo usermod -aG docker $USER
sudo newgrp docker 

# Install kubectl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

echo "alias k=kubectl" >> ~/.bashrc
echo "source <(kubectl completion bash)" >> ~/.bashrc
echo "complete -F __start_kubectl k" >> ~/.bashrc

# Install helm

curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install -y helm

# Install az cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install az aks cli
az extension add --name aks-preview
az extension update --name aks-preview

# Install git
sudo apt-get update
sudo apt-get install -y git

# Install GCM
sudo apt install -y pass
sudo apt install -y gnupg2

echo "GCM_GPG_PATH=\"/usr/bin/gpg2\"" >> ~/.bashrc
echo "export GPG_TTY=$(tty)" >> ~/.bashrc

cat >keydata <<EOF
     %echo Generating a basic OpenPGP key
     Key-Type: DSA
     Key-Length: 1024
     Subkey-Type: ELG-E
     Subkey-Length: 1024
     Name-Real: GMC Creds
     Name-Email: gmc@git.org
     Expire-Date: 0
     Passphrase: P@ssw0rd
     # Do a commit here, so that we can later print "done" :-)
     %commit
     %echo done
EOF

gpg2 --batch --generate-key keydata
pass init "GMC Creds <gmc@git.org>"


curl -LO https://raw.githubusercontent.com/GitCredentialManager/git-credential-manager/main/src/linux/Packaging.Linux/install-from-source.sh
sh ./install-from-source.sh
git-credential-manager-core configure
echo "export GCM_CREDENTIAL_STORE= \"gpg\"" >> ~/.bashrc

# Install Brew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bash_profile
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile

# Install kubelogin
brew install Azure/kubelogin/kubelogin
echo "export KUBECONFIG=~/.kube/config" >> ~/.bashrc
# Update .bashrc


