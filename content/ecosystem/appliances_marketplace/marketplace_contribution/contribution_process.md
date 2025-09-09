---
title: "Contribution Process"
type: docs
linkTitle: "Contribution Process"
weight: 2
---

## Contribution Process Overview
Here is an overview of the different steps and processes that the contribution process will encompass:
1. **Form Submissions:** an initial contact between the contributor and OpenNebula is a GitHub (GH) issue submitted by the contributor via the [GH template](https://github.com/OpenNebula/marketplace-community/issues/new?template=new-appliance-contrib.yml). The form is designed to capture the Appliance’s nature, objective, structure and requirements, in order to evaluate if it is a valid candidate for addition to the Community Marketplace. Moreover, the form requests information about the vendor or company, including contact information.
2. **Feedback (Optional):** If necessary, OpenNebula will provide some feedback regarding the proposed appliance.
3. **Development:** In this step the contributor will need to develop the appliance itself, all according to a set of standards.
4. **Contributor's testing** Apart from providing an appliance  Contributor must also provide a way of certifying that the appliance is working as intended according to the features it provides while still being compatible at Operating System level with the basic contextualization features.
5. **Submission:** Once the appliance has developed and tested their extension, they will need to submit it into the community marketplace GH repository through a Pull Request.
6. **Testing:** Before accepting the Pull Request, the appliance will be tested by OpenNebula to ensure that it is both functional and safe to distribute.
7. **Acceptance:** If the testing goes well, the Pull Request will be accepted and the appliance incorporated into the Community  Marketplace. Otherwise, the reviewer may ask for additional changes to the Appliance.

Please, find more details on some of these stages below.

## Communication Channels

During the contribution process, the following channels will be used:
- **GitHub Issues:** This is the designated starting point for proposing a new appliance. By creating an issue first, you can discuss the appliance's purpose and features with the OpenNebula team. This initial conversation ensures your contribution aligns with the Marketplace goals before you begin development work.
- **GitHub Pull Request:** This is the primary workspace for all technical collaboration. When you submit your appliance files (or an update), the Pull Request becomes the central hub for code reviews, configuration feedback, and discussions with our engineers.
- **Email:** We use email for direct and official communication, particularly after your appliance has been published in the Marketplace. For example, if your live appliance fails a periodic compatibility test, you will receive an automated notification via email containing the relevant logs and details.
- **OpenNebula Forum:** This is our main channel for community-wide interaction. It's the ideal place to ask general questions about the contribution process or to seek help from other community members. We also encourage you to use the forum to engage with and provide support to the end-users of your appliance.

## Community Marketplace Contribution Process

### Form submission
As it was stated above the initial contact between appliance contributor and OpenNebula Team is a form submission with details about contributing appliance.
That form is accessible in the [Issues](https://github.com/OpenNebula/marketplace-community/issues) tab in the OpenNebula community marketplace GH [repository](https://github.com/OpenNebula/marketplace-community) when you press the `New Issue` green button.
It looks as on the figure below.

![image](/images/marketplaces/community_mp/appliance_contrib_gh_template.png)

### Appliance Development
Please, check a separate section "[Appliances Development](appliances_development.md)".

### Appliance Documentation

Any appliance contributed to the Community Marketplace must be properly documented. For this, two files need to be provided:

- [README.md](https://github.com/OpenNebula/marketplace-community/blob/master/appliances/example/README.md) will contain the documentation for the appliance where basic information about the appliance and instructions on how to use it will be provided. This file must include at least the following sections:

  - Release Notes. Details about the current version of the appliance, including versions of each component.
  - Overview. A summary of the appliance, including what software it comes with and basic information.
  - Quick Start. A quick guide on how to instantiate the appliance once imported from the marketplace.
  - Features. All features available in the appliance should be described in detail.

- [CHANGELOG.md](https://github.com/OpenNebula/marketplace-community/blob/master/appliances/example/CHANGELOG.md). Comprehensive changelog of the appliance, following guidelines at [keepachangelog.com](http://keepachangelog.com).

- [metadata.yaml](https://github.com/OpenNebula/marketplace-community/blob/master/appliances/example/metadata.yaml) defines the basic metadata elements of the appliance so it can be built and tested once it's been contributed.

  - The attribute `:base` is the base distro used to build the appliance, which is the same that is defined in the packer script. The base image of an appliance can be any of the base Operating System Images built in from one-apps repository. Check the [distros available in the Makefile.config file](https://github.com/OpenNebula/one-apps/blob/800f5bd5c243be7c654a519547aef73f5f11cf86/Makefile.config#L10) for a quick reference.
  - The `:infra` section must not be modified, this is used by OpenNebula.

### Pull Request Submission
As soon as appliance contributors make sure the appliance certification tests are passed successfully they need to submit a pull request (PR) to the OpenNebula Community Marketplace GH repository.

{{< alert title="Note" color="success" >}}
Please, note that it is not expected that the appliance contributor uploads the appliance image. It’s expected to have in the PR just the code which can be used to generate the appliance image. As soon as OpenNebula has the complete PR the image will be generated and uploaded to the corresponding endpoint, the appliance’s metadata will be modified accordingly with the link to the image and made available on the Community Marketplace.{{< /alert >}}

The PR should contain, at least, the following files:
* **Appliance directory.** New directory `appliances/<appliance_name>` that includes:
   - **YAML file with an appliance description.** One can use a [template](https://github.com/OpenNebula/marketplace-community?tab=readme-ov-file#image-with-optional-vm-template) as an example and/or check  already [existing](https://github.com/OpenNebula/marketplace-community/tree/master/appliances) in the Community Marketplace Github repository similar files. It should be named `<UUID>.yaml`, where `<UUID>` is a unique identifier generated at the time of the appliance creation
   - **Appliance script.** Appliances can be written in Ruby (`appliance.rb`) or bash ([appliance.sh](https://github.com/OpenNebula/marketplace-community/blob/master/appliances/example/appliance.sh)).
   - **Metadata file**, following the guidelines described in the previous section.
   - **Tests description file** ([tests.yaml](https://github.com/OpenNebula/marketplace-community/blob/master/appliances/example/tests.yaml)).
   - Tests folder with appliance’s **tests** written in Ruby (following [00-example_basic.rb](https://github.com/OpenNebula/marketplace-community/blob/master/appliances/example/tests/00-example_basic.rb)).
   - **Documentation**  for the appliance (README.md and CHANGELOG.md) following the guidelines described in the previous section.
* A change to apps-code/community-apps/**Makefile.config** file with new appliance candidate added.
* A set of files at `apps-code/community-apps/packer/<appliance_name>/` for **packer** tool.
* An image file with the appliance’s **logo**, with 1:1 ratio and preferably PNG or SVG format, in the logos/ directory at repo root.

Using the the example available in the [Appliances Development]({{< relref "appliances_development.md" >}}) section, the output of the `git status` command executed inside `marketplace-community` directory should look like below after finishing that chapter:
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

Execute the `git status` command one more time to check what files have been added to be committed.

Commit changes:
```
git commit -s -m "Appliance contribution Test"
```

Push changes to remote separate branch of marketplace-community repository:
```
git push -u origin test
```
