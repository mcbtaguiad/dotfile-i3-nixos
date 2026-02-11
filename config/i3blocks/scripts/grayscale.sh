#!/bin/sh
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

if [[ "${BLOCK_BUTTON}" -eq 1 ]]; then
    i3-msg -q -- exec ~/.local/bin/toggle-grayscale
fi


icon_color=${icon_color:-}

declare -i STATE
STATE=$(ps -aux | grep picom | grep grayscale | wc -l)
if [ $STATE -gt "0" ]
then
    echo "G"
else
    
    echo "G"
    echo
    echo $icon_color
    #839275
    #575758
fi


exit 0
