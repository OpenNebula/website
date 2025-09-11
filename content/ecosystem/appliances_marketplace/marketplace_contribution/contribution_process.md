---
title: "Contribution Process"
type: docs
linkTitle: "Contribution Process"
weight: 2
---

## High Level Overview
1. **Form Submission:** This is an overview of the different stages of the contribution process:
Form Submission: an initial contact between the contributor and OpenNebula is a GitHub (GH) issue submitted by the contributor via the [GH template](https://github.com/OpenNebula/marketplace-community/issues/new?template=new-appliance-contrib.yml). The contributor submits the form with relevant information such as the Appliance’s nature, objective, structure and requirements. These details are used to evaluate if the appliance is a valid candidate for addition to the Community Marketplace. The contributor can include additional information like the vendor or company, as well as contact information. If necessary, OpenNebula will provide some feedback regarding the proposed appliance.
2. **Appliance Development:** The contributor develops the appliance itself, all according to a set of standards. Please, check a separate section [Appliances Development](appliances_development.md).
3. **Appliance Certification:** In addition to the appliance, the contributor must provide a way to certify that the appliance is working as intended. The appliance should be compatible at the operating system level with the basic contextualization features.
4. **Pull Request Submission:** After completing local development, the contributor will need to submit a Pull Request to the community marketplace GitHub repository. This action formally begins our review process, where the OpenNebula team will review the code and test the appliance to ensure that it is both functional and safe to distribute. 
5. **Acceptance:** If the testing goes well, the Pull Request will be accepted and the appliance incorporated into the Community  Marketplace. Otherwise, the reviewer may ask for additional changes to the Appliance.

Please, find more details on some of these stages below.

## Communication Channels

During the contribution process, the following channels will be used:
- **GitHub Issues:** This is the designated starting point for proposing a new appliance. By creating an issue first, you can discuss the appliance's purpose and features with the OpenNebula team. This initial conversation ensures your contribution aligns with the Marketplace goals before you begin development work. This channel will mainly be used during stage 1. 
- **GitHub Pull Request:** This is the primary workspace for all technical collaboration. When you submit your appliance files (or an update), the Pull Request becomes the central hub for code reviews, configuration feedback, and discussions with our engineers. This channel will be used during stage 4.
- **Email:** We use email for direct and official communication, particularly after your appliance has been published in the Marketplace. For example, if your live appliance fails a periodic compatibility test, you will receive an automated notification via email containing the relevant logs and details. This channel will be mainly used during for maintenance, but may also be used in stage 4 if the appliance fails the initial tests.
- **OpenNebula Forum:** This is our main channel for community-wide interaction. It's the ideal place to ask general questions about the contribution process or to seek help from other community members. We also encourage you to use the forum to engage with and provide support to the end-users of your appliance. This channel will be used during stages 2 and 3 in case of questions regarding development. It will also be the main communication channel after release for maintenance purposes.

## Contribution process: detailed view

### 1. Form submission
This is the initial contact between the appliance contributor and OpenNebula Team. The contributor submits the appliance details through a specific form designed for this purpose.
That form is accessible in the [Issues](https://github.com/OpenNebula/marketplace-community/issues) tab in the OpenNebula community marketplace GH [repository](https://github.com/OpenNebula/marketplace-community) when you press the `New Issue` green button.
It looks as on the figure below.

![image](/images/marketplaces/community_mp/appliance_contrib_gh_template.png)

### 2. Appliance Development
Please, check a separate section "[Appliances Development](appliances_development.md)".

### 3. Appliance Certification
Please, check a separate section "[Certification Tests](certification_tests.md)".

### 4. Pull Request Submission
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
```bash
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
```bash
git add apps-code/community-apps/Makefile.config appliances/test/a0fae8be-3a24-46a2-9fd0-a102698d7cd6.yaml appliances/test/
apps-code/community-apps/packer/test/
```

Execute the `git status` command one more time to check what files have been added to be committed.

Commit changes:
```bash
git commit -s -m "Appliance contribution Test"
```

Push changes to remote separate branch of marketplace-community repository:
```bash
git push -u origin test
```

### 5. Acceptance

Once OpenNebula has accepted your appliance, your pull request will be merged into the marketplace repository and you will receive an email like the following:

    Dear <contributor name>,

    We are pleased to inform you that your community marketplace appliance, <appliance name>, has passed all testing and your Pull Request has been accepted and merged.

    Your contribution is now live and available to all users in the OpenNebula Marketplace. Thank you for your excellent work and for helping to improve the ecosystem.

    As a reminder, all appliances are periodically re-tested to ensure ongoing compatibility. For more information regarding this maintenance process, please refer to our documentation:
    https://docs.opennebula.io/stable/ecosystem/appliances_marketplace/marketplace_contribution/maintenance_process/

    Best regards,
    The OpenNebula Team
