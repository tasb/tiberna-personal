# Installation Scripts

## Install Raspberry Pi

## Get the scripts

```bash
wget https://raw.githubusercontent.com/tasb/tiberna-personal/main/scripts/tiberna.pub
wget https://raw.githubusercontent.com/tasb/tiberna-personal/main/scripts/install-rasp.sh
```

## Run the installer

```bash
chmod +x install-rasp.sh
./install-rasp.sh
```

## Clean up the messa and reboot

```bash
rm tiberna.pub
rm install-rasp.sh
exec bash

sudo shutdown -r now
```
