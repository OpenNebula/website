---
title: "Running an Appliance"
type: docs
linkTitle: "Running an Appliance"
weight: 3
---

Please, find below a set of steps need to be performed either via graphical web interface or command line one to run an appliance imported from the Community Marketplace.

## Sunstone
To run an appliances imported from the Community Marketplace via OpenNebula graphical web interface called FireEdge Sunstone, please, perform the following steps.

Log into Firedge Sunstone web interface as any cloud user eligible to instantiate VMs from VM templates.

Go to **Templates** -> **VM Template**:

![image](/images/marketplaces/community_mp/running_appliance_menu.png)

Select imported appliance (it's a **NixOS** in our example below):

![image](/images/marketplaces/community_mp/running_appliance_nixos.png)

Press **Update** button if you want to modify some parameters:

![image](/images/marketplaces/community_mp/running_appliance_nixos_update.png)

Click **Play** button to instantiate a VM from the VM template:

![image](/images/marketplaces/community_mp/running_appliance_nixos_instantiate.png)

You can specify a VM name and/or change the values for other parameters (for more details, please, check ["Virtual Machine Template"](/product/operation_references/configuration_references/template/) documentation):

![image](/images/marketplaces/community_mp/running_appliance_nixos_instantiate_next.png)

Then press **Next** button.

On the next screen you might want to go through all tabs and check (and modify in case of necessity) other VM parameters:

![image](/images/marketplaces/community_mp/running_appliance_nixos_instantiate_finish.png)

As soon as you are done with that press **Finish** button.

After that you will be automatically redirected to a screen with VMs. Check your new VM status there.

## Command Line Interface
To instantiate a VM from the VM template using CLI one needs to know either VM template ID or name which can be retrieved from the output of the `onetemplate list` command.

To instantiate a VM from the corresponding VM template you need to execute the command as below specifying either VM template name or ID:
```bash
onetemplate instantiate NixOS
```

