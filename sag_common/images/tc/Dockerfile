#FROM store/softwareag/commandcentral:10.1.0.1-builder as builder
# Use instead the custom CCE-builder tht contains the repos and licenses
FROM registry.docker.tests:5000/softwareag/commandcentral/custom/empower:10.1-builder as builder

# ADOPTED from docker file created by UM install
FROM centos:7

MAINTAINER fabien.sanglier@softwareaggov.com

ENV SAG_HOME=/opt/softwareag
ENV JAVA_HOME $SAG_HOME/jvm/jvm/

# Set path to the main executable folder in the IS profile
ENV PATH=/bin:/usr/bin:$JAVA_HOME/bin

#copy specific files (for now, all, but soon chose only the ones needed)
COPY --from=builder $JAVA_HOME $JAVA_HOME
COPY --from=builder $SAG_HOME/Terracotta/server $SAG_HOME/Terracotta/server

# Expose the default server port, the default replication port, and the default management port
EXPOSE 9510 9530 9540

# This is the current working directory
WORKDIR /opt/softwareag/Terracotta/server/wrapper/bin

# this volumes allows the host filesystem to persist the data  (avoiding the cost of the Union Filesystem)
VOLUME /opt/softwareag/Terracotta/server/wrapper/data

LABEL com.softwareag.product="wM Terracotta" \com.softwareag.product.version="10.1.0.0"

#add entrypoint in the global bin
COPY entrypoint.sh /usr/bin

ENTRYPOINT ["entrypoint.sh"]