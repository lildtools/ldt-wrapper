1) curl -sL https://cdn.lildworks.cloud/ldtw | /bin/sh
2) install: check bash, check deps, get user input: installationFolder, default(/usr/bin/ldt), process install
3) setup alias, if needed: alias ldt="/bin/bash /installationFolder/bin/ldt"
4) check ldt command is working: ldt docker -i hello-world:latest

NOTE: temporary working folder-ben történjen minden, és copy a végleges helyekre, HA van hozzá rw jogunk

NOTE: nem kell feltétlen letölteni az ldtw-t a /config/ldtw, hanem /bin/sh-val lefuttatni a telepítést
NOTE: ennek ellenére le lehessen tölteni, ha akarja valaki
NOTE: kell egy --upgrade parancs, vagy alapból első dolog check updates legyen
NOTE: update logika --> ha van uj, clean ldt, aztán rendes letöltős installálós logika

NOTE: .exe legyen telepítős mindent egybe windows packager csomag


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
