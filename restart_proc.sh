#!/bin/bash

<<'COMMENT'

A tool to restart a process

Copyright (C) 2017 Sergey Kolevatov

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

COMMENT

# $Revision: 5888 $ $Date:: 2017-03-02 #$ $Author: serge $

gl_res=""

function get_pid
{
    local name=$1

    local PS=$( ps -u $USER -A | grep -w $name )

    local a=( $PS )

    local PID=${a[0]}

    if [ -z "$PID" ]
    then
        return 0
    fi

    gl_res=$PID
    return 1
}

PATH_APP=$1
PROC_NAME=$2

[[ -z "$PATH_APP" ]] && echo "ERROR: path to binary is not specified" >&2 && exit

if [ -z "$PROC_NAME" ]
then
    PROC_NAME=$( basename "${PATH_APP}" )
fi

DIR=$( dirname "${PATH_APP}" )

STAMP=$( date --utc "+%F %T UTC" )
echo "executed - $STAMP"

get_pid $PROC_NAME
PID=$gl_res

if [ -z "$PID" ]
then
    echo "no process found"
else
    echo "found process PID = $PID"

    kill $PID

    while [ -e "/proc/$PID" ];
    do
        sleep 1
        echo -n "."
    done

    echo
fi

echo "starting $PATH_APP"

$PATH_APP

get_pid $PROC_NAME
NEW_PID=$gl_res

echo "new process PID = $NEW_PID"
