# MUST start with builder image to run provisioning using template.yaml
#FROM store/softwareag/commandcentral:10.1.0.1-server
FROM registry.docker.tests:5000/softwareag/commandcentral/custom/empower:10.1-server as builder

MAINTAINER fabien.sanglier@softwareaggov.com

# build args
ONBUILD ARG ENV_TYPE
ONBUILD ARG CC_TEMPLATE
ONBUILD ARG CC_TEMPLATE_ENV
ONBUILD ARG CC_SPM_HOST
ONBUILD ARG CC_SPM_PORT

ONBUILD ENV ENV_TYPE=$ENV_TYPE
ONBUILD ENV CC_TEMPLATE=$CC_TEMPLATE
ONBUILD ENV CC_TEMPLATE_ENV=$CC_TEMPLATE_ENV
ONBUILD ENV CC_SPM_HOST=$CC_SPM_HOST
ONBUILD ENV CC_SPM_PORT=$CC_SPM_PORT

ADD . /src
WORKDIR /src

# start tooling, apply template(s), cleanup
ONBUILD RUN sagccant startcc setup stopcc -Dbuild.dir=/tmp && \
    cd /opt/softwareag && rm -fr /tmp/* common/conf/nodeId.txt profiles/SPM/logs/* profiles/CCE/logs/*