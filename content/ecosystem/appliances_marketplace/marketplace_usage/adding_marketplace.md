---
title: "Adding the Community Marketplace to OpenNebula"
type: docs
linkTitle: "Adding the Community Marketplace to OpenNebula"
weight: 2
---

Please, find below a set of steps need to be performed either via graphical web interface or command line one to add a community marketplace to an OpenNebula deployment.

## Sunstone
To add the OpenNebula Community Marketplace (CM) via OpenNebula graphical web interface called FireEdge Sunstone, please, perform the following steps.

Log into Firedge Sunstone web interface as `oneadmin` user.

Go to **Storage** -> **Marketplaces**:
![image](/images/marketplaces/community_mp/adding_community_mp_menu.png)

Click on **Create** button:
![image](/images/marketplaces/community_mp/adding_community_mp_create.png)

Provide the values for **Name** (e.g. "OpenNebula Community"), **Description** (e.g. "OpenNebula Community Marketplace") and **Storage backend** ("OpenNebula Systems" has to be chosen) fields. Then click on the **Next** button located at the right top corner of the screen as shown on the picture below:

![image](/images/marketplaces/community_mp/adding_community_mp_values.png)

Specify ``https://community-marketplace.opennebula.io`` in the **Endpoint URL for marketplace** field and click **Finish** button:
![image](/images/marketplaces/community_mp/adding_community_mp_url.png)

After all these steps the OpenNebula Community Marketplace should appear in the list of available marketplaces:
![image](/images/marketplaces/community_mp/adding_community_mp_list.png)


It might take a while (several minutes) the appliances from the Community Marketplace appear in the list of appliances in your OpenNebula installation.
One can check the `oned.log` file against monitoring queries:
```
egrep -i "Marketplace OpenNebula Community" /var/log/one/oned.log
```

## CLI
Create config file for community-marketplace:
```
cat << EOF > community-marketplace.conf  
NAME        = "OpenNebula Community"
MARKET_MAD  = one
ENDPOINT    = "https://community-marketplace.opennebula.io"
DESCRIPTION = "OpenNebula Community Marketplace"
EOF
```

Create a marketplace from that configuration file:
```
onemarket create community-marketplace.conf
```

Check if the community marketplace has been created:
```
onemarket list
```

One needs to wait a bit for available appliances showing up in the list.
