---
title: "Contribution Process"
type: docs
linkTitle: "Contribution Process"
description: "This document outlines the process for contributing virtual appliances to the OpenNebula Community Marketplace. It details the procedures for submission, testing, certification, and ongoing maintenance of appliances, including requirements for documentation and compatibility with OpenNebula versions. It also describes the infrastructure and tools used to support the contribution process, such as automatic certification testing and an alerting mechanism for contributors."
weight: 2
---

# Introduction to Appliance Marketplaces

OpenNebula Marketplaces provide a simple way to integrate your cloud with popular application/image providers. They can be treated as external datastores.
A Marketplace stores Marketplace Appliances. A MarketPlace Appliance includes one or more Images and, possibly, some associated metadata like VM Templates or OpenNebula Multi-VM service definitions.
A Marketplace can be:
* **Public**: accessible universally by all OpenNebula installations.
* **Private**: local within an organization and specific for a single.

OpenNebula (a single zone) or shared by a federation (a collection of zones).
The list of the Public Marketplaces configured by default is presented in table below.

|Marketplace&nbsp;Name|Description|
|----------------|-----------|
|OpenNebula Public|The official public [OpenNebula Systems Marketplace](http://marketplace.opennebula.systems). It is a catalog of virtual appliances ready to run in OpenNebula environments available at the specified link above.|
|Linux Containers|The public LXD/LXC [image repository](https://images.linuxcontainers.org). It hosts a public image server with container images for LXC and LXD. OpenNebula’s Linux Containers marketplace enables users to easily download, contextualize and add Linux container images to an OpenNebula datastore.|

It’s important to note the OpenNebula front-end needs access to the Internet to use the public Marketplaces.

Besides the `public` Marketplaces (leveraging various remote public repositories with existing Appliances and accessible universally by all OpenNebula instances), the `private` ones allow the cloud administrators to create the `private` Marketplaces within a single organization in a specific OpenNebula (single zone) or shared by a Federation (collection of zones). `Private` Marketplaces provide their users with an easy way of privately publishing, downloading and sharing their own custom Appliances.

As it was written above a Marketplace is a repository of Marketplace Appliances. There are three types of Appliances:
* **Image**: an image that can be downloaded and used (optionally it can have an associated virtual machine template)
* **Virtual Machine Template**: a virtual machine template that contains a list of images that are allocated in the Marketplaces.
* **Service Template**: a template to be used in OneFlow that contains a list of virtual machine templates that are allocated in the Marketplaces.

Using `private` Marketplaces is very convenient, as it will allow you to move images across different kinds of datastores (using the Marketplace as an exchange point). It is a way to share OpenNebula images in a Federation, as these resources are federated. In an OpenNebula deployment where the different Virtual Data Centers (VDCs) don’t share any resources, a Marketplace will act like a shared datastore for all the users.

Although a marketplace created in a zone will be seen in every zone of the Federation and every image can be imported from the marketplace on any zone, only the zone where the marketplace was created will be able to upload appliances to the marketplace.

Marketplaces store the actual Marketplace Appliances. How they do so depends on the back-end driver. Currently, the list of the supported back-end drivers is given in table below.
|Driver|Upload|Description|
|------|------|-----------|
|http|Yes|When an image is uploaded to a Marketplace of this kind, the image is written into a file in a specified folder, which is in turn available via a web server.|
|S3|Yes|Images are stored to an S3 API-capable service. This means they can be stored in the official [AWS S3 service](https://aws.amazon.com/s3/) , or in services that implement that API like [Ceph Object Gateway S3](https://docs.ceph.com/en/latest/radosgw/s3/).|

OpenNebula ships with the [OpenNebula Systems Marketplace](http://marketplace.opennebula.systems/) pre-registered, so users can access it directly.

## Contribution Process Overview
Here is an overview of the different steps and processes that the contribution process will encompass:
1. **Form Submissions:** an initial contact between the contributor and OpenNebula is a GitHub (GH) issue submitted by the contributor via the GH template. The form is designed to capture the Appliance’s nature, objective, structure and requirements, in order to evaluate if it is a valid candidate for addition to the Community Marketplace. Moreover, the form requests information about the vendor or company, including contact information.
2. **Feedback (Optional):** If necessary, OpenNebula will provide some feedback regarding the proposed appliance.
3. **Training:** If the appliance is deemed valid, the contributor will be contacted to undergo training to ensure (s)he understands the ongoing requirements and processes.
4. **Development:** In this step the contributor will need to develop the appliance itself, all according to a set of standards.
5. **Submission:** Once the appliance has developed and tested their extension, they will need to submit it into the community marketplace GH repository through a Pull Request.
6. **Testing:** Before accepting the Pull Request, the appliance will be tested by OpenNebula to ensure that it is both functional and safe to distribute.
7. **Acceptance:** If the testing goes well, the Pull Request will be accepted and the appliance incorporated into the Community  Marketplace. Otherwise, the reviewer may ask for additional changes to the Appliance.

Please, find more details on some of these stages below.

## Learning Materials
This section describes the necessary knowledge users need to understand to develop a new appliance and includes links to all the relevant documentation and learning materials.

## Community Marketplace Contribution Process

### Form submission
As it was stated above the initial contact between appliance contributor and OpenNebula Team is a form submission with details about contributing appliance.
That form is accessible in the `Issues` tab in the OpenNebula community marketplace GH [repository](https://github.com/OpenNebula/marketplace-community) when you press the `New Issue` green button.
It looks as on the figure below.
![image](/images/marketplaces/community_mp/appliance_contrib_gh_template.png)

### Appliance Development
Please, check a separate section "[Appliances Development](appliances_development.md)".

### Pull Request Submission
As soon as appliance contributors make sure the appliance certification tests are passed successfully one needs to submit a pull request (PR) to the OpenNebula Community Marketplace GH repository.

Such PR consists of the following parts:
* **Appliance directory.** New directory `appliances/<appliance_name>` that includes:
   - **YAML file with an appliance description.** One can use a [template](https://github.com/OpenNebula/marketplace-community?tab=readme-ov-file#image-with-optional-vm-template) as an example and/or check  already [existing](https://github.com/OpenNebula/marketplace-community/tree/master/appliances) in the Community Marketplace Github repository similar files. It should be named `<UUID>.yaml`, where `<UUID>` is a unique identifier generated at the time of the appliance creation
   - **Appliance script.** Appliances can be written in Ruby (`appliance.rb`) or bash ([appliance.sh](https://github.com/OpenNebula/marketplace-community/blob/master/appliances/example/appliance.sh)).
   - **Metadata file** ([metadata.yaml](https://github.com/OpenNebula/marketplace-community/blob/master/appliances/example/metadata.yaml)).
   - **Tests description file** ([tests.yaml](https://github.com/OpenNebula/marketplace-community/blob/master/appliances/example/tests.yaml)).
   - Tests folder with appliance’s **tests** written in Ruby (following [00-example_basic.rb](https://github.com/OpenNebula/marketplace-community/blob/master/appliances/example/tests/00-example_basic.rb)).
   - **Documentation** for the appliance in the file README.md. This file must include at least the following sections:
      - Release Notes
      - Overview
      - Quick Start
      - Features
    - Comprehensive **changelog** of the appliance in the `CHANGELOG.md` file,  following guidelines at [keepachangelog.com](http://keepachangelog.com).
* A change to apps-code/community-apps/**Makefile.config** file with new appliance candidate added.
* A set of files at `apps-code/community-apps/packer/<appliance_name>/` for **packer** tool.
* An image file with appliance’s **logo**, with 1:1 ratio and preferably PNG or SVG format, in the logos/ directory at repo root.

Continue with the example started in the [Appliances Development]({{< relref "appliances_development.md" >}}) section the output of the `git status` command executed inside `marketplace-community` directory should look like below:
```
git status
On branch test
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
    	modified:   apps-code/community-apps/Makefile.config

Untracked files:
  (use "git add <file>..." to include in what will be committed)
    	appliances/test/a0fae8be-3a24-46a2-9fd0-a102698d7cd6.yaml
    	appliances/test/
    	apps-code/community-apps/packer/test/

no changes added to commit (use "git add" and/or "git commit -a")
```

Add modified and untracked files:
```
git add apps-code/community-apps/Makefile.config appliances/test/a0fae8be-3a24-46a2-9fd0-a102698d7cd6.yaml appliances/test/
apps-code/community-apps/packer/test/
```

One can execute the `git status` command one more time to check what files have been added to be committed.

Commit changes:
```
git commit -s -m "Appliance contribution Test"
```

Push changes to remote separate branch of marketplace-community repository:
```
git push -u origin test
```
{{< alert title="Note" color="success" >}}
Please, note it is not expected that the appliance contributor uploads the appliance image. It’s expected to have in the PR  just a code which can be used to generate the appliance image. As soon as we have the complete PR the image will be generated  and uploaded to the corresponding S3 bucket, the appliance’s metadata will be modified accordingly with the link to the image and made available on the Community Marketplace.{{< /alert >}}
