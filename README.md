# ldt-wrapper


## DOWNLOAD

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



## About

For further information, please visit the [Official Site](https://www.ldworks.hu/projects/ldtools/ldt-wrapper/about.html).

### Reference Documentation

For further reference, please consider the following sections:

* [GNU](https://www.gnu.org/gnu/gnu.html)
* [Batch](https://learn.microsoft.com/windows-server/administration/windows-commands/windows-commands)
* [Bash](https://www.gnu.org/software/bash/)

### Additional Links

These additional references should also help:

* [Docker](https://docs.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)

---

## Development

### Prerequisites

* [Git](https://git-scm.com/download) - Git version ^2.30.2
* [Make](https://www.gnu.org/software/make/) - GNU Make version ^4.3

---

## Build

```sh
make build
```

---

## Test

```sh
make test
```

---

## Projects

| ldt-builder                                       |                                            |
|---------------------------------------------------|--------------------------------------------|
| LDT_BUILDER_INFO                                  | ldt-builder                                |

| ldt-compiler                                      |                                            |
|---------------------------------------------------|--------------------------------------------|
| LDT_COMPILER_COMMANDS                             | cxapp,cxdckr                               |
| LDT_COMPILER_DIST_FILENAME                        | ldtw                                       |

| ldt-devops                                        |                                            |
|---------------------------------------------------|--------------------------------------------|
| LDT_DEVOPS_INFO                                   | ldt-devops                                 |

| ldt-docker                                        |                                            |
|---------------------------------------------------|--------------------------------------------|
| LDT_DOCKER_INFO                                   | ldt-docker                                 |

| ldt-logger                                        |                                            |
|---------------------------------------------------|--------------------------------------------|
| LDT_LOGGER_COMMANDS                               | logTrace,logDebug,logInfo,logWarn,logError |
| LDT_LOGGER_LOGLEVEL                               | TRACE,DEBUG,INFO,WARN,ERROR                |




## LDTC Setup
```sh
	((echo "[LDTC] setup...") && \
	 (if [ -f ~/.bash_aliases ]; then \
	    if [ "$(shell cat ~/.bash_aliases | grep ldtc)" = "" ]; then \
		  echo "alias ldtc=\"${ALIAS}\"">>~/.bash_aliases; fi ; fi) && \
	 (echo "[LDTC] setup."))
```
