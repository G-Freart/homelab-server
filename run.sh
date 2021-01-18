#!/bin/bash

# ------------------------------------------------------------------------------------------ #
#                                                                                            #
#                Copyright (c) 2021 - Gilles Freart. All right reserved                      #
#                                                                                            #
#  Licensed under the MIT License. See LICENSE in the project root for license information.  #
#                                                                                            #
# ------------------------------------------------------------------------------------------ #

OS=""
CURRENT_USER=`whoami`

if [ "$CURRENT_USER" == "root" ]
then
  echo
  echo "You are not allowed to run this script as root"
  echo

  exit
fi

if [ -f /etc/lsb-release ]
then
  DISTRIB_ID=`grep -e 'DISTRIB_ID=' /etc/lsb-release | sed -e 's/DISTRIB_ID=//g'`
  DISTRIB_RELEASE=`grep -e 'DISTRIB_RELEASE=' /etc/lsb-release | sed -e 's/DISTRIB_RELEASE=//g'`

  OS="${DISTRIB_ID} ${DISTRIB_RELEASE}"
fi	

if [ -f /etc/redhat-release ]
then
  RELEASE=`cat /etc/redhat-release`

  if [ "${RELEASE}" == "CentOS Stream release 8" ]; then OS="CentOS 8 Stream"
  fi
   	
fi	

if [ "${OS}" != "" ]
then	
  ansible-playbook main.yaml --extra-var "os='${OS}' username='${CURRENT_USER}'"
fi  
