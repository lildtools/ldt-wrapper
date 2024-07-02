#!/bin/bash

main() {
    parse $*
    load "${args[@]}"
    validate
    run
    if [ $? -ne 0 ]; then exit 500; fi
    exit 0
}
parse() {
    args=()

    for arg in "$@"; do
        case "$arg" in
        --debug)
            LDT_LOGGER_DEBUG_MODE=true
            ;;
        *)
            args+=($arg)
            ;;
        esac
    done
}
load() {
    ## load:variables
    ldtl_cmd=$1
    ldtl_console=echo
    ldtl_logLevel=""
    ldtl_logLevel_current=""
    ldtl_logLevel_default=ERROR
    ldtl_logSeparator="---"
    ldtl_logPrefix=LDTL
    ldtl_me=$(whoami)
    ldtl_now=$(date +"%Y-%m-%d %H:%M:%S.%3N")
    ldtl_workindDir=$PWD
    shift

    ldtl_logMessage="$*"

    ## load:environment
    if [ -f $ldtl_workindDir/.env ]; then
        export $(cat $ldtl_workindDir/.env | xargs)
    fi
    if [ -f $ldtl_workindDir/ldtl.env ]; then
        export $(cat $ldtl_workindDir/ldtl.env | xargs)
    fi
    if [ -f $ldtl_workindDir/ldt-logger.env ]; then
        export $(cat $ldtl_workindDir/ldt-logger.env | xargs)
    fi
}
validate() {
    ## validate:logLevel-default
    if [ ! "$ldtl_logLevel_default" = "TRACE" ] &&
        [ ! "$ldtl_logLevel_default" = "DEBUG" ] &&
        [ ! "$ldtl_logLevel_default" = "INFO" ] &&
        [ ! "$ldtl_logLevel_default" = "WARN" ] &&
        [ ! "$ldtl_logLevel_default" = "ERROR" ]; then
        doLogFatal "default-logLevel ('$ldtl_logLevel_default') is invalid!"
        doLogFatal "logLevels = TRACE|DEBUG|INFO|WARN|ERROR"
        exit 500
    fi

    ## validate:logLevel-current
    if [ ! "$LDT_LOGGER_LOGLEVEL" = "" ]; then
        ldtl_logLevel_current=$LDT_LOGGER_LOGLEVEL
    else
        ldtl_logLevel_current=$ldtl_logLevel_default
    fi

    if [ ! "$LDT_LOGGER_LOGPREFIX" = "" ]; then
        ldtl_logPrefix=$LDT_LOGGER_LOGPREFIX
    fi

    if [ ! "$LDT_LOGGER_LOGSEPARATOR" = "" ]; then
        ldtl_logSeparator=$LDT_LOGGER_LOGSEPARATOR
    fi

    if [ ! "$ldtl_logLevel_current" = "TRACE" ] &&
        [ ! "$ldtl_logLevel_current" = "DEBUG" ] &&
        [ ! "$ldtl_logLevel_current" = "INFO" ] &&
        [ ! "$ldtl_logLevel_current" = "WARN" ] &&
        [ ! "$ldtl_logLevel_current" = "ERROR" ]; then
        doLogFatal "current-logLevel ('$ldtl_logLevel_current') is invalid!"
        doLogFatal "logLevels = TRACE|DEBUG|INFO|WARN|ERROR"
        exit 500
    fi

    ## validate:command
    if [ "$ldtl_cmd" = "" ]; then ldtl_cmd=usage; fi
    if [ "$ldtl_cmd" = "-h" ]; then ldtl_cmd=usage; fi
    if [ "$ldtl_cmd" = "--help" ]; then ldtl_cmd=usage; fi
    if [ "$ldtl_cmd" = "-u" ]; then ldtl_cmd=usage; fi
    if [ "$ldtl_cmd" = "--usage" ]; then ldtl_cmd=usage; fi
    if [ "$ldtl_cmd" = "-v" ]; then ldtl_cmd=version; fi
    if [ "$ldtl_cmd" = "--version" ]; then ldtl_cmd=version; fi

    if [ ! "$ldtl_cmd" = "version" ] &&
        [ ! "$ldtl_cmd" = "usage" ] &&
        [ ! "$ldtl_cmd" = "logTrace" ] &&
        [ ! "$ldtl_cmd" = "logDebug" ] &&
        [ ! "$ldtl_cmd" = "logInfo" ] &&
        [ ! "$ldtl_cmd" = "logWarn" ] &&
        [ ! "$ldtl_cmd" = "logError" ]; then
        doLogFatal "cmd ('$ldtl_cmd') is invalid!"
        doLogFatal "commands = logTrace|logDebug|logInfo|logWarn|logError"
        exit 400
    fi
}
run() {
    if [ "$ldtl_cmd" = "version" ]; then doPrintVersion; fi
    if [ "$ldtl_cmd" = "usage" ]; then doPrintUsage; fi
    if [ "$ldtl_cmd" = "logTrace" ]; then doLogTrace; fi
    if [ "$ldtl_cmd" = "logDebug" ]; then doLogDebug; fi
    if [ "$ldtl_cmd" = "logInfo" ]; then doLogInfo; fi
    if [ "$ldtl_cmd" = "logWarn" ]; then doLogWarn; fi
    if [ "$ldtl_cmd" = "logError" ]; then doLogError; fi
}
doLogTrace() {
    if [ "$ldtl_logLevel_current" = "TRACE" ]; then
        doLog "TRACE" $ldtl_logMessage
    fi
}
doLogFatal() {
    $ldtl_console "[LDTL] FATAL $ldtl_now $ldtl_logSeparator" $*
}
doLogError() {
    if [ "$ldtl_logLevel_current" = "TRACE" ] ||
        [ "$ldtl_logLevel_current" = "DEBUG" ] ||
        [ "$ldtl_logLevel_current" = "INFO" ] ||
        [ "$ldtl_logLevel_current" = "WARN" ] ||
        [ "$ldtl_logLevel_current" = "ERROR" ]; then
        doLog "ERROR" $ldtl_logMessage
    fi
}
doLogWarn() {
    if [ "$ldtl_logLevel_current" = "TRACE" ] ||
        [ "$ldtl_logLevel_current" = "DEBUG" ] ||
        [ "$ldtl_logLevel_current" = "INFO" ] ||
        [ "$ldtl_logLevel_current" = "WARN" ]; then
        doLog "WARN" $ldtl_logMessage
    fi
}
doLogDebug() {
    if [ "$ldtl_logLevel_current" = "TRACE" ] ||
        [ "$ldtl_logLevel_current" = "DEBUG" ]; then
        doLog "DEBUG" $ldtl_logMessage
    fi
}
doLog() {
    if [ "$LDT_LOGGER_DEBUG_MODE" = "true" ]; then
        $ldtl_console "-- ldtl_me=$ldtl_me"
        $ldtl_console "-- ldtl_cmd=$ldtl_cmd"
        $ldtl_console "-- ldtl_workindDir=$ldtl_workindDir"
        $ldtl_console "-- ldtl_console=$ldtl_console"
        $ldtl_console "-- ldtl_logPrefix=$ldtl_logPrefix"
        $ldtl_console "-- ldtl_logLevel=$ldtl_logLevel"
        $ldtl_console "-- ldtl_now=$ldtl_now"
        $ldtl_console "-- ldtl_logSeparator=$ldtl_logSeparator"
        $ldtl_console "-- ldtl_logMessage=$ldtl_logMessage"
    fi

    ldtl_logLevel=$1
    if [ "$ldtl_logLevel" = "" ]; then
        doLogFatal "logLevel (arg1) is required!"
        exit 500
    fi

    if [ "$ldtl_logMessage" = "" ]; then
        doLogFatal "logMessage (arg*) is required!"
        exit 500
    fi

    if [ ! "$ldtl_logLevel" = "FATAL" ] &&
        [ ! "$ldtl_logLevel" = "TRACE" ] &&
        [ ! "$ldtl_logLevel" = "DEBUG" ] &&
        [ ! "$ldtl_logLevel" = "INFO" ] &&
        [ ! "$ldtl_logLevel" = "WARN" ] &&
        [ ! "$ldtl_logLevel" = "ERROR" ]; then
        doLogFatal "logLevel ('$ldtl_logLevel') is invalid!"
        exit 400
    fi

    if [ "$ldtl_logLevel" = "WARN" ] ||
        [ "$ldtl_logLevel" = "INFO" ]; then
        ldtl_logLevel=" $ldtl_logLevel"
    fi

    $ldtl_console \
        "[$ldtl_logPrefix] $ldtl_logLevel $ldtl_now $ldtl_logSeparator $ldtl_logMessage"
}
doLogInfo() {
    if [ "$ldtl_logLevel_current" = "TRACE" ] ||
        [ "$ldtl_logLevel_current" = "DEBUG" ] ||
        [ "$ldtl_logLevel_current" = "INFO" ]; then
        doLog "INFO" $ldtl_logMessage
    fi
}
doPrintUsage() {
echo "=============================================
USAGE: ldtl <task> [args]

tasks:
  logDebug  -  log debug level messages to the console output
  logError  -  log error level messages to the console output
  logInfo   -  log information level messages to the console output
  logTrace  -  log trace level messages to the console output
  logWarn   -  log warning level messages to the console output
  usage     -  prints the usage informations to the console
  version   -  prints the app-version to the console

args:
  --debug   -  allow to print more informative debug informations to the console
"
}
doPrintVersion() {
echo "ldt-logger v1.0.0-SNAPSHOT"
}
main $*
