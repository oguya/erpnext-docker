FROM oguya/erpnext-docker:base_image

ARG FRAPPE_HOMEDIR="/home/frappe"
ARG FRAPPE_DIR=${FRAPPE_HOMEDIR}/frappe-bench

CMD ${FRAPPE_HOMEDIR}/scripts/run.sh