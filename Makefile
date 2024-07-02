.PHONY: default
default: clean build

.PHONY: clean
clean: clean-dist

.PHONY: build
build: build-src build-bin build-lib build-res

.PHONY: test
test: test-unit test-e2e

###########################################################################
## variables
##
VERSION				:= $(shell cat VERSION)

DIST_FILENAME		:= ldtw
DIST_FOLDER			:= dist

SRC_SCRIPTS_BAT		:= src/main/bat
SRC_SCRIPTS_SH		:= src/main/sh
SRC_RESOURCES		:= src/main/resources

TEST_SCRIPTS_BAT	:= src/main/bat
TEST_SCRIPTS_SH		:= src/main/sh
TEST_RESOURCES		:= src/main/resources


###########################################################################
## tasks
##

## clean

.PHONY: clean-dist
clean-dist:
	(rm -rf ${DIST_FOLDER}/)

## build

.PHONY: build-src
build-src:
	((mkdir -p ${DIST_FOLDER}/) && \
	 (cp ${SRC_SCRIPTS_BAT}/ldt-wrapper.bat ${DIST_FOLDER}/${DIST_FILENAME}.bat) && \
	 (cp ${SRC_SCRIPTS_SH}/ldt-wrapper.sh ${DIST_FOLDER}/${DIST_FILENAME}))

.PHONY: build-bin
build-bin:
	((mkdir -p ${DIST_FOLDER}/bin/))

.PHONY: build-lib
build-lib:
	((mkdir -p ${DIST_FOLDER}/lib/))

.PHONY: build-res
build-res:
	((mkdir -p ${DIST_FOLDER}/res/) && \
	 (cp ${SRC_RESOURCES}/README.txt ${DIST_FOLDER}/) && \
	 (cp VERSION ${DIST_FOLDER}/) && \
	 (cp LICENSE ${DIST_FOLDER}/))

## test

.PHONY: test-unit
test-unit:
	((echo "docker run -it etc..."))

.PHONY: test-e2e
test-e2e:
	((echo "docker run -it etc..."))



###########################################################################
##
## SETUP ldt-wrapper Manually
##

LDTW := src/main/bash/ldt-wrapper.bash
LDTW_alias := alias ldtw=\"/config/ldtw\"
LDTW_AMG := /srv/vscode-amg
LDTW_CHR := /srv/vscode-chr
LDTW_LDW := /srv/vscode-ldw
LDTW_NDW := /srv/vscode-ndw

.PHONY: setup-ldtw
setup-ldtw:
	((cp ${LDTW} ${LDTW_AMG}/ldtw && chmod 755 ${LDTW_AMG}/ldtw && echo "${LDTW_alias}">>${LDTW_AMG}/.bash_aliases) && \
	 (cp ${LDTW} ${LDTW_CHR}/ldtw && chmod 755 ${LDTW_CHR}/ldtw && echo "${LDTW_alias}">>${LDTW_CHR}/.bash_aliases) && \
	 (cp ${LDTW} ${LDTW_LDW}/ldtw && chmod 755 ${LDTW_LDW}/ldtw && echo "${LDTW_alias}">>${LDTW_LDW}/.bash_aliases) && \
	 (cp ${LDTW} ${LDTW_NDW}/ldtw && chmod 755 ${LDTW_NDW}/ldtw && echo "${LDTW_alias}">>${LDTW_NDW}/.bash_aliases))

##
## UPDATE ldt-wrapper Manually
##

.PHONY: update-ldtw
update-ldtw:
	((cp ${LDTW} ${LDTW_AMG}/ldtw && chmod 755 ${LDTW_AMG}/ldtw) && \
	 (cp ${LDTW} ${LDTW_CHR}/ldtw && chmod 755 ${LDTW_CHR}/ldtw) && \
	 (cp ${LDTW} ${LDTW_LDW}/ldtw && chmod 755 ${LDTW_LDW}/ldtw) && \
	 (cp ${LDTW} ${LDTW_NDW}/ldtw && chmod 755 ${LDTW_NDW}/ldtw))
