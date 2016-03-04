#!/bin/bash

<<'COMMENT'

Profile Memory & CPU

Copyright (C) 2016 Sergey Kolevatov

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

# $Revision: 3549 $ $Date:: 2016-03-04 #$ $Author: serge $

PROG=$1
LOG_MASK=$2

[[ -z "$PROG" ]] && echo "ERROR: program name is not specified" >&2 && exit
[[ -z "$LOG_MASK" ]] && echo "ERROR: log path is not specified" >&2 && exit

LOG_FILE=${LOG_MASK}_${PROG}

print_header()
{
    local log=$1

    echo "DATE;TIME;PROG;PCPU;PMEM;RSS;VSIZE;ETIME" >> $log
}

check_day_rotation()
{
    local old_datum=$1
    local new_datum=$2
    local log=$3

    if [ "$old_datum" != "$new_datum" ]
    then
        if [ ! -f "$log" ]
        then
            print_header "$log"
        fi
    fi
}

old_datum=""

while true;
do
    datum=$( date -u +"%Y-%m-%d" )
    log=${LOG_FILE}_${datum}.csv

    check_day_rotation "$old_datum" "$datum" "$log"

    ts=$( date -u +"%Y-%m-%d %T" )
    prof_info=$( ps -U $USER -o fname,pcpu,pmem,rss,vsize,etime | grep "$PROG " )

    echo "$ts $prof_info" | sed 's/  \+/ /g' | tr ' ' ';' >> $log
    sleep 1
done
