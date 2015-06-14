#!/bin/bash

# $Revision: 1860 $ $Date:: 2015-06-14 #$ $Author: serge $

PATH_BIN=$1
NAME=$2

if [ -z "$PATH_BIN" ]
then
    echo "ERROR: path to binary is not specified" >&2
    exit
fi

if [ -z "$NAME" ]
then
    NAME=$( basename "${PATH_BIN}" )
fi

DIR=$( dirname "${PATH_BIN}" )

#echo NAME=$NAME
#echo DIR=$DIR

STDOUT=${DIR}/watchdog_${NAME}_stdout.txt
STDERR=${DIR}/watchdog_${NAME}_stderr.txt
LOG=${DIR}/watchdog_${NAME}.txt


APP=$( ps -A | grep -w $NAME )

if ! [ -n "$APP" ]
then
    STAMP=$( date --utc +%FT%TZ )
    echo "$STAMP no binary is running, restarting" >>$LOG
    $PATH_BIN 2>$STDERR >$STDOUT
    exit
fi
