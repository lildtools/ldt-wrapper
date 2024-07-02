# ldt-wrapper

##### DOWNLOAD

```txt
1) curl -sL https://cdn.lildworks.cloud/ldtw | /bin/sh
2) install: check bash, check deps, get user input: installationFolder, default(/usr/bin/ldt), process install, give rights: chmod 700 /installationFolder/bin/ldt
3) setup alias, if needed: alias ldt="/bin/bash /installationFolder/bin/ldt"
4) check ldt command is working: ldt docker -i hello-world:latest

NOTE: temporary working folder-ben történjen minden, és copy a végleges helyekre, HA van hozzá rw jogunk

NOTE: nem kell feltétlen letölteni az ldtw-t a /config/ldtw, hanem /bin/sh-val lefuttatni a telepítést
NOTE: ennek ellenére le lehessen tölteni, ha akarja valaki
NOTE: kell egy --upgrade parancs, vagy alapból első dolog check updates legyen
NOTE: update logika --> ha van uj, clean ldt, aztán rendes letöltős installálós logika

NOTE: .exe legyen telepítős mindent egybe windows packager csomag
```
