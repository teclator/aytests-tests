#!/bin/bash
set -x

# Check if expected sections are in the profile.
AUTOINST="/root/autoinst.xml"

# Expected sections to be present in autoinst.xml
EXPECTED=(add-on bootloader ca_mgm deploy_image firewall general groups host \
  kdump keyboard language login_settings networking ntp-client partitioning \
  printer proxy report services-manager software timezone user_defaults users\
  ssh_import)

# Install xmlstartlet if it is not already available
rpm -qi xmlstarlet || zypper --non-interactive in xmlstarlet

# Current present sections in autoinst.xml
readarray -t PRESENT < <(xmlstarlet sel -N 'yast2ns=http://www.suse.com/1.0/yast2ns' --template -match "//yast2ns:profile/*" --value-of "name()" --nl $AUTOINST)

MISSING=()
for section in "${EXPECTED[@]}"
do
  if [[ ! " ${PRESENT[*]} " =~ " $section " ]]
  then
    MISSING+=($section)
  fi
done

UNEXPECTED=()
for section in "${PRESENT[@]}"
do
  if [[ ! " ${EXPECTED[*]} " =~ " $section " ]]
  then
    UNEXPECTED+=($section)
  fi
done

OK=true
if [[ ${#MISSING[@]} -ne 0 ]]
then
  OK=false
  echo "[DEBUG] missing sections: ${MISSING[*]}"
fi

if [[ ${#UNEXPECTED[@]} -ne 0 ]]
then
  OK=false
  echo "[DEBUG] unexpected sections: ${UNEXPECTED[*]}"
fi

$OK && echo "AUTOYAST OK"
