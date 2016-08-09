#!/bin/bash

OK=42
ERR=41
INFO=47

LUAROCKS_ARGS=""
BUSTED_ARGS=""
PRESERVE=false

show_msg() {
    echo -e "\n\e[30m\e[$1m::: $2 :::\e[0m\n"
}

cd "$(dirname "$0")"

for OPT in "$@"
do
    case $OPT in
        -l|--local)
            LUAROCKS_ARGS="$LUAROCKS_ARGS --local"
            ;;
        -v|--verbose)
            BUSTED_ARGS="$BUSTED_ARGS --verbose"
            ;;
        -p|--preserve)
            PRESERVE=true
            ;;
    esac
done

show_msg $INFO "installing hashids"
luarocks $LUAROCKS_ARGS make
rm -rf hashids

show_msg $INFO "testing"
busted $BUSTED_ARGS
STATUS=$?
if [[ $STATUS != 0 ]]
then
    show_msg $ERR "tests failed"
else
    show_msg $OK "all tests passed"
fi

if [[ $PRESERVE == true ]]
then
    show_msg $INFO "hashids wasn't removed due to --preserve option"
else
    show_msg $INFO "uninstalling hashids"
    luarocks $LUAROCKS_ARGS remove hashids
fi

exit $STATUS
