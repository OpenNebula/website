---
title: PureStorage - LVM-thin Validation
weight: "4"
---

This setup assumes you're using a PureStorage FlashArray with iSCSI and want to use it as a backend for OpenNebula's LVM Thin datastore. The configuration is straightforward and uses standard volume and host mappings. If you're already familiar with the PureStorage interface, you can create the required resources however you prefer — this just outlines a typical setup.

## PureStorage Configuration

### Host and Host Group

For each of the hosts and frontend you'll need to either gather or define their iSCSI Initiator Name. If you have already started iscsid at least once on the machine it should have a name generated in `/etc/iscsi/initiatorname.iscsi`. If you would prefer to define it, you can modify that file's contents to something like `InitiatorName=iqn.2024-01.com.example.pure:some.host.id` then restarting iscsid (and then reconnect any active iscsi sessions, if already connected).  Each name must be unique.

Navigate to **Storage → Hosts** in the PureStorage dashboard. For each OpenNebula host and frontend, select the **+** in the top right of the Hosts card and set a **Name** that clearly identifies the host, and leave the Personality as **None**.  You can also use the "Create Multiple…" if you have many hosts.

<center>
{{< image path=/images/purestorage_add_hostgroup.png width=500 alt="image0" >}}
</center>

Once each host is populated in the list, click into each of them and then on the **Host Ports** card, select the Menu (**⋮**) button and select **Configure IQNs**. Paste the initiator name from `/etc/iscsi/initiatorname.iscsi` from the proper host here.

Once all hosts have been added and their IQNs have been inserted, create a Host Group by navigating to **Storage → Hosts**, then on the **Host Groups** card select the **+** button and provide an identifiable name for it.

Then, click into the host group and on the **Member Hosts** card there click the Menu (**⋮**) button and select **Add…**. Here, you can select all of the hosts you had created previously, then click **Add**.

### Volume Creation and Connection

From the PureStorage dashboard, navigate to **Storage → Volumes**.  Here, in the top right of the Volumes card, select **+**.

Give the volume a name (this can just be the name of your OpenNebula LVM volume group or something descriptive), and set the desired size. Thin provisioning is always enabled on Pure, so there’s no need to configure anything extra.

You don’t need to configure snapshots, protection policies, or replication unless you’re doing something more advanced. For basic OpenNebula integration, just create the volume and leave everything else at defaults.

Click on the volume you just created, and on the **Connected Host Groups** card, click the Menu (**⋮**) button and click **Connect…**. Select your host group (or individual hosts if you’re not using a group), and confirm the connection.

<center>
{{< image path=/images/purestorage_connect_hostgroup.png width=500 alt="image0" >}}
</center>

Once connected, the volume will be exposed to all hosts in the group. You can update the host group if you add/remove hosts from your OpenNebula installation.

After this is complete, the volume should be visible on your OpenNebula hosts after rescanning iSCSI sessions (via `iscsiadm -m session --rescan`) and finding the new device with `multipath -ll` and `lsblk`. You can then proceed with the LVM Thin volume group creation and OpenNebula LVM Thin Datastore Setup as usual.

## Front-end and Hosts Configuration

The Frontend and Hosts of OpenNebula should have their `/etc/multipath.conf` to include these sections:

~~~
defaults {
        polling_interval       10
}

devices {
    device {
        vendor                      "NVME"
        product                     "Pure Storage FlashArray"
        path_selector               "queue-length 0"
        path_grouping_policy        group_by_prio
        prio                        ana
        failback                    immediate
        fast_io_fail_tmo            10
        user_friendly_names         no
        no_path_retry               0
        features                    0
        dev_loss_tmo                60
    }
    device {
        vendor                   "PURE"
        product                  "FlashArray"
        path_selector            "service-time 0"
        hardware_handler         "1 alua"
        path_grouping_policy     group_by_prio
        prio                     alua
        failback                 immediate
        path_checker             tur
        fast_io_fail_tmo         10
        user_friendly_names      no
        no_path_retry            0
        features                 0
        dev_loss_tmo             600
    }
}
~~~

If you have an existing multipath configuration file please merge them together if possible.

Please ensure you restart your multipath daemon to pick up the changes: `systemctl restart multipathd`
