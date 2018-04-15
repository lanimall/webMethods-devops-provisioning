# MUST start with builder image to run provisioning using template.yaml
FROM store/softwareag/commandcentral:10.1.0.1-server

MAINTAINER fabien.sanglier@softwareaggov.com

ADD . /src
WORKDIR /src

ENTRYPOINT ["sagccant","setup"]
