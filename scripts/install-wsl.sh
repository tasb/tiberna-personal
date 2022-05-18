sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip
sudo apt install unzip

sudo apt install -y fontconfig

unzip CascadiaCode.zip -d .fonts/CascadiaCove

rm CascadiaCode.zip

fc-cache -fv

Add to bashrc

export POSH_THEME="/mnt/c/Users/tiberna/terminal.json"

eval "$(oh-my-posh --init --shell bash --config $POSH_THEME)"

source <(kubectl completion bash)
complete -F __start_kubectl k