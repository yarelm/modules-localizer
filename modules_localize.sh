#!/usr/bin/env bash

helpfunc()
{
    echo "modules_localize allows you to temporarily replace a Go module with a local version"
    echo "replace [local pkg path] [module] - replace module to local version"
    echo "undo [local pkg path] [module] - revert to the original version"
    echo "example: modules_localize.sh replace ~/go/src/github.com/yarelm/somemodule github.com/yarelm/somemodule"
    echo "example: modules_localize.sh undo ~/go/src/github.com/yarelm/somemodule github.com/yarelm/somemodule"
}

PKGPATH=$2
MODULES=$3

replace()
{
    if [ ! -f $PKGPATH/go.mod ]; then
        # In this case, this is not a Go modules supported pkg. Let's create a dummy go.mod file
        touch $PKGPATH/go.mod
        touch $PKGPATH/gomod.temp
    fi

    go mod edit -replace=$MODULES=$PKGPATH go.mod
}

undo()
{
    if [ -f $PKGPATH/gomod.temp ]; then
        # Remove the dummy file if exists
        rm $PKGPATH/go.mod
        rm $PKGPATH/gomod.temp
    fi

    go mod edit -dropreplace=$MODULES go.mod
}

#filename=default
while (( $# > 0 ))
do
    opt="$1"
    shift

    case $opt in
    help)
        helpfunc
        exit 0
        ;;
    replace)
        replace
        exit 0
        ;;
    undo)
       undo
       exit 0
        ;;
    *)
        helpfunc
        exit 0
        ;;
   esac

done
