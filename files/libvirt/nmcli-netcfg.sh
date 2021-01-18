#!/bin/bash

# ------------------------------------------------------------------------------------------ #
#                                                                                            #
#                Copyright (c) 2021 - Gilles Freart. All right reserved                      #
#                                                                                            #
#  Licensed under the MIT License. See LICENSE in the project root for license information.  #
#                                                                                            #
# ------------------------------------------------------------------------------------------ #


BRIDGE_MOD_RET=`lsmod | grep bridge | wc -l`

if [ "$VIRBR0_EXIST" == "0" ];
then
  modprobe --first-time bridge

  if [ $? -ne 0 ];
  then
    echo "Unable to load bridge module within kernel"

    exit 1
  fi    
fi


VIRBR0_EXIST=`nmcli connection show | sed -e '/^.*ethernet.*$/d' | sed -e '/NAME.*UUID.*/d' | grep -e virbr0 | wc -l`

if [ "$VIRBR0_EXIST" == "0" ];
then
  echo "Deleting old connection"

  for device in `ip l | sed 's/^ *[0-9]\+: \([^ ]\+\):.*/\1/p;d'`;
  do
    if [ "$device" != "lo" ];
    then
      connection=`nmcli dev show $device | grep -e "GENERAL.CONNECTION" | sed -e 's/.*:\ *//g'`

      if [ "$connection" != "--" ];
      then
        nmcli connection down   "$connection"
        nmcli connection delete "$connection"
      fi    
    fi	    
  done

  echo "Setup virbr0 connection"

  nmcli connection add type bridge con-name virbr0 ifname virbr0

  nmcli connection modify virbr0  ipv6.method     disabled
  nmcli connection modify virbr0 +ipv4.routes     "192.168.0.0/24 0.0.0.0"
  nmcli connection modify virbr0 +ipv4.routes     "0.0.0.0/24 192.168.0.1"
  nmcli connection modify virbr0  ipv4.addresses  '192.168.0.51/24'
  nmcli connection modify virbr0  ipv4.gateway    '192.168.0.1'
  nmcli connection modify virbr0  ipv4.dns        '192.168.0.50 8.8.8.8 8.8.4.4'
  nmcli connection modify virbr0  ipv4.dns-search 'home.local'
  nmcli connection modify virbr0  ipv4.method     manual
  nmcli connection modify virbr0  bridge.stp      no

  echo "Setup bridge-virbr0 connection"
  nmcli connection add type ethernet slave-type bridge con-name bridge-virbr0 ifname eno1 master virbr0

  echo "Starting virbr0 connection"
  nmcli connection up  virbr0
else
  echo "virbr0 already exists"
fi

exit 0
