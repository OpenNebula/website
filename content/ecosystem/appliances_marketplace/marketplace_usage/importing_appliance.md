---
title: "Importing an Appliance"
type: docs
linkTitle: "Importing an Appliance"
weight: 3
---

Please, find below a set of steps need to be performed either via graphical web interface or command line one to add one of the appliances from the Cmmunity Marketplace to OpenNebula cloud.

## Sunstone
To add one of the appliances from Community Marketplace via OpenNebula graphical web interface called FireEdge Sunstone, please, perform the following steps.

Log into Firedge Sunstone web interface as any cloud user eligible to save the images into one of the datastores as well as to create new templates.

Go to **Storage** -> **Apps**:
![image](/images/marketplaces/community_mp/importing_appliance_menu.png)

Click on **Filter** button to open an additional menu and select "OpenNebula Community" as a value in the **Marketplace** field:
![image](/images/marketplaces/community_mp/importing_appliance_filter.png)

Selected filters are applied automatically. Click on any empty space outside of the drop-down filter menu to make it disappeared. Scroll down a list of Community Marketplace appliances and select a desired one (we are going to **NixOS** appliance as an example in that guide):

![image](/images/marketplaces/community_mp/importing_appliance_nixos.png)

Press **Import** button to open a dialog on importing an appliance:
![image](/images/marketplaces/community_mp/importing_appliance_import.png)

One can modify an image and VM template names or keep the original ones:
![image](/images/marketplaces/community_mp/importing_appliance_import_next.png)

As soon as you finish with that press **Next** button to proceed next dialog screen.
Select a datastore you want to save the selected image and press **Finish** button:
![image](/images/marketplaces/community_mp/importing_appliance_import_finish.png)

One can check the status of imported image in the **Storage** -> **Images** menu:
![image](/images/marketplaces/community_mp/importing_appliance_images.png)

As soon as its state becomes **READY** as on the picture below:
![image](/images/marketplaces/community_mp/importing_appliance_image_ready.png)


one can proceed to **VM template** menu and instantiate a VM from corresponding VM template (check ["Running Appliance"](running_appliance.md) section for details).

## CLI
List the appliances from the Community Marketplace:
```
onemarketapp list -f MARKET="OpenNebula Community"
  ID NAME                            VERSION  SIZE    ARCH HYPERVISOR STAT TYPE  REGTIME MARKET     ZONE
 118 UERANSIM                     6.10.0-3-2   10G  x86_64 kvm         rdy  img 04/04/25 OpenNebula    0
 117 RabbitMQ                     6.10.0-3-2  2.2G  x86_64 kvm         rdy  img 03/31/25 OpenNebula    0
 116 NixOS                        25.05.8032   10G  x86_64 kvm         rdy  img 06/09/25 OpenNebula    0
 115 Lithops - Virtual Router     6.10.0-2-2    0M  x86_64 kvm         rdy  tpl 10/11/24 OpenNebula    0
 114 Lithops - Worker             6.10.0-3-2  4.9G  x86_64 kvm         rdy  img 05/13/25 OpenNebula    0
 113 Lithops Service              6.10.0-3-2    0M  x86_64 kvm         rdy  srv 05/13/25 OpenNebula    0
 112 Lithops - MinIO              6.10.0-3-2  2.2G  x86_64 kvm         rdy  img 10/11/24 OpenNebula    0
 111 Lithops - Client             6.10.0-3-2    0M  x86_64 kvm         rdy  tpl 05/13/25 OpenNebula    0
 110 Lithops                      6.10.0-3-2  4.9G  x86_64 kvm         rdy  img 05/13/25 OpenNebula    0
```
Note the applinace ID you want to import (we will use the appliance **NixOS** with ID #116 in our example below).
List your datastores and note the datastore ID where you want to import the appliance:
```
onedatastore list
```

Save desired appliance (an image and corresponding VM template) into specified datastore:
```
onemarketapp export 116 NixOS -d 101
```

Note the saved appliance ID to refer it while checking its status e.g. with the command as below:
```
oneimage list -f ID=5 -l STAT --no-header
```

As soon as its state becomes **READY** one can instantiate a VM from the corresponding VM template (check ["Running Appliance"](running_appliance.md) section for details).

