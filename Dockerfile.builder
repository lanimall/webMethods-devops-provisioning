ARG PARENT_IMAGE

FROM $PARENT_IMAGE

#FROM store/softwareag/commandcentral:10.1.0.1-server
#FROM registry.docker.tests:5000/softwareag/commandcentral/custom/empower:10.1-server as builder

MAINTAINER fabien.sanglier@softwareaggov.com

# build args
ONBUILD ARG ENV_TYPE
ONBUILD ARG CC_TEMPLATE
ONBUILD ARG CC_TEMPLATE_ENV
ONBUILD ARG CC_SPM_HOST
ONBUILD ARG CC_SPM_PORT
ONBUILD ARG REPO_USR
ONBUILD ARG REPO_PWD

ONBUILD ENV ENV_TYPE=$ENV_TYPE
ONBUILD ENV CC_TEMPLATE=$CC_TEMPLATE
ONBUILD ENV CC_TEMPLATE_ENV=$CC_TEMPLATE_ENV
ONBUILD ENV CC_SPM_HOST=$CC_SPM_HOST
ONBUILD ENV CC_SPM_PORT=$CC_SPM_PORT
ONBUILD ENV REPO_USR=$REPO_USR
ONBUILD ENV REPO_PWD=$REPO_PWD

ADD . /src
WORKDIR /src

# start tooling, apply licenses, apply repos, template(s), and cleanup
ONBUILD RUN sagccant startcc apply_licenses && \
    sagccant setup -Denv.CC_TEMPLATE=sag-repos -Denv.CC_TEMPLATE_ENV=sag-repos && \
    sagccant setup -Dbuild.dir=/tmp && \
    sagccant stopcc && \
    cd /opt/softwareag && rm -fr /tmp/* common/conf/nodeId.txt profiles/SPM/logs/* profiles/CCE/logs/*