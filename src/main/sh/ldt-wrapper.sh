#!/bin/sh

main() {
    ldtFolder=$(realpath $(dirname "$0")/.ldt)
    if [ ! -d $ldtFolder ]; then mkdir -p $ldtFolder; fi
    ldtScript=$(realpath $(dirname "$0")/.ldt/ldt)
    if [ "$1" = "clean" ] ||
        [ "$1" = "--clean" ] ||
        [ "$1" = "-c" ]; then
        clean $ldtFolder
        exit 0
    fi
    if [ "$1" = "install" ] ||
        [ "$1" = "--install" ] ||
        [ "$1" = "-i" ]; then
        setup $ldtFolder
        exit 0
    fi
    if [ ! -f $ldtScript ]; then
        echo "INF: ldt setup will make everything up-and-run."
        setup $ldtFolder
        echo "INF: ldt setup is done. Please run again..."
        exit 0
    fi
    if [ "$1" = "update" ] ||
        [ "$1" = "--update" ] ||
        [ "$1" = "-u" ]; then
        update $ldtFolder
        exit 0
    fi
    if [ "$(command -v bash)" = "" ]; then
        echo "ERR: ldt requires 'bash' to be installed."
        exit 1
    fi
    echo $ldtScript $*
}
clean() {
    rm -rf $1
}
setup() {
    mkdir -p $1
    bin=$1/bin
    mkdir -p $bin
    lib=$1/lib
    mkdir -p $lib
    res=$1/res
    mkdir -p $res
    projects=$(realpath $(dirname "$0")/../projects)
    cp $projects/ldt/dist/ldt-1.0.0-SNAPSHOT.sh $1/ldt
    cp $projects/ldt-compiler/dist/ldt-compiler-1.0.0-SNAPSHOT.sh $bin/ldtc
    cp $projects/ldt-logger/dist/ldt-logger-1.0.0-SNAPSHOT.sh $bin/ldtl
}
update() {
    bin=$1/bin
    projects=$(realpath $(dirname "$0")/../projects)
    cp $projects/ldt-compiler/dist/ldt-compiler-1.0.0-SNAPSHOT.sh $bin/ldtc
    cp $projects/ldt-logger/dist/ldt-logger-1.0.0-SNAPSHOT.sh $bin/ldtl
}
main $*
