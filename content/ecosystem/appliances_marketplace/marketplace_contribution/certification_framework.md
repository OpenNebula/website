---
title: "Certification Framework"
type: docs
linkTitle: "Certification Framework"
description: "The section describes the Certification Framework used by OpenNebula Team to guarantee that Appliances submitted to the Community marketplace follow a set of standards and pass a series of tests to guarantee they work as intended."
weight: 5
---

# Scope
The aim of the Acceptance Framework is to guarantee that Appliances submitted to the Community marketplace follow a set of standards and pass a series of tests to guarantee they work as intended. 

If the Appliance passes all the certification tests, they will be published into the Community Marketplace. If any issues arise during this procedure, or if the assigned reviewer deems it necessary, some changes will be requested to the appliance developer. 

# Acceptance Framework Architecture

Here is a breakdown of the acceptance process once the contributor submits a Pull Request with their appliance code to the Community Marketplace up until it is accepted:

1. The PR is created and goes into a **PENDING** state until a reviewer is manually assigned by an administrator. Once it is assigned, it will automatically go into the **IN\_REVIEW** state. All of these states and actions are represented by GitHub Labels.  
2. Once the reviewer has checked the code, it may request some additional changes before testing the code, such as requesting a refactor of the code to comply with OpenNebula standards. This will prompt you to go to the **CHANGES\_REQUESTED** state, which should be accompanied by a comment in the PR by the reviewer with the actual changes required.  
3. If the code is deemed valid, it will then go into the **IN\_TESTING** phase. After applying the **do\_tests** flag, a GitHub Action will establish a tunnel into the OpenNebula infrastructure and trigger a series of Jenkins pipelines that will do the following:  
   1. **One-community-distro** pipeline: This pipeline will checkout the PR code and build the new appliance image as well as any requisite images from one-apps. In order to work smoothly, the title of the PR must be the same name as the folder containing the code inside marketplace-community/apps-code/community-apps/packer/. After building the image it will be uploaded to an nginx server inside the same infrastructure and trigger the next pipeline automatically.  
   2. **One-community-context** pipeline: This pipeline will retrieve the previously built image and execute two types of tests. First, it will perform the general context tests provided by OpenNebula. Afterwards, it will run the tests provided by the contributor. Lastly, an email will be sent to the reviewer with the results.  
4. If anything went wrong with the tests, the reviewer should move the status of the PR back to the **CHANGES\_REQUESTED** stage, and send a comment to the contributor with details regarding what went wrong or what needs to be changed.  
5. If everything went well, then the status could be considered **REVIEWED** and the reviewer will soon merge the PR into the marketplace-community repository. (The **REVIEWED** status won’t be actually shown, since the PR should go from **REVIEWED** to **MERGED** in a relatively short time).

![image](/images/marketplaces/community_mp/certification_framework_acceptance_proccess_diagram.png)

# Components

## **Jenkins**

A Jenkins deployment is used in order to coordinate all the stages that the certification process follows. This Jenkins is deployed in a server hosted by OpenNebula, and will be configured using Ansible playbooks in order to ensure easy reproducibility in case of server transfer or failure. 

There are 3 main pipelines in charge of certifications. Highlighted in green are the most important pipeline parameters, while highlighted in blue are the ones mostly used for internal development.

* **one-community-distro**: This pipeline is in charge of building appliances when they are first submitted, when there has been an update in OpenNebula or a new version of the appliance has been released.
  * `INFRA_URL`: OpenNebula/infra repository. Used to build the marketbuilder microenv.
  * `INFRA_BRANCH`: Defaults to master.
  * `MARKETPLACE_URL`: OpenNebula/marketplace-community repository.
  * `MARKETPLACE_BRANCH`: Defaults to master.
  * `JOBS`: Parallel jobs used for building inside the marketbuilder microenv.
  * `REQUIREMENTS`: List of comma-separated values with the images that should be built from the one-apps repository. This parameter will be automatically overwritten if the pipeline is executed from a PR by the specific requirements of that appliance.
  * `DISTROS`: List of comma-separated values with the community appliances to build.
  * `PR_NUMBER`: Number of the PR from which to checkout the code if any, -1 otherwise.
  * `RESULTS_EMAIL`: Email to which send the results of the execution.
* **one-community-context**: This pipeline takes care of running a series of tests to check that the appliance runs well in a given environment.  
* **scheduled-community-context**: This pipeline is in charge of regularly running the test\_appliance pipeline over all appliances. This way we can keep track if any changes made to OpenNebula affect existing appliances.

## **OpenNebula**

An OpenNebula deployment is hosted on the same server running the Jenkins pipeline. This deployment of OpenNebula is used to create the temporary environments that Jenkins will utilize to test the appliances.

These temporary environments, which we also call microenvironments, consist of a nested OpenNebula instance inside our main OpenNebula deployment. This microenvironment can be configured to use any OpenNebula version on any supported operating system, thus allowing us to easily test appliances in a wide variety of environments and scenarios. 

# Infrastructure

## Infrastructure Characteristics

The Jenkins and OpenNebula services are deployed on the server with the following hardware characteristics:

* CPU: AMD EPYC 7302P 16-Core Processor
* RAM: 64GB
* DISKs: 960 GB disks in RAID1 configuration


That server is running Ubuntu 24.04.1 LTS. OS and services configurations are managed via a dedicated ansible playbook.

There is also a VPN service deployed on the physical server used as storage. The VPN service is used to provide secure access to the OpenNebula company’s infrastructure. That server has the following hardware configuration:
* CPU: Intel Xeon Gold 5318Y CPU @ 2.10GHz
* RAM: 128GB
* DISKs: 42TB on ZFS storage

It runs Ubuntu 24.04 LTS. OS and services configurations are managed via ansible playbook.

## Infrastructure Deployment

In order to deploy and configure jenkins and OpenNebula services on a target host the following steps are needed to be executed on the ansible management node with passwordless ssh access to that target host (ansible management node is running Ubuntu 22.04.6 LTS and some commands are related to the usage of apt tool to manage OS packages).

Step 1\. Clone one-infra repository:

```
git clone git@github.com:OpenNebula/one-infra.git
```

Note that access to the GitHub OpenNebula/one-infra repository is restricted.

Step 2\. Change dir to `one-infra/infra/private`

```
cd one-infra/infra/private
```

Step 3\. Modify IP address for the jenkins-one host in the \[services\] section of the inventories/office file (hereinafter all paths are relative to one-infra/infra/private dir):

```
jenkins-one.crt  ansible_host=10.0.1.7
```

Step 4\. Make sure the passwordless access to that target host is enabled:

```
ansible -i inventories/office -m ping jenkins-one.crt
```

Step 5\. Install needed packages listed in the requirements-infra.yml file:

```
ansible-galaxy install -r ../requirements-infra.yml
```

It might be needed to install ruby and cron packages on the ansible management node :

```
apt update
apt install ruby cron
```

It might be needed to install `community.mysql` ansible collection:

```
ansible-galaxy collection install community.mysql
```

Step 6\. Run ansible playbook:

```
ansible-playbook -i inventories/office --limit jenkins-one.crt playbooks/jenkins-one.yml
```

Step 7\. Verify the deployment

* Open the following URL in a browser: [http://10.0.1.7:8080](http://10.0.1.7:8080)

  where 10.0.1.7 is the IP address of the target host with Jenkins and OpenNebula installed. That should load jenkins web-interface.

* Check if mail agent is capable to send emails:

```
one-infra/ansible/roles/jenkins/templates/jcasc/pipelines/one-distro/scripts/mail.rb --email <recepient’s email address> --subject=test --body="test body from jenkins-one"
```

## Infrastructure Users

A dedicated `gitact` user was created on the OpenNebula VPN server to be used in GitHub Actions to access that `jenkins-one` host via ssh protocol and invoke the Jenkins pipeline. We use this separate user for security reasons, since it has very low privileges and is only used to invoke the pipelines.

There is another user - `one`. It is created on the `jenkins-one` host and triggers actual pipelines.

## Appliance Storage

Appliances will be stored in the **opennebula-community-marketplace** S3 bucket inside the production AWS account. It can be accessed through the following link: [http://opennebula-community-marketplace.s3.amazonaws.com/](http://opennebula-community-marketplace.s3.amazonaws.com/) 
