#!/bin/bash

if [ ! "$BASH_VERSION" ] ; then
    DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
else
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
fi

if [ $# -ne 3 ] ; then 
    echo "usage:$0 mysql_user [mysql_pass] mysql_port"
    exit 1
fi

if command -v perl >/dev/null 2>&1 ;then
   perl $DIR/pwd-mysql.pl 127.0.0.1 $1 $2 $3
else
   python $DIR/pwd-mysql.py 127.0.0.1 $1 $2 $3
fi
