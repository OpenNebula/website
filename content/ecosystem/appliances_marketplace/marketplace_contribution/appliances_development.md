---
title: "Appliances Development"
type: docs
linkTitle: "Appliances Development"
description: "A step-by-step guide on how to develop own appliance ready to be added into the OpenNebula Community Marketplace."
weight: 3
---

# General procedure

The new appliance contribution to the community marketplace process consists of a set of steps listed below.
1. Create Linux VM to develop and build your appliance
2. Create an user to be used for all needed operations
3. Install required software
4. Clone the OpenNebula/marketplace-community repository and create a new branch for your appliance
5. Create a set of needed folders and files for your new appliance under marketplace-community folder of cloned GH repo
6. Build an image with required OS to be used for your appliance
7. Build an image with your appliance
8. Test appliance
9. Create tests for new appliance under new branch of forked OpenNebula/marketplace-community
10. Commit & push new branch to forked repo OpenNebula/marketplace-community
11. Create pull request to OpenNebula/marketplace-community repo
12. As soon as new PRs appear in the OpenNebula/marketplace-community repo the OpenNebula team will get notification and start evaluation procedure.

# Basic OpenNebula deployment
## Setting up OpenNebula basic environment

Since the appliance needs to be validated against the appliance specific tests before submitting it to the Community Marketplace it seems reasonable to use the same environment for building and testing.

The needed environment can be deployed on a single VM with nested virtualization enabled and assumes the OpenNebula software installed, enough CPU, MEMORY and DISK resources should be provided as well as the network properly configured (i.e. the VM running in such test environment has to have an access to the Internet to download required packages).

One of the following approaches can be used in order to have such setup in place:

1) use [minione](https://github.com/OpenNebula/minione) tool,  
2) use [one-deploy](https://github.com/OpenNebula/one-deploy) tool,  
3) manually perform required operations following OpenNebula documentation.

This document describes the first approach e.g. minione tool. Please, check the steps below.

If you decide to follow  the one-deploy based approach one can use an inventory file provided as a reference at [lib/community/ansible/inventory.yaml](https://github.com/OpenNebula/marketplace-community/blob/master/lib/community/ansible/inventory.yaml).

Create the VM with nested virtualization enabled (steps below are written for Ubuntu 22.04 LTS).

Log into that VM and download the `minione` tool:

```
wget 'https://github.com/OpenNebula/minione/releases/latest/download/minione'
```

Execute minione as shown below to install OpenNebula front-end as well as KVM related packages on the same host:

```
bash minione
```

The `oneadmin` user created during the OpenNebula packages installation will be used for the building and testing of the appliance image.

Add that use to admin group:

```
usermod -a -G admin oneadmin
```

Become `oneadmin` user and update the packages:

```
su - oneadmin

sudo apt update

sudo apt upgrade
```

Reboot the host in order to boot into the updated kernel if any.

Apart from OpenNebula packages there are some other packages that need to be installed too. For that purpose we are going to use an ansible playbook.
Install ansible-core (needed for dependency installation via ansible playbook):

```
sudo apt install python3-pip

sudo pip3 install ansible-core
```

Create ansible playbook as below:

```
cat << EOF > requirements.yaml
---
- hosts: localhost
  become: false

  tasks:
  - name: Install OS packages
    ansible.builtin.package:
      name: "{{ _packages[ansible_os_family] }}"
      update_cache: true
    vars:
      _packages:
        Debian: [bash, cloud-utils, genisoimage, libguestfs0, libguestfs-tools, make, nginx, qemu-utils, rpm, rsync, ruby, qemu, qemu-system-x86]
    register: package
    until: package is success
    retries: 3
    delay: 10

  - name: Install packer binary
    ansible.builtin.unarchive:
      src: "https://releases.hashicorp.com/packer/{{ _version }}/packer_{{ _version }}_linux_amd64.zip"
      dest: /usr/local/bin/
      remote_src: true
      creates: /usr/local/bin/packer
    vars:
      _version: 1.10.0

  - name: Install ruby gems
    ansible.builtin.shell:
      cmd: gem install --no-document backports fpm rspec
      executable: /bin/bash
      creates: /usr/local/bin/fpm
EOF
```

Run that playbook:

```
sudo ansible-playbook requirements.yaml
```

## Verification

### Using command line interface

Become `oneadmin` user and try to perform basic operations like list hosts, templates, images, vnets, etc:

```
su - oneadmin
onehost list
onevnet list
onetemplate list
oneimage list
```

Try to instantiate a test VM from pre-uploaded VM template:

```
onetemplate list
onetemplate instantate <template_id>
```

Check if the VM status:

```
onevm status
```

Try to access it over the network:

```
onevm ssh <vm_id>
```

### Using graphical web-based user interface \- FireEdge Sunstone

By default the FireEdge Sunstone is running on the 2616 port. The exact URL is shown at the end of  the minione tool execution process  as well as the oneadmin credentials.

Point your browser to that URL and log into the FireEdge using the oneadmin credentials provided:

![image](/images/sunstone-login.png)

To get a list of hosts one needs to open the Dashboard menu bar from the left side and go to “Infrastructure” \-\> “Hosts”:

![image](/images/marketplaces/community_mp/basic_deployment_verification_fsunstone_hosts.png)

To list the existing virtual networks (vnets) one can click either “Virtual Networks” light brown tile or go to the “Networks” section and click on the “Virtual Networks” item of the menu:

![image](/images/images/marketplaces/community_mp/basic_deployment_verification_fsunstone_vnets.png)

To list the VM templates available one can either click on the “VM templates” magenta tile or go to “Templates” \-\> “VM Templates”:

![image](/images/marketplaces/community_mp/basic_deployment_verification_fsunstone_vmtemplates.png)

To list available images one can either click on the “Images” turquoise tile or go to “Storage” \-\> “Images”:

![image](/images/marketplaces/community_mp/basic_deployment_verification_fsunstone_images.png)

 Try to instantiate  the test VM from a  pre-uploaded VM template. For that purpose go to “VM template” menu item as it was shown above, select desired VM template (it’s ‘alpine’ linux in our example below) and click on a button with triangle icon:

![image](/images/marketplaces/community_mp/basic_deployment_verification_fsunstone_vm_instantiate_1.png)

Specify the VM name in the corresponding field, tune some other parameters upon your needs and click “Next” button:

![image](/images/marketplaces/community_mp/basic_deployment_verification_fsunstone_vm_instantiate_2.png)

Click “Finish” button on the next screen to finish with VM instantiation:

![image](/images/marketplaces/community_mp/basic_deployment_verification_fsunstone_vm_instantiate_3.png)

After that you will be redirected to the menu with a list of instantiated VMs. Check the test VM status there:

![image](/images/marketplaces/community_mp/basic_deployment_verification_fsunstone_vm_status.png)

One can connect to the VM via VNC console by clicking on the corresponding icon:

![image](/images/marketplaces/community_mp/basic_deployment_verification_fsunstone_vm_vnc_icon.png)

Check if the test VM was booted successfully and if there is login prompt:

![image](/images/marketplaces/community_mp/basic_deployment_verification_fsunstone_vm_vnc_console.png)

# Examples

Please, find below particular steps and commands to go through the whole procedure for building a new appliance. First we will show how to build the image for the ‘example’ appliance with all necessary files for which are already present in the OpenNebula Community Marketplace Github repository. So no need to do any modifications just to build the image for that appliance. Then we will describe the steps required to build a custom appliance (which is based on the Lithops one).

## Setting up the environment
Since the appliance needs to be validated against the appliance specific tests before submitting it to the Community Marketplace it seems reasonable to use the same environment for building and testing. Please, find the particular steps on setting up the required environment in the “Basic OpenNebula Deployment” document.

## Building example appliance
Clone marketplace-community GH repository:
```
git clone --recurse-submodules https://github.com/OpenNebula/marketplace-community.git
```

The `example` appliance relies on the usage of `alma8` image. So build it first:

```
cd ~/marketplace-community/apps-code/one-apps/

sudo make alma8
```

If you have `secure_path` enabled in the sudo settings then it might be needed to preserve the value for the `PATH` environment as shown below:
```
sudo env PATH=$PATH make alma8
```

The OS image is stored in the `~/marketplace-community/apps-code/one-apps/export/` dir.

Build the example appliance image:
```
cd ~/marketplace-community/apps-code/community-apps/

sudo make example
```

or with the following command if the `secure_path` defined in the sudo settings:
```
sudo env PATH=$PATH make example
```

In case of successful build the appliance image is expected to appear in the `~/marketplace-community/apps-code/community-apps/export/` directory.


## Building test appliance
Create a branch for the new appliance:
```
cd marketplace-community
git checkout -b test
```

Create a new folder for new appliance in the `~/marketplace-community/appliances` dir:
```
mkdir -p ~/marketplace-community/appliances/test
```

or copy already existing appliance folder (in our example the `lithops` appliance will be used):
```
cp -r ~/marketplace-community/appliances/{lithops,test}
```

If you have copied already existing appliance folder, please, generate new UUID and rename a corresponding metadata YAML file in the `~/marketplace-community/appliances/test` directory because these files have to have unique filenames:
```
cd ~/marketplace-community/appliances/test
mv 695ab19e-23dc-11ef-a2b8-59beec9fdf86.yaml $(uuidgen).yaml
```

Develop a `~/marketplace-community/appliances/test/appliance.sh` script based on the information at one-apps [wiki-page](https://github.com/OpenNebula/one-apps/wiki/apps_intro),  `example` or other existing appliances.
In our `test` appliance the one copied during the previous step is used. So modify that file according to desired behavior.


Create `~/marketplace-community/apps-code/community-apps/packer/test` folder and needed files there (based on `example` or other existing ones):

```
mkdir ~/marketplace-community/apps-code/community-apps/packer/test
```

In our example the `lithops` appliance folder will be used:
```
cp -r  ~/marketplace-community/apps-code/community-apps/packer/{lithops,test}
```

Rename `pkr.hcl` file:
```
mv ~/marketplace-community/apps-code/community-apps/packer/test/{lithops,test}.pkr.hcl
```

Replace all `lithops` mentionings with `test` ones:
```
sed -i 's/lithops/test/g' ~/marketplace-community/apps-code/community-apps/packer/test/test.pkr.hcl
```

Change the values from `lithops` to `test` for the variables in the `~/marketplace-community/apps-code/community-apps/packer/test/variables.pkr.hcl` file:
```
sed -i 's/lithops/test/g' -i ~/marketplace-community/apps-code/community-apps/packer/test/variables.pkr.hcl
```

Build base image for the new appliance first (possible values for supported distros can be found in the `DISTROS` variable in the `~/marketplace-community/apps-code/one-apps/Makefile.config` file):
```
cd ~/marketplace-community/apps-code/one-apps/

sudo make ubuntu2204
```

If you have `secure_path` enabled for the sudo then it might be needed to preserve the value for PATH environment:
```
sudo env PATH=$PATH make ubuntu2204
```

Check if a value for the `iso_url` variable points to a proper image and if it exists:
```
grep -i iso_url ~/marketplace-community/apps-code/community-apps/packer/service_test/test.pkr.hcl
iso_url = "../one-apps/export/ubuntu2204.qcow2"

ls -al ~/marketplace-community/apps-code/one-apps/export/ubuntu2204.qcow2
-rw-r--r-- 1 root root 433973760 Jul 26 03:14 export/ubuntu2204.qcow2
```


The path for the `iso_url` is relative to the `~/marketplace-community/apps-code/community-apps/Makefile.config` file.


Edit `~/marketplace-community/apps-code/community-apps/Makefile.config` file to add new appliance, based on `test`:
```
sed -i '/^SERVICES/s/$/ test/' ~/marketplace-community/apps-code/community-apps/Makefile.config
```

Build appliance image:
```
cd ~/marketplace-community/apps-code/community-apps/
sudo make test
```

or if the `secure_path` enabled for the sudo then it might be needed to preserve the value for `PATH` environment:
```
sudo env PATH=$PATH make test
```

In case of successful build the appliance image is expected to appear in the `~/marketplace-community/apps-code/community-apps/export/` directory.

Test appliance locally e.g. on your linux machine used for new appliance development
Please, proceed with the “Appliances Certification tests” document.
