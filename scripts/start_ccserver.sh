#!/bin/bash

SAGCCANT_CMD="sagccant"
CC_ENV=default

## apply env
if [ -f ${HOME}/setenv-cce.sh ]; then
    . ${HOME}/setenv-cce.sh
fi

## start cce
$SAGCCANT_CMD -Denv.CC_ENV=$CC_ENV startcc waitcc

exit 0;