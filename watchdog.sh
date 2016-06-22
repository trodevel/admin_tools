#!/bin/bash

# $Revision: 3916 $ $Date:: 2016-06-23 #$ $Author: serge $

mail_alert()
{
    local NAME=$1
    local STAMP=$2
    local EMAIL=$3

    echo "$STAMP no process \"$NAME\" was running, restarted" | mailx -s "no process running - $NAME" $EMAIL
}

PATH_BIN=$1
NAME=$2
EMAIL=$3

[[ -z "$PATH_BIN" ]] && echo "ERROR: path to binary is not specified" >&2 && exit

if [ -z "$NAME" ]
then
    NAME=$( basename "${PATH_BIN}" )
fi

DIR=$( dirname "${PATH_BIN}" )

#echo NAME=$NAME
#echo DIR=$DIR
#echo EMAIL=$EMAIL

STDOUT=${DIR}/watchdog_${NAME}_stdout.txt
STDERR=${DIR}/watchdog_${NAME}_stderr.txt
LOG=${DIR}/watchdog_${NAME}.txt


APP=$( ps -A | grep -w $NAME )

if ! [ -n "$APP" ]
then
    STAMP=$( date --utc +%FT%TZ )
    echo "$STAMP no process is running, restarting" >>$LOG
    echo -e "\n****** $STAMP ****** RESTARTED ******\n" >>$STDERR
    echo -e "\n****** $STAMP ****** RESTARTED ******\n" >>$STDOUT
    $PATH_BIN 2>>$STDERR >>$STDOUT
    [[ -n "$EMAIL" ]] && mail_alert $NAME "$STAMP" $EMAIL
    exit
fi
