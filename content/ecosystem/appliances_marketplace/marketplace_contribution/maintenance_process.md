---
title: "Maintenance Process"
type: docs
linkTitle: "Maintenance Process"
weight: 6
---

# Appliance Maintenance

To ensure the quality and reliability of the Marketplace, all Appliances are periodically tested for compatibility with both the Long-Term Support (LTS) and the latest stable release of OpenNebula. In the event of a test failure, a notification with relevant logs and details will be sent to the contributor's email. To remain listed, an Appliance must be compatible with at least one of these two target versions. If it is found to be incompatible with both, the formal Appliance Removal process will be initiated to remove the Appliance from the  Marketplace.

{{< alert title="Important: Active OpenNebula Releases" color="success" >}}
To avoid removal, an appliance must pass tests for at least one of the active OpenNebula releases. The two active releases are:

    Latest Release: 7.0.0
    LTS Version: 6.10

Note: These version numbers will change as new versions of OpenNebula are released.{{< /alert >}} 

# Appliance Update

Contributors can update their existing appliances by submitting a new Pull Request. The process is similar to contributing a new appliance.

1. Submit a new Pull Request against the ``community-marketplace`` repository.
2. The Pull Request should update the files for an existing appliance, not add a new one.
3. The submission will then follow the same validation and testing processes as a new appliance.

# Appliance Recertification

When new versions of OpenNebula are released (or about to be released), existing appliances will need to be recertified to ensure they pass all tests. This process will be run internally, and contributors will only be notified in case anything goes wrong via email. If any changes are needed, the contributor will need to kick off the Appliance Update process to be able to keep the appliance in the Marketplace. 

# Appliance Removal

An appliance may be removed from the Marketplace if it fails to meet compatibility or security standards. Removal can be triggered under two conditions:

1. **Compatibility Failure:** The appliance fails certification tests against all active OpenNebula releases, and the issues are not fixed by the contributor within 6 weeks of notification.
2. **Security Vulnerabilities:** A security issue is discovered, and the contributor does not provide a fix within 6 weeks of being notified.

If an appliance is removed for failing tests for longer than 6 weeks, it will need to be resubmitted as a new appliance.
