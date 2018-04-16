# sagdevops-infra-docker

Author: Fabien Sanglier

Sample Docker files and scripts to build a full SoftwareAG environment using Docker.
(currently, IS, BPMS, MWS, Terracotta, Universal Messaging)

## Requirements

### Docker common resources

Of course, Docker should be installed!

And all docker-compose files in this project use the same docker network "sagdevops".
Let's create it first:

```
$ docker network create sagdevops
```

## Rest of the Doc ASAP