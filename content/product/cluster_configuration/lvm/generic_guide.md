---
title: "SAN/LVM: Generic setup"
linkTitle: "Generic SAN setup"
weight: "4"
---


### Hosts SAN Configuration

The abstraction required to access LUNs consists of block devices. This means that there are
several ways to set them up, although it usually involves using a network block protocol such as
iSCSI or Fibre Channel, as well as some way to make it redundant, like DM Multipath.

Here is a sample session for setting up access via iSCSI and multipath:

```
# === ISCSI ===

TARGET_IP="192.168.1.100"                             # IP of SAN appliance
TARGET_IQN="iqn.2023-01.com.example:storage.target1"  # iSCSI Qualified Name

# === Install tools ===
# RedHat derivates:
sudo dnf install -y iscsi-initiator-utils
# Ubuntu/Debian:
sudo apt update && sudo apt install -y open-iscsi

# === Enable iSCSI services ===
# RedHat derivates:
sudo systemctl enable --now iscsid
# Ubuntu/Debian:
sudo systemctl enable --now open-iscsi

# === Discover targets ===
sudo iscsiadm -m discovery -t sendtargets -p "$TARGET_IP"

# === Log in to the target ===
sudo iscsiadm -m node -T "$TARGET_IQN" -p "$TARGET_IP" --login

# === Make login persistent across reboots ===
sudo iscsiadm -m node -T "$TARGET_IQN" -p "$TARGET_IP" \
     --op update -n node.startup -v automatic
```

```
# === MULTIPATH ===

# === Install tools ===
# RedHat derivates:
sudo dnf install -y device-mapper-multipath
# Ubuntu/Debian:
sudo apt update && sudo apt install -y multipath-tools

# === Enable multipath daemon ===
sudo systemctl enable --now multipathd

# === Create multipath config file ===
sudo tee /etc/multipath.conf > /dev/null <<EOF
defaults {
    user_friendly_names yes
    find_multipaths yes
}
# Optional: blacklist local boot disks if needed
# blacklist {
#     devnode "^sd[a-z]"
# }
EOF

# === Reload multipath ===
sudo multipath -F    # Flush existing config (safely if not in use)
sudo multipath       # Re-scan for multipath devices
sudo systemctl restart multipathd

# === Show current multipath devices ===
sudo multipath -ll
```

<a id="frontend-configuration"></a>

## Front-end Configuration

The Front-end needs access to the shared SAN server in order to perform LVM operations. It can
either access it directly, or using some host(s) as proxy/bridge.

For direct access, **the Front-end will need to be configured in the same way as hosts**, and no
further configuration will be needed. Example for illustration purposes:

```
-------------
| Front-end | ---- /dev/mapper/mpath* ------+
-------------     (iSCSI + multipath)       |
                                            |
                                            v
  ---------                              --------------
  | host2 | ---- /dev/mapper/mpath* ---> | SAN server |
  ---------     (iSCSI + multipath)      --------------
                                            ^
                                            |
  ---------                                 |
  | hostN | ---- /dev/mapper/mpath* --------+
  ---------     (iSCSI + multipath)
```

Alternatively, delegate front-end SAN operations to one or more specific hosts by setting the `BRIDGE_LIST` attribute in the System datastore. The front-end refers to one of the hosts in the list to proxy SAN operations. Only a reduced set of operations are initiated in the front-end, such as the ones intended for undeployed VMs.

## Troubleshooting

### LVM Devices File

**Problem:** LVM does not show my iSCSI/multipath devices (with e.g., `pvs`), although I can see them
with `multipath -ll` or `lsblk`.

**Possible solution:**

The LVM version in some operating systems or Linux distributions, by default,
doesn't scan the whole `/dev` directory for possible disks. Instead, you need to explicitly
**whitelist** them in `/etc/lvm/devices/system.devices`. You can check whether that's your case by
running:

```
lvmconfig --type full devices/use_devicesfile
```

If it returns `devices/use_devicesfile=1`, then the devices file is being used and enforced. In that
case, just add the device path to the whitelist and check again:

```
# echo /dev/mapper/mpatha >> /etc/lvm/devices/system.devices
# pvs
```
