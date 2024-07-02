.SILENT: default
default: clean build

###########################################################################
.SILENT: build
.SILENT: clean
.PHONY:  compile
.SILENT: e2e
.SILENT: git-release
.SILENT: install
.SILENT: portable
.SILENT: test
.SILENT: usage
.SILENT: version
.SILENT: watch

###########################################################################
APP_NAME     := ldtw
APP_VERSION  := 1.0.0-SNAPSHOT
APP_CODENAME := LDTW
APP_CMD      := ldtw

DIST         := ./dist/
DIST_FILE    := ./dist/${APP_NAME}.sh

SRC          := ./src/
SRC_APP      := ./src/main/sh/app/
SRC_TASKS    := ./src/main/sh/tasks/

RESOURCES    := ./src/main/resources/

TEST_OUT     := ./out/

###########################################################################
install:
	((echo "[${APP_CODENAME}] install...") && \
	 (apt-get update) && \
	 (apt-get install -y inotify-tools) && \
	 (echo "[${APP_CODENAME}] install."))

clean:
	((echo "[${APP_CODENAME}] clean...") && \
	 (if [ -d ${DIST} ]; then rm -rf ${DIST}; fi) && \
	 (if [ -d ${TEST_OUT} ]; then rm -rf ${TEST_OUT}; fi) && \
	 (echo "[${APP_CODENAME}] clean."))

build:
	((echo "[${APP_CODENAME}] build...") && \
	 (if [ ! -d ${DIST} ]; then mkdir ${DIST}; fi) && \
	 (echo "[${APP_CODENAME}] compile...") && \
	 (if [ -d ${DIST} ]; then make --silent compile; fi) && \
	 (echo "[${APP_CODENAME}] compile.") && \
	 (echo "[${APP_CODENAME}] build."))

portable:
	((echo "[${APP_CODENAME}] portable setup...") && \
	 (if [ -f ~/.bash_aliases ]; then \
	    if [ "$(shell cat ~/.bash_aliases | grep ${APP_CMD})" = "" ]; then \
		  echo "alias ${APP_CMD}=\"${PWD}/dist/${APP_NAME}.sh\"">>~/.bash_aliases; fi ; \
		fi) && \
	 (echo "[${APP_CODENAME}] portable setup."))

git-release:
	((echo "[${APP_CODENAME}] git-release...") && \
	 (git flow release finish ; git push --all ; git push --tags) && \
	 (echo "[${APP_CODENAME}] git-release."))

test:
	((echo "[${APP_CODENAME}] Unit Tester run all...") && \
	 (if [ -d ${TEST_OUT} ]; then rm -rf ${TEST_OUT}; fi) && \
	 (/bin/bash src/test/sh/unit/run-all.sh ${unit}) && \
	 (echo "[${APP_CODENAME}] Unit Tester finished."))

e2e:
	((echo "[${APP_CODENAME}] E2E Tester run all...") && \
	 (/bin/bash src/test/sh/integration/run-all.sh ${testCase}) && \
	 (echo "[${APP_CODENAME}] E2E Tester finished."))

watch:
	((echo "[${APP_CODENAME}] FileWatcher start... '${PWD}/src/main/**/*'") && \
	 (make compile) && \
	 (while inotifywait -q -r -e modify,move,create,delete ./src/main/ >/dev/null; do \
	    make compile; \
	  done;) && \
	 (echo "[${APP_CODENAME}] FileWatcher finished."))

compile:
	((if [ -f ${RESOURCES}USAGE.txt ]; then make usage; fi) && \
	 (if [ -f ${PWD}/VERSION ]; then make version; fi) && \
	 (cat ${SRC_APP}main.sh >${DIST_FILE}) && \
	 (cat ${SRC_APP}parser.sh >>${DIST_FILE}) && \
	 (cat ${SRC_APP}loader.sh >>${DIST_FILE}) && \
	 (cat ${SRC_APP}validator.sh >>${DIST_FILE}) && \
	 (cat ${SRC_APP}router.sh >>${DIST_FILE}) && \
	 (find ${SRC_TASKS} -name '*.sh' -exec cat "{}" \; >>${DIST_FILE}) && \
	 (cat ${SRC_APP}runner.sh >>${DIST_FILE}) && \
	 (chmod 700 ${DIST_FILE}))

usage:
	((echo "doPrintUsage() {">${SRC_TASKS}doPrintUsage.sh) && \
	 (echo "echo \"=============================================">>${SRC_TASKS}doPrintUsage.sh) && \
	 (cat ${RESOURCES}USAGE.txt >>${SRC_TASKS}doPrintUsage.sh) && \
	 (echo "\"">>${SRC_TASKS}doPrintUsage.sh) && \
	 (echo "}">>${SRC_TASKS}doPrintUsage.sh))

version:
	((echo "doPrintVersion() {">${SRC_TASKS}doPrintVersion.sh) && \
	 (echo "echo \"${APP_NAME} v${APP_VERSION}\"">>${SRC_TASKS}doPrintVersion.sh) && \
	 (echo "}">>${SRC_TASKS}doPrintVersion.sh))
