#!/bin/sh

if command -v perl >/dev/null 2>&1 ;then
   perl pwd-mysql.pl 127.0.0.1 $1 $2 $3
else
   python pwd-mysql.py 127.0.0.1 $1 $2 $3
fi
