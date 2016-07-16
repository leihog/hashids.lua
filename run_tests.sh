#!/bin/bash

OK=42
ERR=41
INFO=47

show_msg() {
    echo -e "\n\e[30m\e[$1m::: $2 :::\e[0m\n"
}

cd "$(dirname "$0")"

show_msg $INFO "installing hashids"
luarocks make
rm -rf hashids

show_msg $INFO "testing"
busted
STATUS=$?
if [ $STATUS -ne 0 ]
then
    show_msg $ERR "tests failed"
else
    show_msg $OK "all tests passed"
fi

show_msg $INFO "uninstalling hashids"
luarocks remove hashids

exit $STATUS
