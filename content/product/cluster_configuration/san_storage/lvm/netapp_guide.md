---
title: "SAN/LVM: NetApp setup"
linkTitle: "NetApp: SAN setup"
weight: "5"
---

This setup assumes you are using NetApp ONTAP with iSCSI and are trying to use it as a backend for one of OpenNebula's [LVM datastore options]({{% relref "." %}}). The configuration is standard and doesn't require any special feature beyond basic LUN management, so if you are already comfortable with the NetApp ONTAP interface and its functionality, feel free to create the resources as you see fit.

{{< alert title="Note" color="success" >}}
This guide is provided as a prerequisite to use the LVM drivers over a NetApp appliance. It's NOT
needed if you're using the [native NetApp]({{% relref "../netapp" %}}) driver.
{{< /alert >}}

## NetApp Configuration

### SVM (Storage Virtual Machine)

Create or use an existing SVM which has iSCSI enabled.  Navigate to **Storage → Storage VMs** to see the list.

If you are creating a Storage VM, the option is under the **Access Protocol** option when creating a new SVM.

If you are updating an existing Storage VM, first click the name of the SVM to go into its settings.  There should be a card here for iSCSI, click on the arrow to view the settings there. If necessary, click the slider at the top to **Enable** the iSCSI protocol.

### Initiator Group

In order to make the LUN we will create available on all of the hosts we need to create an initiator group to assign the LUN to.  Navigate to **Hosts → SAN initiator groups → + Add**. On this form, provide an identifiable Name and set the Host Operating System to Linux.

For the "Initiator group members" section below it should have **Host initiators** selected.  You can either use the existing initiator names on your hosts, found in `/etc/iscsi/initiatorname.iscsi` after iscsid has been started once, or you can define your own initiator name in that file by changing its contents to something like `InitiatorName=iqn.2024-01.com.example.netapp:some.host.id` then restarting iscsid. Whichever method you choose, click the **+ Add initiator** and insert the initiator name along with a description for each of your hosts.

<center>
{{< image path=/images/netapp_add_igroup.png width=500 alt=image0 >}}
</center>

{{< alert title="Note" color="success" >}}
When you add or remove hosts from your OpenNebula installation, you should update the initiator group as well to ensure their access to the LUN.
{{< /alert >}}

### Volume and LUN

Since we are just going to have a single LUN in a Volume for this we can just create the LUN without first making the Volume.  Creating a LUN directly in ONTAP System Manager will automatically create a backing Volume for it. You could also create one inside of an existing volume if you prefer.

Navigate to **Storage → LUNs** and click the **+ Add** button here. Select the **More Options** button to expand this form.  Define a name for the LUN. Since you're only creating one, the name itself can serve as the prefix. In the next section, Storage and Optimization, set **Number of LUNs** to 1 and then define the proper size for your datastore. Performance Service Level is tied to your Storage VM's backing aggregates. In most cases there is only one aggregate, so the default is fine.

Under **Protection** you do not need to enable Snapshots or SnapMirror. These snapshots would be for the entire volume so they could be quite large, and LVM has a snapshot system to snapshot the individual logical volumes anyways.

Under **Host Information** select the Host Operating System as Linux, then LUN format should default to Linux as well.  Then under 'Host Mapping' select 'Existing initiator group' and select the initiator group we created in the previous section.

<center>
{{< image path=/images/netapp_add_lun.png width=500 alt="image1" >}}
</center>

Once done here, click Save to complete creating the LUN which should also map the LUN to the proper initiator group.  At this point the device should be accessible on the hosts and frontend after rescanning iSCSI busses using `iscsiadm -m session --rescan` and running `multipath -ll`.  After this, you should be able to continue with the OpenNebula LVM Thin Datastore Setup

## Front-end and Host Configuration

The Frontend and Hosts of OpenNebula should have their `/etc/multipath.conf` to include these sections:

~~~
devices {
    device {
        vendor "NETAPP"
        product "LUN.*"
        no_path_retry queue
        path_checker tur
        user_friendly_names yes
        alias_prefix "mpath"
    }
}

blacklist {
    devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
    devnode "^hd[a-z][[0-9]*]"
    devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
}
~~~

If you have an existing multipath configuration file please merge them together if possible.

Please ensure you restart your multipath daemon to pick up the changes: `systemctl restart multipathd`
