#!/bin/sh

if command -v perl >/dev/null 2>&1 ;then
   perl pwd.pl
else
   python pwd.py
fi
