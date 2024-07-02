#!/bin/bash
#<include ldt-logger>

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
        --chmod)
            LDT_COMPILER_CHMOD_FLAG=true
            ;;
        --debug)
            LDT_COMPILER_DEBUG_MODE=true
            ;;
        -f | --fileName)
            LDT_COMPILER_FILE_NAME_FLAG=true
            ;;
        -i | --input)
            LDT_COMPILER_INPUT_FLAG=true
            ;;
        -o | --output)
            LDT_COMPILER_OUTPUT_FLAG=true
            ;;
        -t | --target)
            LDT_COMPILER_TARGET_FLAG=true
            ;;
        *)
            if [ "$LDT_COMPILER_CHMOD_FLAG" = "true" ]; then
                LDT_COMPILER_CHMOD_FLAG=false
                LDT_COMPILER_CHMOD=$arg
                continue
            fi
            if [ "$LDT_COMPILER_FILE_NAME_FLAG" = "true" ]; then
                LDT_COMPILER_FILE_NAME_FLAG=false
                LDT_COMPILER_FILE_NAME=$arg
                continue
            fi
            if [ "$LDT_COMPILER_INPUT_FLAG" = "true" ]; then
                LDT_COMPILER_INPUT_FLAG=false
                LDT_COMPILER_INPUT=$arg
                continue
            fi
            if [ "$LDT_COMPILER_OUTPUT_FLAG" = "true" ]; then
                LDT_COMPILER_OUTPUT_FLAG=false
                LDT_COMPILER_OUTPUT=$arg
                continue
            fi
            if [ "$LDT_COMPILER_TARGET_FLAG" = "true" ]; then
                LDT_COMPILER_TARGET_FLAG=false
                LDT_COMPILER_TARGET=$arg
                continue
            fi
            args+=($arg)
            ;;
        esac
    done
}
load() {
    ## load:variables
    ldtc_chmod=700
    ldtc_cmd=$1
    ldtc_fileName=
    ldtc_input=
    ldtc_me=$(whoami)
    ldtc_output=
    ldtc_target=bash-application
    ldtc_workindDir=$PWD
    shift

    ## load:environment
    if [ -f $ldtc_workindDir/.env ]; then
        export $(cat $ldtc_workindDir/.env | xargs)
    fi
    if [ -f $ldtc_workindDir/ldtc.env ]; then
        export $(cat $ldtc_workindDir/ldtc.env | xargs)
    fi
    if [ -f $ldtc_workindDir/ldt-compiler.env ]; then
        export $(cat $ldtc_workindDir/ldt-compiler.env | xargs)
    fi

    ## load:logger
    logger="eval echo"
    if [ ! "$(command -v ldtl)" = "" ]; then logger=ldtl; fi
    if [ ! "$(command -v $ldtl)" = "" ]; then logger=$ldtl; fi
    if [ ! "$(command -v ldt-logger)" = "" ]; then logger=ldt-logger; fi
    if [ ! "$(command -v ldtLogger)" = "" ]; then logger=ldtLogger; fi
    LDT_LOGGER_LOGPREFIX="LDTC"
    if [ "$LDT_COMPILER_DEBUG_MODE" = "true" ]; then
        LDT_LOGGER_LOGLEVEL=DEBUG
    else
        LDT_LOGGER_LOGLEVEL=WARN
    fi
    export LDT_LOGGER_LOGPREFIX
    export LDT_LOGGER_LOGLEVEL

    ## load:target
    if [ ! "$LDT_COMPILER_TARGET" = "" ]; then
        ldtc_target=$LDT_COMPILER_TARGET
    fi

    ## load:in-out
    if [ ! "$LDT_COMPILER_INPUT" = "" ]; then
        ldtc_input=$LDT_COMPILER_INPUT
    fi
    if [ ! "$LDT_COMPILER_OUTPUT" = "" ]; then
        ldtc_output=$LDT_COMPILER_OUTPUT
    fi
    if [ ! "$LDT_COMPILER_FILE_NAME" = "" ]; then
        ldtc_fileName=$LDT_COMPILER_FILE_NAME
    fi
    if [ ! "$LDT_COMPILER_CHMOD" = "" ]; then
        ldtc_chmod=$LDT_COMPILER_CHMOD
    fi
}
validate() {
    ## validate:command
    if [ "$ldtc_cmd" = "" ]; then ldtc_cmd=compile; fi
    if [ "$ldtc_cmd" = "-h" ]; then ldtc_cmd=usage; fi
    if [ "$ldtc_cmd" = "--help" ]; then ldtc_cmd=usage; fi
    if [ "$ldtc_cmd" = "-u" ]; then ldtc_cmd=usage; fi
    if [ "$ldtc_cmd" = "--usage" ]; then ldtc_cmd=usage; fi
    if [ "$ldtc_cmd" = "usage" ]; then ldtc_target=print; fi
    if [ "$ldtc_cmd" = "-v" ]; then ldtc_cmd=version; fi
    if [ "$ldtc_cmd" = "--version" ]; then ldtc_cmd=version; fi
    if [ "$ldtc_cmd" = "version" ]; then ldtc_target=print; fi

    if [ ! "$ldtc_cmd" = "version" ] &&
        [ ! "$ldtc_cmd" = "usage" ] &&
        [ ! "$ldtc_cmd" = "compile" ]; then
        $logger logError "Unknown command!"
        $logger logDebug "-- cause: ldtc_cmd=$ldtc_cmd"
        exit 400
    fi

    ## validate:target
    if [ ! "$ldtc_target" = "print" ] &&
        [ ! "$ldtc_target" = "bash-app" ] &&
        [ ! "$ldtc_target" = "bash-application" ] &&
        [ ! "$ldtc_target" = "compose" ] &&
        [ ! "$ldtc_target" = "docker-compose" ] &&
        [ ! "$ldtc_target" = "nginx" ] &&
        [ ! "$ldtc_target" = "nginx-config" ]; then
        $logger logError "Unknown target!"
        $logger logDebug "-- cause: ldtc_target=$ldtc_target"
        exit 400
    fi

    ## validate:workingDirectory
    if [ "$ldtc_workindDir" = "" ]; then
        $logger logError "Working directory is required!"
        $logger logDebug "-- cause: ldtc_workindDir=$ldtc_workindDir"
        exit 404
    fi

    if [ ! -d "$ldtc_workindDir" ]; then
        $logger logError "Working directory is invalid!"
        $logger logDebug "-- cause: ldtc_workindDir=$ldtc_workindDir"
        exit 500
    fi

    ## validate:in-out
    if [ "$ldtc_input" = "" ]; then
        ldtc_input=$ldtc_workindDir
    fi

    if [ "$ldtc_output" = "" ]; then
        ldtc_output=$ldtc_workindDir/dist
    fi

    if [ "$ldtc_fileName" = "" ]; then
        distFileName=$(basename $ldtc_workindDir)
        if [ -f "$ldtc_workindDir/VERSION" ]; then
            distFileVersion=$(cat $ldtc_workindDir/VERSION)
        else
            distFileVersion=latest
        fi
        ldtc_fileName="$distFileName-$distFileVersion.sh"
    fi

    if [ "$ldtc_chmod" = "" ] ||
        [ "$ldtc_chmod" = "-1" ]; then
        ldtc_chmod=000
    fi
}
run() {
    if [ "$ldtc_cmd" = "version" ]; then
        if [ "$ldtc_target" = "print" ]; then doPrintVersion; fi
    fi
    if [ "$ldtc_cmd" = "usage" ]; then
        if [ "$ldtc_target" = "print" ]; then doPrintUsage; fi
    fi
    if [ "$ldtc_cmd" = "compile" ]; then
        if [ "$ldtc_target" = "bash-app" ]; then doCompileBashApplication; fi
        if [ "$ldtc_target" = "bash-application" ]; then doCompileBashApplication; fi
        if [ "$ldtc_target" = "compose" ]; then doCompileDockerCompose; fi
        if [ "$ldtc_target" = "docker-compose" ]; then doCompileDockerCompose; fi
        if [ "$ldtc_target" = "nginx" ]; then doCompileNginxConf; fi
        if [ "$ldtc_target" = "nginx-config" ]; then doCompileNginxConf; fi
    fi
}
doPrintUsage() {
echo "=============================================
USAGE: ldtc <task> [args]

tasks:
  compile           -  compiles the project from the input folder to the output file in the output folder
  usage             -  prints the usage informations to the console
  version           -  prints the app-version to the console

args:
  --debug           -  allow to print more informative debug informations to the console
  --chmod           -  set the chmod value for the compiled script file
  -f                -  alias for fileName arg
  --fileName        -  set the output file name, if not set the default will be the following: \"\$output/\$projectName-\$projectVersion.sh\"
  -i                -  alias for input arg
  --input           -  set the input project path, if not set the default will be the working directory root path
  -o                -  alias for output arg
  --output          -  set the output folder path, if not set the default will be the \"dist/\" folder under the working directory 
  -t                -  alias for target arg
  --target          -  targets are the task controllers, allows you to complie more specificly

targets:
  print             -  only debug purposes, to debug if you develop the project
  bash-app          -  alias for bash-application target
  bash-application  -  the target of the compiler will be a bash script with separated script, but you want to compile those script files in one file
  compose           -  alias for docker-compose target
  docker-compose    -  the target of the compiler will be a docker-compose file with separated service definitions, and you want to create a fully configured docker-compose.yml file
  nginx             -  alias for nginx-config target
  nginx-config      -  the target of the compiler will be an nginx configuration file with more than one configuration possibilities
"
}
doPrintVersion() {
echo "ldt-compiler v1.0.0-SNAPSHOT"
}
doCompileDockerCompose() {
    $logger logDebug "running..."
    $logger logDebug "-- ldtc_cmd=$ldtc_cmd"
    $logger logDebug "-- ldtc_me=$ldtc_me"
    $logger logDebug "-- ldtc_target=$ldtc_target"
    $logger logDebug "-- ldtc_workindDir=$ldtc_workindDir"

    $logger logDebug "compile: Docker-Compose Services"
    $logger logDebug "-- -- ldtc_input=$ldtc_input"
    $logger logDebug "-- -- ldtc_output=$ldtc_output"
    $logger logDebug "-- -- ldtc_fileName=$ldtc_fileName"
    $logger logDebug "-- -- ldtc_chmod=$ldtc_chmod"

    echo "TODO: doCompileDockerCompose"

    $logger logDebug "compiled."
    $logger logDebug "done."
}
doCompileBashApplication() {
    $logger logDebug "running..."
    $logger logDebug "-- ldtc_me=$ldtc_me"
    $logger logDebug "-- ldtc_cmd=$ldtc_cmd"
    $logger logDebug "-- ldtc_target=$ldtc_target"
    $logger logDebug "-- ldtc_workindDir=$ldtc_workindDir"

    $logger logDebug "compile: Bash Application"
    $logger logDebug "-- -- ldtc_input=$ldtc_input"
    $logger logDebug "-- -- ldtc_output=$ldtc_output"
    $logger logDebug "-- -- ldtc_fileName=$ldtc_fileName"
    $logger logDebug "-- -- ldtc_chmod=$ldtc_chmod"

    if [ -d $ldtc_output ]; then rm -rf $ldtc_output; fi
    if [ ! -d $ldtc_output ]; then
        mkdir -p $ldtc_output
        touch $ldtc_output/$ldtc_fileName
    fi

    if [ -f $ldtc_input/src/main/resources/USAGE.txt ]; then
        echo "doPrintUsage() {" > \
            $ldtc_input/src/main/sh/tasks/doPrintUsage.sh
        echo "echo \"=============================================" >> \
            $ldtc_input/src/main/sh/tasks/doPrintUsage.sh
        cat $ldtc_input/src/main/resources/USAGE.txt >> \
            $ldtc_input/src/main/sh/tasks/doPrintUsage.sh
        echo "\"" >> \
            $ldtc_input/src/main/sh/tasks/doPrintUsage.sh
        echo "}" >> \
            $ldtc_input/src/main/sh/tasks/doPrintUsage.sh
    fi

    cat $ldtc_input/src/main/sh/app/main.sh > \
        $ldtc_output/$ldtc_fileName
    cat $ldtc_input/src/main/sh/app/parser.sh >> \
        $ldtc_output/$ldtc_fileName
    cat $ldtc_input/src/main/sh/app/loader.sh >> \
        $ldtc_output/$ldtc_fileName
    cat $ldtc_input/src/main/sh/app/validator.sh >> \
        $ldtc_output/$ldtc_fileName
    cat $ldtc_input/src/main/sh/app/router.sh >> \
        $ldtc_output/$ldtc_fileName
    find $ldtc_input/src/main/sh/tasks/ -name '*.sh' -exec cat "{}" \; >> \
        $ldtc_output/$ldtc_fileName
    cat $ldtc_input/src/main/sh/app/runner.sh >> \
        $ldtc_output/$ldtc_fileName

    $logger logDebug "compiled."

    chmod $ldtc_chmod $ldtc_output/$ldtc_fileName

    $logger logDebug "done."
}
doCompileNginxConf() {
    $logger logDebug "running..."
    $logger logDebug "-- ldtc_me=$ldtc_me"
    $logger logDebug "-- ldtc_cmd=$ldtc_cmd"
    $logger logDebug "-- ldtc_target=$ldtc_target"
    $logger logDebug "-- ldtc_workindDir=$ldtc_workindDir"

    $logger logDebug "compile: Nginx Configuration"
    $logger logDebug "-- -- ldtc_input=$ldtc_input"
    $logger logDebug "-- -- ldtc_output=$ldtc_output"
    $logger logDebug "-- -- ldtc_fileName=$ldtc_fileName"
    $logger logDebug "-- -- ldtc_chmod=$ldtc_chmod"

    echo "TODO: doCompileNginxConf"

    $logger logDebug "compiled."
    $logger logDebug "done."
}
main $*
