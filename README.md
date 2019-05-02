# webmethods-devops-provisioning

A project that demonstrates complete devops "infrastructure-as-code" principles applied to SoftwareAG webMethods ecosystem
In this project, we will see how to auto-provision complete SoftwareAG webMethods environments using webMethods Command Central templates and scripts.

Author: Fabien Sanglier

## Table of content
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Quick Start: Provisioning Different Integration Server environments using Docker](#env_quickstart)
4. [Building Product-specific Docker Images](#building_product_docker)

## Introduction <a name="introduction"></a>


## Prerequisites <a name="prerequisites"></a>

First, let's clone the project (and its required submodules) onto your target Centos or Rhel Linux server

```
git clone --recursive -b rel104 https://github.com/lanimall/webMethods-devops-provisioning.git
cd webMethods-devops-provisioning
```

Note: if git is not install yet, you will have to install it first:
```
yum install -y git
```

## Command Central Installation <a name="cce_installation"></a>

First, to define the default admin password that will be applied ot the newly provisonned Command Central node, set CC_PASSWORD accordingly:
```
export CC_PASSWORD="somepassword"
```

Also, to define the empower user and password to use when pulling products from the central repository, set CC_SAG_REPO_USR and CC_SAG_REPO_PWD
```
export CC_SAG_REPO_USR=<your_softwareag_empower_user>
export CC_SAG_REPO_PWD=<your_softwareag_empower_user_password>
```

Finally, the default installation folder is set to "/opt/softwareag". To update, simply edit the file ./scripts/provision_ccserver.sh and update the variable SPM_INSTALL_DIR with the desired path.

*Important*: whatever path you chose, make sure that the current user you will run the following command with has appropriate permissions to write to the path.

Now, we're ready to run the command central provisioning script:

```
./scripts/provision_ccserver.sh 
```

After a few minutes, command central should be installed and running. 
Check your installation location and check that there are now 2 new running java processes (one for CCE, one for SPM)

Also, of course, check the command central URL that should now be accesssible:

https://aws_centos7_sagdevops_ccinfra_cce104:8091


## Command Central Configuration <a name="cce_configuration"></a>

Now we have a running Command Central component, it's time to configure it with the necessary data that will allow us to install the webMethods software we need.
Overall, this step is about:
- registering the product licenses,
- registering the product repositories or mirrors,
- perform any tuning needed
- update command central as required

To do all this, a single script can be executed:
```
./scripts/configure_ccserver.sh 
```
