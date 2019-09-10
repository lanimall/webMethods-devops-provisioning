#!/usr/bin/env bash

webmethods_cc_password=
webmethods_repo_username=
webmethods_repo_password=
webmethods_cc_ssh_key_filename=
webmethods_cc_ssh_key_pwd=
webmethods_cc_ssh_user=

echo "export CC_PASSWORD=\"${webmethods_cc_password}\"" > ${HOME}/setenv_cce_init_secrets.sh
echo "export CC_SAG_REPO_USR=\"${webmethods_repo_username}\"" >> ${HOME}/setenv_cce_init_secrets.sh
echo "export CC_SAG_REPO_PWD=\"${webmethods_repo_password}\"" >> ${HOME}/setenv_cce_init_secrets.sh
echo "export CC_SSH_KEY_FILENAME=\"${webmethods_cc_ssh_key_filename}\"" >> ${HOME}/setenv_cce_init_secrets.sh
echo "export CC_SSH_KEY_PWD=\"${webmethods_cc_ssh_key_pwd}\"" >> ${HOME}/setenv_cce_init_secrets.sh
echo "export CC_SSH_USER=\"${webmethods_cc_ssh_user}\"" >> ${HOME}/setenv_cce_init_secrets.sh