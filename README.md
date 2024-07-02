# ldt-wrapper

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
