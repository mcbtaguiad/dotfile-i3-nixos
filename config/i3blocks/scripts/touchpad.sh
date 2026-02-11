#!/usr/bin/env bash
# Copyright (C) 2014 Julien Bonjean <julien@bonjean.info>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.



icon_color=${icon_color:-}

declare -i ID
ID=`xinput list | grep -Eio '(touchpad|glidepoint)\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}'`
declare -i STATE
STATE=`xinput list-props $ID|grep 'Device Enabled'|awk '{print $4}'`
if [ $STATE -gt "0" ]
then
    # echo ""
    echo "T"
else
    
    # echo ""
    echo "T"
    echo
    echo $icon_color
    #839275
    #575758
fi

exit 0
