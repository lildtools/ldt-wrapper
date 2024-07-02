# CDN LDTW

## one-line command

```sh
apt update
apt install -y bash curl
curl -sL https://cdn.lildworks.cloud/ldt-wrapper.script | /bin/sh
```

```sh
apk -u add bash curl
curl -sL https://cdn.lildworks.cloud/ldt-wrapper.script | /bin/sh
```

## download via curl

```sh
apt update
apt install -y bash curl
curl -sL https://cdn.lildworks.cloud/ldt-wrapper.script -o /tmp/ldtw-setup.sh
chmod 700 /tmp/ldtw-setup.sh
/bin/sh /tmp/ldtw-setup.sh
```

```sh
apk -u add bash curl
curl -sL https://cdn.lildworks.cloud/ldt-wrapper.script -o /tmp/ldtw-setup.sh
chmod 700 /tmp/ldtw-setup.sh
/bin/sh /tmp/ldtw-setup.sh
```

## download via wget

```sh
apt update
apt install -y bash wget
wget https://cdn.lildworks.cloud/ldt-wrapper.script -o /tmp/ldtw-setup.sh
chmod 700 /tmp/ldtw-setup.sh
/bin/sh /tmp/ldtw-setup.sh
```

```sh
apk -u add bash wget
wget https://cdn.lildworks.cloud/ldt-wrapper.script -o /tmp/ldtw-setup.sh
chmod 700 /tmp/ldtw-setup.sh
/bin/sh /tmp/ldtw-setup.sh
```
