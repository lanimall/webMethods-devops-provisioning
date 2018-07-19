#!/bin/bash

SAGCCANT_CMD="sagccant"

##### apply repos, licenses, mirrors, etc...
## Make sure that EMPOWER_PSW and EMPOWER_PSW are defined in the shell $HOME/.bashrc or $HOME/.bash_profile
## or provide them here -DEMPOWER_PSW= -DEMPOWER_PSW=

$SAGCCANT_CMD apply_licenses

$SAGCCANT_CMD -Denv.CC_TEMPLATE=sag-repos  \
                -Denv.CC_TEMPLATE_ENV=sag-repos  \
                -Denv.CC_SAG_REPO_USR=$CC_SAG_REPO_USR  \
                -Denv.CC_SAG_REPO_PWD=$CC_SAG_REPO_PWD \
                setup

$SAGCCANT_CMD -Denv.CC_TEMPLATE=cc-tuneup  \
                -Denv.CC_TEMPLATE_ENV=cc \
                setup

$SAGCCANT_CMD -Denv.CC_TEMPLATE=cc-update  \
                -Denv.CC_TEMPLATE_ENV=cc \
                setup