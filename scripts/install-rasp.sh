#!/bin/bash

echo "# Added entries by install-rasp.sh" >> ~/.bashrc
echo "" >> ~/.bashrc

# Restart services automatically
sudo sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf
sudo sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf

sudo apt update
sudo apt -y upgrade

# Disable bell

echo "" >> .bashrc
echo "bind 'set bell-style none'" >> .bashrc

cat <<EOF > .vimrc
" Disable annoying beeping
set noerrorbells
set vb t_vb=
EOF

echo "source /usr/share/bash-completion/completions/git" >> ~/.bashrc

# Nginx

sudo apt install nginx -y
sudo ufw allow 'OpenSSH'
echo "y" | sudo ufw enable
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'


# Install tools
sudo apt install -y jq unzip dnsutils build-essential

# Install oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

echo "" >> .bashrc
echo "#oh-my-posh" >> .bashrc
echo 'eval "$(oh-my-posh init bash --config https://raw.githubusercontent.com/tasb/tiberna-personal/main/terminal/terminal.json)"' >> .bashrc

# Install dotnet 6

wget https://dot.net/v1/dotnet-install.sh
sudo chmod +x ./dotnet-install.sh
./dotnet-install.sh -c Current
rm -f dotnet-install.sh

# Install golang

wget https://go.dev/dl/go1.19.1.linux-arm64.tar.gz
sudo tar -C /usr/local -xzf go1.19.1.linux-arm64.tar.gz
rm go1.19.1.linux-arm64.tar.gz

# Add env vars
cat <<EOF >> ~/.bashrc

DOTNET_ROOT="$HOME/.dotnet"
GOPATH="$HOME/go"
PATH="$PATH:$HOME/.dotnet:$HOME/.dotnet/tools:/usr/local/go/bin"
EOF

# Install docker
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo usermod -aG docker $USER

# Install helm

curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install -y helm

# Install az cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install gh cli
type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

git config --global user.name "tiberna"
git config --global user.email "tiago.bernardo@gmail.com"

# Add public key
cat tiberna.pub > .ssh/authorized_keys
