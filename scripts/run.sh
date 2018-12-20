#!/usr/bin/env bash

## Executed on the first setup to install frappe & erpnext apps

FRAPPE_HOMEDIR=${1:-/home/frappe}
FRAPPE_DIR=${2:-$FRAPPE_HOMEDIR/frappe-bench}

## already exported in env
#FRAPPE_VERSION=v10.1.68
#ERPNEXT_VERSION=v10.1.68

cd $FRAPPE_HOMEDIR

if [[ ! -d ${FRAPPE_DIR}/apps/frappe ]]; then
    echo "First time setup! Installing Frappe $FRAPPE_VERSION"
    bench init --verbose --frappe-branch $FRAPPE_VERSION frappe-bench --ignore-exist --skip-redis-config-generation
    cd $FRAPPE_DIR
    cp Procfile_docker Procfile
    cp sites/common_site_config_docker.json sites/common_site_config.json
    bench set-mariadb-host mariadb
elif [[ ! -d ${FRAPPE_DIR}/apps/erpnext ]]; then
    echo "First time setup! Installing ERPNext $ERPNEXT_VERSION"
    cd $FRAPPE_DIR
    bench get-app --branch $ERPNEXT_VERSION erpnext https://github.com/frappe/erpnext
else
    echo "ERPNext and or Frappe apps dir already exist...skipping."
    bench start
fi