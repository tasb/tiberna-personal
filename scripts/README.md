# Installation Scripts

## Install Raspberry Pi

```bash
wget https://raw.githubusercontent.com/tasb/tiberna-personal/main/scripts/tiberna.pub
wget https://raw.githubusercontent.com/tasb/tiberna-personal/main/scripts/install-rasp.sh

chmod +x install-rasp.sh
./install-rasp.sh

rm tiberna.pub
rm install-rasp.sh
exec bash

sudo shutdown -r now
```
