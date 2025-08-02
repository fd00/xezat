#!/usr/bin/bash

bashvar()
{
  compgen -v | while read var; do declare -p "$var"; done
}

source ${CYGPORT:-/usr/bin/cygport} $* bashvar
