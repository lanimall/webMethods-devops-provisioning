# sagdevops-infra-docker

A sample project created to demomnstrate how to auto-provision complete SoftwareAG environments with Docker.

Author: Fabien Sanglier

## Table of content
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Quick Start: Provisioning Different Integration Server environments using Docker](#env_quickstart)
4. [Building Product-specific Docker Images](#building_product_docker)

## Introduction <a name="introduction"></a>

In this project, you can for example:
 - Selectively create standalone docker images of a specific SoftwareAG product
 - Selectively create managed docker images of a specific SoftwareAG product (meaning an image that could be auto-registred and managed by Command Central)
 - Leverage docker compose sample files to:
   - Provision a Command Central managed environment at runtime, leveraging bare-bone Command Central docker images (server, node, client) 
   and running "Setup" docker instance to perform the provisionning at runtime
   (which is really the same process of provisoning products on VMs as opposed to dockjer images)
   - Provision a non-managed environment using full docker images for each of the SoftwareAG product needed i nthe environment

## Prerequisites <a name="prerequisites"></a>

1. Of course, Docker should be installed - Check official Docker doc https://docs.docker.com/install/ for details.

2. Clone or Download this project

For git clone:
```
git clone --recurse https://github.com/lanimall/sagdevops-infra-docker.git
```

If you download instead of "git clone", it will not download the "antcc" submodule. 
So in this case, make sure to download that submodule separately and add it to the antcc subfolder.

2. Get the Command Central Docker Images from Docker Store. 
Note: The "10.1" tag should correspond to the latest fix in the 10.1 release (fix 8 at time of writing)

```
docker login
docker pull store/softwareag/commandcentral:10.1-builder
docker pull store/softwareag/commandcentral:10.1-server
docker pull store/softwareag/commandcentral:10.1-node
```

3. (OPTIONAL but good idea)
Then, if you want to NOT have to provison the DB instances (needed by some products) at runtime,
you'll need to have some base Oracle images with the right schemas pre-installed already.
To create some base ORacle images for IS, BPMS, or just MWS, a simple docker-based solution is explained at:
https://github.com/lanimall/sagdevops-dbcreator-docker

  Follow the instructions in the [README.md](https://github.com/lanimall/sagdevops-dbcreator-docker/blob/master/README.md)
to create base Docker images Oracle DBs for IS, BPM, MWS.

  At the end of this "sagdevops-dbcreator-docker" process, you should have the following images created:
 - YOUR_REGISTRY/softwareag/dbcreator:latest
 - YOUR_REGISTRY/softwareag_dbs/is-oracle:10.1
 - YOUR_REGISTRY/softwareag_dbs/mws-oracle:10.1
 - YOUR_REGISTRY/softwareag_dbs/bpms-oracle:10.1

  The docker image "softwareag/dbcreator" created by this project will also be useful with the runtime setup...
allowing to dynamically set product DBs on-the-fly using environment variables...
Refer to "setup_is_db" service in [docker-compose-managed-runtimesetup.yml](./docker-compose-managed-runtimesetup.yml) for details.

4. All the provisioning templates require:
    1. Connecting to a central product repository to download the binaries needed by the products and fixes to install.
  
       You'll need to update the file [environments/sag-repos.properties](environments/sag-repos.properties)
    and specify the right URLs, descriptions, and connection usename/password for the product/fix repos you'll want to use.
  
       For the username/passqword, it's perfectly valid (and frankly expected) to not want to hardcode this in the file.
    So these values can be passed via env variables with variables CC_SAG_REPO_USR and CC_SAG_REPO_PWD
    And if set, their values will be used by the scripts instead of the values in the 
    [environments/sag-repos.properties](environments/sag-repos.properties) file.
    
       To set these variables, several options are possible based on the OS you're working with.
    For linux or mac, I find that the simplest is to add these 2 variables in my  ~/.bash_profile as follow:

        ```
        export CC_SAG_REPO_USR=my_user
        export CC_SAG_REPO_PWD=my_secret_password
        ```
    
       And then, make sure you don't forget to source that file to load the variable in your shell:
    
        ```
        source ~/.bash_profile
        ```
  
       Final note: By default, it is already set to use SoftwareAG Empower central repository, which is usually a good choice
    if your machine / environment has access to the internet.
  
    2. The product licenses
     
     You'll need to add your product license files in the ./license directory, in the right subfolder 
     (since all docker images are based on Centos 7, the license must be put in the ./license/lnxamd64/ directory)
     
     NOTE: The various command central provisoning templates (as written) expect specific license alias names...
     So if you want everything to work as-is without having to modify the templates environment propoerties, I recommend you 
     follow this naming convention for the license files you put in the ./license/lnxamd64/:
     - Terracotta: "terracotta-license.key"
     - Universal Messaging: "UniversalMessaging.xml"
     - Integration Server: "Integration_Server.xml"
     - Business Rules: "Business_Rules.xml"
     - Mashzone Next Gen: "MashZoneNextGen.xml"

5. Finally, Build the "builder" image to be used by the other components
 
```
  docker-compose -f docker-compose-build.yml build
```
  
This will create 2 images for internal use only. No need to push them to a registry etc...
 - softwareag/custombuilder:10.1
 - softwareag/commandcentral:10.1-client
 
## Quick Start: Provisioning Different Integration Server environments using Docker  <a name="env_quickstart"></a>

Once the prerequisites are done, we're ready to build some docker images and full environments.

There are few different configurations available with different docker-compose files:
 - Integration Server "Stateful"
   - 2 Integration Servers set in cluster
   - 1 Oracle Database for IS schemas (shared accross both IS)
   - 1 Terracotta Server to managed IS cluster state
 - Integration Server "Stateful Messaging" ([docker-compose-runtimesetup-is_stateful_messaging.yml](./docker-compose-runtimesetup-is_stateful_messaging.yml))
   - 2 Integration Servers set in cluster
   - 1 Oracle Database for IS schemas (shared accross both IS)
   - 1 Terracotta Server to managed IS cluster state
   - 1 Universal Messaging server
 - Integration Server "Stateless Messaging" ([docker-compose-runtimesetup-is_stateless_messaging.yml](./docker-compose-runtimesetup-is_stateless_messaging.yml))
   - 2 Integration Servers (no cluster)
   - 1 Universal Messaging server

And you can certainly create your own...

And for each configurations, I've created 2 docker-compose files: 
 1. 1 docker file that creates some "bare" Linux nodes onto which the various products will get installed at runtime
 (docker here is only useful for easy provisoning of "server nodes"...and as such, this setup is really similar to provisoning products on VMs or bare-metal servers...)
 2. 1 docker file that uses pre-built docker images...and/or if the image is not yet built or available, will build it the first time

And that way, it will be easy to compare the differences between provisoning an environment from "pre-built / pre-configured docker images" versus "Runtime Command Central provisoning".

### Using pre-built / pre-configured docker images

NOTE before running: If you intent to use a docker private registry and possibly will want to push your images to it, 
make sure to update the [.env](.env) file with the right REGISTRY and version TAG you want to use.

NOTE 2: If it's the first time you run these command, it will take a while to create all the docker images...be patient!

#### Integration Server "Stateful" 

Docker-compose file: [docker-compose-fulldocker-is_stateful.yml](./docker-compose-fulldocker-is_stateful.yml)

```
docker-compose -f docker-compose-fulldocker-is_stateful.yml up -d
```

#### Integration Server "Stateful Messaging"

Docker-compose file: [docker-compose-fulldocker-is_stateful_messaging.yml](./docker-compose-fulldocker-is_stateful_messaging.yml)

```
docker-compose -f docker-compose-fulldocker-is_stateful_messaging.yml up -d
```

#### Integration Server "Stateless Messaging"

Docker-compose file: [docker-compose-fulldocker-is_stateless_messaging.yml](./docker-compose-fulldocker-is_stateless_messaging.yml)

```
docker-compose -f docker-compose-fulldocker-is_stateless_messaging.yml up -d
```

### Using Command Central for Runtime provisioning

Because of timing issues where CCE is not quite initialized when the other setup operation get started, we need
to build the env in 2 stages (at this time, until I fix this)

#### Integration Server "Stateful" 

Docker-compose file: [docker-compose-runtimesetup-is_stateful.yml](./docker-compose-runtimesetup-is_stateful.yml)

1. Create the nodes landscape + configure command Central and Databases

```
docker-compose -f docker-compose-runtimesetup-is_stateful.yml up setup_landscape
```

Wait until the instance "setup_cce" and "setup_is_db" are done and exited.

Running a "docker ps" should show 5 instances running when it's ready for next step (1 command central server, 3 nodes, 1 database)

You should also be able to login to Command Central UI and see the empty nodes registered:
https://localhost:8091/cce

2. Then, provison the products:

```
docker-compose -f docker-compose-runtimesetup-is_stateful.yml up setup_provisioning
```

After 10s of minutes, all products should have been installed on each node,
which you can verify by login to Command Central UI (see next section "Testing Results")

3. Testing results

When both docker-compose are done, you should have 2 IS running and accessible at following urls:

 - http://localhost:5555 (IS1)
 - http://localhost:5556 (IS2)
 - https://localhost:8091/cce (Command Central -- only applicable in the case of Command Central managed provisioning)

If you login into each of these IS instances, you'll notice that
 - They are both clustered with Terracotta (go to Settings > Clustering)
 - They are both connected to the Oracle DB (go to Settings > JDBC Pools and click the "Tests" icons...)
 
#### Integration Server "Stateful Messaging"

Docker-compose file: [docker-compose-runtimesetup-is_stateful_messaging.yml](./docker-compose-runtimesetup-is_stateful_messaging.yml)

1. Create the nodes landscape + configure command Central and Databases

```
docker-compose -f docker-compose-runtimesetup-is_stateful_messaging.yml up setup_landscape
```

Wait until the instance "setup_cce" and "setup_is_db" are done and exited.

Running a "docker ps" should show 6 instances running when it's ready for next step (1 command central server, 4 nodes, 1 databasde)

You should also be able to login to Command Central UI and see the empty nodes registered:
https://localhost:8091/cce

2. Then, provison the products:

```
docker-compose -f docker-compose-runtimesetup-is_stateful_messaging.yml up setup_provisioning
```

After 10s of minutes, all products should have been installed on each node,
which you can verify by login to Command Central UI (see next section "Testing Results")

3. Testing results

When both docker-compose are done, you should have 2 IS running and accessible at following urls:

 - http://localhost:5555 (IS1)
 - http://localhost:5556 (IS2)
 - https://localhost:8091/cce (Command Central -- only applicable in the case of Command Central managed provisioning)

If you login into each of these IS instances, you'll notice that
 - They are both clustered with Terracotta (go to Settings > Clustering)
 - They are both connected to the Oracle DB (go to Settings > JDBC Pools and click the "Tests" icons...)
 - They are both connected to UM server via JMS (1 JNDI + 1 JMS connection alias should be enabled) AND via wM MEssaging (1 native connection alias should be enabled)

#### Integration Server "Stateless Messaging"

Docker-compose file: [docker-compose-runtimesetup-is_stateless_messaging.yml](./docker-compose-runtimesetup-is_stateless_messaging.yml)

1. Create the nodes landscape + configure command Central and Databases

```
docker-compose -f docker-compose-runtimesetup-is_stateless_messaging.yml up setup_landscape
```

Running a "docker ps" should show 4 instances running when it's ready for next step (1 command central server, 3 nodes)

You should also be able to login to Command Central UI and see the empty nodes registered:
https://localhost:8091/cce

2. Then, provison the products:

```
docker-compose -f docker-compose-runtimesetup-is_stateless_messaging.yml up setup_provisioning
```

After 10s of minutes, all products should have been installed on each node,
which you can verify by login to Command Central UI (see next section "Testing Results")

3. Testing results

When both docker-compose are done, you should have 2 IS running and accessible at following urls:

 - http://localhost:5555 (IS1)
 - http://localhost:5556 (IS2)
 - https://localhost:8091/cce (Command Central -- only applicable in the case of Command Central managed provisioning)

If you login into each of these IS instances, you'll notice that
 - They are both connected to UM server via JMS (1 JNDI + 1 JMS connection alias should be enabled) AND via wM MEssaging (1 native connection alias should be enabled)
 - they are NOT connected to a database
 - they are NOT clustered
 
### Differences / Advantages between full "native docker build" versus a "managed provisoning"

You'll notice that the first time these scripts run, it will take *quite a long time* (in the 10s of minites) 
FOR BOTH to pull down all the binaries and install the products and fixes etc...

But the main difference between the 2 concepts are:
 - For the full "native docker build" run, actual docker images were created for each of the products, 
 and as such, on any subsequent builds, the environment will rebuild in just a few seconds!
 
 - Another advantage of the full "native docker build" version is that these built images can be pushed to a central repository,
 giving you essentially the ability to recreate this IS Stateful environment anywhere you wish 
 (anywhere you have access to your central repository that is)

To test these advantage, you have both started these environment, try to perform a cleanup (see "Cleaning Up" below)
and re-run the docker-compose command above.

You'll notice that for the case of "Full Native Docker Build", it will take just a few seconds to create all instances and start.
But for the "Managed Command Central dynamic provisioning", it will re-do all the same work...leading to the same long start-up time.

### Private registry for the Full "native docker build"

Speaking of docker push to a private registry, simply run:

```
docker-compose -f docker-compose-fulldocker-is_stateful.yml push --ignore-push-failures
```

NOTE: As defined in the [.env](.env) file, the docker-compose file will create the docker image by default with the following registry prefix:
registry.docker.tests:5000

This of course may not be your registry URL...so feel free to change it in that [.env](.env) file.

And if you've already run thew build, and waited already many precious minutes that you'll never get back, you can simply tag the newly-created 
images with your registry url for this time being...

```
docker tag registry.docker.tests:5000/softwareag/is_stateful:10.1 MY.NEW.REGISTRY:5000/softwareag/is_stateful:10.1 
docker tag registry.docker.tests:5000/softwareag/tcserver:10.1 MY.NEW.REGISTRY:5000/softwareag/tcserver:10.1
```

### Cleaning Up

To clean up the created instances, simply run "docker-compose down"...

#### For full "native docker build"

Simply run:

```
docker-compose -f docker-compose-fulldocker-is_stateful.yml down
```

or

```
docker-compose -f docker-compose-fulldocker-is_stateful_messaging.yml down
```

or

```
docker-compose -f docker-compose-fulldocker-is_stateless_messaging.yml down
```

NOTE: when you clean up, only the docker "instances" get deleted (and their associated networks).
BUT the docker images will still remain...which means that you can easily recreate the environments many time...

Eg. re-run:

```
docker-compose -f docker-compose-fulldocker-is_stateful.yml up -d
```

And this time, it will take just a few seconds to start up!

#### For Command Central for Runtime provisioning

Simply run:

```
docker-compose -f docker-compose-runtimesetup-is_stateful.yml down
```

or

```
docker-compose -f docker-compose-runtimesetup-is_stateful_messaging.yml down
```

or

```
docker-compose -f docker-compose-runtimesetup-is_stateless_messaging.yml down
```

## Building Product-specific Docker Images  <a name="building_product_docker"></a>

It is also possible to build product-specific Docker Images by navigating into one of the templates folders.

### Building Terracotta docker Image

Navigate to templates/tc-layer and run:

```
docker-compose -f docker-compose-build.yml build
```

At the end (10s of minutes to give a broad idea of duration), you should have 2 images created 
(where TAG and REGISTRY are defined in the .env file in the same folder)
 - ${REGISTRY}softwareag/tcserver:${TAG}
 - ${REGISTRY}softwareag/tcserver_managed:${TAG}


If you have a private registry, you should push these new images to it so you don't have to spend another 10+ minutes to recreate them later.
```
docker-compose -f docker-compose-build.yml push --ignore-push-failures
```

NOTE: Because it's not necessary to push the "builder" image, I specified a "fake" registry for it, identified by "donotpush:5000"
So the error "ERROR: Get https://donotpush:5000/v2/: Service Unavailable" is expected and not to be worried about.
      
### Building Universal Messaging docker Image

Navigate to templates/um-layer and run:

```
docker-compose -f docker-compose-build.yml build
```

At the end (10s of minutes to give a broad idea of duration), you should have 2 images created 
(where TAG and REGISTRY are defined in the .env file in the same folder)
 - ${REGISTRY}softwareag/umserver:${TAG}
 - ${REGISTRY}softwareag/umserver_managed:${TAG}
 
If you have a private registry, you should push these new images to it so you don't have to spend another 10+ minutes to recreate them later.
```
docker-compose -f docker-compose-build.yml push --ignore-push-failures
```

NOTE: Because it's not necessary to push the "builder" image, I specified a "fake" registry for it, identified by "donotpush:5000"
So the error "ERROR: Get https://donotpush:5000/v2/: Service Unavailable" is expected and not to be worried about.

### Building MWS docker Image

Navigate to templates/mws-layer and run:

```
docker-compose -f docker-compose-build.yml build
```

At the end (10s of minutes to give a broad idea of duration), you should have 2 images created 
(where TAG and REGISTRY are defined in the .env file in the same folder)
 - ${REGISTRY}softwareag/mws_simple:${TAG}
 - ${REGISTRY}softwareag/mws_simple_managed:${TAG}
 - ${REGISTRY}softwareag/mws_bpms:${TAG}
 - ${REGISTRY}softwareag/mws_bpms_managed:${TAG}
 
If you have a private registry, you should push these new images to it so you don't have to spend another 10+ minutes to recreate them later.
```
docker-compose -f docker-compose-build.yml push --ignore-push-failures
```

NOTE: Because it's not necessary to push the "builder" image, I specified a "fake" registry for it, identified by "donotpush:5000"
So the error "ERROR: Get https://donotpush:5000/v2/: Service Unavailable" is expected and not to be worried about.
 
### Building Integration Server docker Image

Navigate to templates/is-layer and run one of the following:

#### IS Stateful
```
docker-compose -f docker-compose-build-stateful.yml build
```

At the end (10s of minutes to give a broad idea of duration), you should have 2 images created 
(where TAG and REGISTRY are defined in the .env file in the same folder)
 - ${REGISTRY}softwareag/is_stateful:${TAG}
 - ${REGISTRY}softwareag/is_stateful_managed:${TAG}
 
If you have a private registry, you should push these new images to it so you don't have to spend another 10+ minutes to recreate them later.
```
docker-compose -f docker-compose-build-stateful.yml push --ignore-push-failures
```

NOTE: Because it's not necessary to push the "builder" image, I specified a "fake" registry for it, identified by "donotpush:5000"
So the error "ERROR: Get https://donotpush:5000/v2/: Service Unavailable" is expected and not to be worried about.

#### IS Stateless

```
docker-compose -f docker-compose-build-stateless.yml build
```

At the end (10s of minutes to give a broad idea of duration), you should have 2 images created 
(where TAG and REGISTRY are defined in the .env file in the same folder)
 - ${REGISTRY}softwareag/is_stateless:${TAG}
 - ${REGISTRY}softwareag/is_stateless_managed:${TAG}
 
If you have a private registry, you should push these new images to it so you don't have to spend another 10+ minutes to recreate them later.
```
docker-compose -f docker-compose-build-stateless.yml push --ignore-push-failures
```

NOTE: Because it's not necessary to push the "builder" image, I specified a "fake" registry for it, identified by "donotpush:5000"
So the error "ERROR: Get https://donotpush:5000/v2/: Service Unavailable" is expected and not to be worried about.

#### IS Stateful Messaging

```
docker-compose -f docker-compose-build-stateful-messaging.yml build
```

At the end (10s of minutes to give a broad idea of duration), you should have 2 images created
(where TAG and REGISTRY are defined in the .env file in the same folder)
 - ${REGISTRY}softwareag/is_stateful_messaging:${TAG}
 - ${REGISTRY}softwareag/is_stateful_messaging_managed:${TAG}

If you have a private registry, you should push these new images to it so you don't have to spend another 10+ minutes to recreate them later.
```
docker-compose -f docker-compose-build-stateful-messaging.yml push --ignore-push-failures
```

NOTE: Because it's not necessary to push the "builder" image, I specified a "fake" registry for it, identified by "donotpush:5000"
So the error "ERROR: Get https://donotpush:5000/v2/: Service Unavailable" is expected and not to be worried about.
 
### Building BPMS docker Image

Navigate to templates/bpms-layer and run:

```
docker-compose -f docker-compose-build.yml build
```

At the end (10s of minutes to give a broad idea of duration), you should have 2 images created 
(where TAG and REGISTRY are defined in the .env file in the same folder)
 - ${REGISTRY}softwareag/bpms:${TAG}
 - ${REGISTRY}softwareag/bpms_managed:${TAG}

If you have a private registry, you should push these new images to it so you don't have to spend another 10+ minutes to recreate them later.
```
docker-compose -f docker-compose-build.yml push --ignore-push-failures
```

NOTE: Because it's not necessary to push the "builder" image, I specified a "fake" registry for it, identified by "donotpush:5000"
So the error "ERROR: Get https://donotpush:5000/v2/: Service Unavailable" is expected and not to be worried about.