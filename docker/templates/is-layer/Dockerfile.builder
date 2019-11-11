#This is essentially store/softwareag/commandcentral:${TAG}-builder with extra customizations
FROM softwareag/custombuilder:10.1

# this is just to store the work done by the builder...
# This image is not meant to be run as is...
# but rather extended to copy only the needed files

ENTRYPOINT ["echo", "This image is not meant to be instantiated"]