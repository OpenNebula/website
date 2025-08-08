---
title: "Appliances Development"
type: docs
linkTitle: "Appliances Development"
description: "A step-by-step guide on how to develop own appliance ready to be added into the OpenNebula Community Marketplace."
weight: 5
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
