#!/bin/bash

set -e -x
# checking if dbus service has not been restarted
# bnc#937900

grep "restarting services" /var/log/YaST2/y2log| grep -v 'dbus.service' && echo "AUTOYAST OK"
