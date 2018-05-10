#!/bin/bash

if [ ! "$BASH_VERSION" ] ; then
    DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
else
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
fi

if command -v perl >/dev/null 2>&1 ;then
   perl $DIR/pwd.pl
else
   python $DIR/pwd.py
fi
