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

### get the code

First, let's clone the project (and its required submodules) onto your target Centos or Rhel Linux server

```
git clone --recursive --branch workingdemo_wm103_v1.0 https://github.com/lanimall/webMethods-devops-provisioning.git
cd webMethods-devops-provisioning
```

Note: if git is not install yet, you will have to install it first:
```
yum install -y git
```

### Setup required environment variables

Before starting the command central installation, we'll need to define couple of sensitive environment variables that we couldn't hard code in the scripts directly.

```
export CC_PASSWORD=${cc_password}
export CC_SAG_REPO_USR=${webmethods_repo_username}
export CC_SAG_REPO_PWD=${webmethods_repo_password}
export CC_SSH_KEY_FILENAME=${webmethods_cc_ssh_key_filename}
export CC_SSH_KEY_PWD=${webmethods_cc_ssh_key_pwd}
export CC_SSH_USER=${webmethods_cc_ssh_user}
export SPM_INSTALL_DIR=/opt/softwareag
export CC_SAG_PRODUCT_LICENSES=${HOME}/sag_licenses.zip
```

Notes:
 - CC_PASSWORD: this will be the password for the Command Central default Administrator user
 - CC_SAG_REPO_USR: this is the empower user you'll use to create the product repo in Command Central
 - CC_SAG_REPO_PWD: this is the password for the empower user you'll use
 - CC_SSH_KEY_FILENAME: This is the path to the SSH key file that command central will use to bootstrap servers remotely
 - CC_SSH_KEY_PWD: this is the passphrase for the SSH key file
 - CC_SSH_USER: this is the OS user that Command Central will use to make SSH conections to remote servers. 
 - SPM_INSTALL_DIR: the path where SPM will be installed during bootstrapping
 - CC_SAG_PRODUCT_LICENSES: the path to a license package file (zip) containing valid SoftwareAG license files

*Important*: Whatever path you chose for SPM_INSTALL_DIR, make sure that the user identified by CC_SSH_USER has appropriate permissions to write to the path.

## Command Central Installation <a name="cce_installation"></a>

Now, we're ready to run the command central provisioning script:

```
./scripts/provision_ccserver.sh 
```

After a few minutes, you should see the following in the logs and command central should be installed and running. 
```
...
BUILD SUCCESSFUL
Total time: 14 seconds
```

And command central should be running and accessible:
```
open https://localhost:8091/cce/web/
```

And you should be able to login with the Administrator user (with the password identified by CC_PASSWORD)

Finally, the script should have created the following file on the server: ${HOME}/setenv-cce.sh 
This file is important as it defines the PATH to the newlyt installed Command Central CLI and other related scripts...
and it will be used by all the other scripts.

## Command Central Configuration <a name="cce_configuration"></a>

Now we have a running Command Central component, it's time to configure it with the necessary data that will allow us to install the webMethods software we need. 
Overall, this step is about:
- registering the product licenses,
- registering the product repositories or mirrors,
- perform any tuning needed
- update command central with latest fixes, as required

The only pre-requisite needed here is to make sure that the license file package is present on the server at the path identified by CC_SAG_PRODUCT_LICENSES environment variables...
Quick check would be:
```
ls -al $CC_SAG_PRODUCT_LICENSES
```

Then, the following command can be executed:
```
./scripts/configure_ccserver.sh 
```

After a few minutes, you should see the following in the logs: 
```
...
BUILD SUCCESSFUL
Total time: 14 seconds
```

At the end of this step, you should now be able to see in Command Central UI the following new configuration items:
- Registered product repository
- Registered fix repository
- Registered licenses
- Registered passwords

## Products Installation <a name="products_installation"></a>

At this point, the following product installs are currently available in this project:
 - scripts/provision_is_stateless.sh:
 - scripts/provision_is_stateless.sh:
 - etc...

Each of these scripts will commonly require at least the following 2 variables to be set for succesful execution:
 - TARGET_HOST: the host on which to install the product(s)
 - LICENSE_KEY_ALIAS1: the license key alias to use for the product(s) to install.

In some case where the provisoning template installs multiple components on multiple hosts, the following extra variables would need to be specified:
 - TARGET_HOST2
 - TARGET_HOST3
 - LICENSE_KEY_ALIAS2
 - LICENSE_KEY_ALIAS3

Knowing which host or which key alias to specify is defined on a per-script basis (and should be in the script documentation)

For example, let's install a simple Integration server on an available remote host "remote1.company.com"

```
export TARGET_HOST=remote1.company.com
export LICENSE_KEY_ALIAS1="0123456789_PIE_10.0_ANY_LNXAMD64"
/bin/bash ./scripts/provision_is_stateless.sh
```

This script will:
- bootstrap via SSH a new SPM (SoftwareAG Platform Manager) onto that remote server "remote1.company.com" (in this step, the information provided earlier 
for CC_SSH_KEY_FILENAME, CC_SSH_KEY_PWD, CC_SSH_USER will be used to remote connect to the server)
- start SPM
- download product binaries necessary for the install
- install the product(s) as defined by the template (here it's simple IS)
- configure the product(s) as defined by the template (simple bare bone configuration)
