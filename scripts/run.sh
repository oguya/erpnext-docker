#!/usr/bin/env bash

## Executed on the first setup to install frappe & erpnext apps

FRAPPE_HOMEDIR=${1:-/home/frappe}
FRAPPE_DIR=${2:-$FRAPPE_HOMEDIR/frappe-bench}

## already exported in env
#FRAPPE_VERSION=v10.1.68
#ERPNEXT_VERSION=v10.1.68

## change permissions for sanity checks
sudo chown -R frappe:frappe /home/frappe/frappe-bench

cd $FRAPPE_HOMEDIR

if [[ ! -d ${FRAPPE_DIR}/apps/frappe ]]; then
    echo "First time setup! Installing Frappe $FRAPPE_VERSION"
    bench init --verbose --frappe-branch $FRAPPE_VERSION frappe-bench --ignore-exist --skip-redis-config-generation
    cd $FRAPPE_DIR
    cp Procfile_docker Procfile
    cp sites/common_site_config_docker.json sites/common_site_config.json
    bench set-mariadb-host mariadb
else
    echo "Frappe app dir already exist...skipping."
fi
if [[ ! -d ${FRAPPE_DIR}/apps/erpnext ]]; then
    echo "First time setup! Installing ERPNext $ERPNEXT_VERSION"
    cd $FRAPPE_DIR
    bench get-app --branch $ERPNEXT_VERSION erpnext https://github.com/frappe/erpnext
else
    echo "ERPNext app dir already exist...skipping."
fi

echo "Starting Bench"
cd $FRAPPE_DIR

## TODO: For debug purposes only
# bench start

## TODO: dev env, no debug
bench start --no-dev

## TODO: for prod envs
# cd $FRAPPE_DIR/sites
# /home/frappe/frappe-bench/env/bin/gunicorn frappe.app:application \
#     -b 0.0.0.0:8000 \
#     --workers=4 \
#     --timeout=120
