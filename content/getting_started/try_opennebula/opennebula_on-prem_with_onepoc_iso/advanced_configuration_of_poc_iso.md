---
title: "Advanced Configuration of the PoC ISO"
description:
weight: 2
---

## OpenNebula Frontend Menu `onefemenu` options {#onefemenu}

{{< alert color="success" >}}
This section under development will include the complete guides for obtaining the OpenNebula PoC ISO image and deploying to your infrastructure. The PoC ISO image is scheduled to be released with OpenNebula 7.0. Stay tuned!
{{< /alert >}}

The options of onefemenu are the following
```bash
                            ┌──────────────────────OpenNebula node Setup─────────────────────────┐
                            │ Setup menu                                                         │
                            │ ┌────────────────────────────────────────────────────────────────┐ │
                            │ │          check_host          Check host requirements           │ │
                            │ │          netconf             Configure network                 │ │
                            │ │          enable_fw           Enable firewalld                  │ │
                            │ │          disable_fw          Disable firewalld                 │ │
                            │ │          add_host            Add OpenNebula Host               │ │
                            │ │          proxy               Configure proxy settings          │ │
                            │ │          tmate               Remote console support            │ │
                            │ │          show_oneadmin_pass  Show oneadmin password            │ │
                            │ │          quit                Exit to Shell                     │ │
                            │ │                                                                │ │
                            │ │                                                                │ │
                            │ │                                                                │ │
                            │ │                                                                │ │
                            │ └────────────────────────────────────────────────────────────────┘ │
                            ├────────────────────────────────────────────────────────────────────┤
                            │                   <  OK  >          <Cancel>                       │
                            └────────────────────────────────────────────────────────────────────┘
```

### `check_host`: Check host requirements {#check_host}

This option ensures that KVM is loaded on the host, thus it can run VMs with acceleration. If everything is OK, the output should look like the following

```bash
                            ┌────────────────────────────────────────────────────────────────────┐
                            │ KVM works and some NIC is available                                │
                            │                                                                    │
                            ├────────────────────────────────────────────────────────────────────┤
                            │                             <  OK  >                               │
                            └────────────────────────────────────────────────────────────────────┘
```


### `netconf`: Configure network {#netconf}

This option launches `nmtui` (the default ncurses configuration interface), which allows the setup of the network and hostname, as more complex network configuration (bonding, VLAN, etc.). Hostname can also be modified on the `nmtui` dialogs

```bash
                                                   ┌─┤ NetworkManager TUI ├──┐
                                                   │                         │
                                                   │ Please select an option │
                                                   │                         │
                                      ┌─────────────────┤ Set Hostname ├──────────────────┐
                                      │                                                   │
                                      │ Hostname onefrontend_____________________________ │
                                      │                                                   │
                                      │                                     <Cancel> <OK> │
                                      │                                                   │
                                      └───────────────────────────────────────────────────┘

                                                   │                         │
                                                   └─────────────────────────┘
```

Once that is finished, a set of ansible scripts will be running to set up certain OpenNebula services that rely on the network.

```bash
TASK [onepoc_frontend : Restart opennebula] ************************************
skipping: [frontend]

TASK [Gather facts from frontends] *********************************************
ok: [frontend] => (item=frontend)

PLAY [Run again on the hosts] **************************************************
skipping: no hosts matched

PLAY RECAP *********************************************************************
frontend                   : ok=40   changed=8    unreachable=0    failed=0    skipped=30   rescued=0    ignored=2

Press any key to continue
```

### `enable_fw` and `disable_fw`: Enable/Disable firewalld {#firewalld}

This options enable and disable the firewall. It is recommended to have perimetral security and keep the firewall disabled.


### `add_host`: Add OpenNebula Host {#add_host}

Adds a host to our installation. After selecting the option, the IP for the host will be asked for

```bash
                                 ┌──────────────────────────────────────────────────────────┐
                                 │ Insert the IP for the node                               │
                                 │ ┌──────────────────────────────────────────────────────┐ │
                                 │ │                                                      │ │
                                 │ └──────────────────────────────────────────────────────┘ │
                                 │                                                          │
                                 ├──────────────────────────────────────────────────────────┤
                                 │               <  OK  >        <Cancel>                   │
                                 └──────────────────────────────────────────────────────────┘

```

Then, the user to log into the node will be asked. It MUST be root or have sudo root access without password

```bash
                                 ┌──────────────────────────────────────────────────────────┐
                                 │ Insert the user for the node                             │
                                 │ ┌──────────────────────────────────────────────────────┐ │
                                 │ │                                                      │ │
                                 │ └──────────────────────────────────────────────────────┘ │
                                 │                                                          │
                                 ├──────────────────────────────────────────────────────────┤
                                 │               <  OK  >        <Cancel>                   │
                                 └──────────────────────────────────────────────────────────┘
```

A confirmation dialog like the following will be shown:

```bash
                       ┌──────────────────────────────────────────────────────────────────────────────┐
                       │ Add node AA.BB.CC.DD logging as user XXXX (with nopasswd root permissions)?  │
                       │ Password will be asked. If not provided, an ssh connection using the ssh key │
                       │ of onepoc user will be used                                                  │
                       │                                                                              │
                       │                                                                              │
                       ├──────────────────────────────────────────────────────────────────────────────┤
                       │                         < Yes >             < No  >                          │
                       └──────────────────────────────────────────────────────────────────────────────┘
```

If the user root on the frontend can log into the host as the user XXXX without password (because of a ssh key exchange), the password won't be asked. If not, the password will be asked:

```bash
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_ed25519.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
XXXX@AA.BB.CC.DD's password:
```

After that, an ansible playbook will run in order to execute all the needed operations on the frontend. This may take some minutes

```
...
PLAY RECAP *********************************************************************
...
...
AA.BB.CC.DD                : ok=52   changed=27   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
frontend                   : ok=43   changed=11   unreachable=0    failed=0    skipped=27   rescued=0    ignored=0

Press any key to continue
```

### `proxy`: Configure proxy settings` {#proxy}

If a proxy server is needed to access to the internet (to download OpenNebula marketplace images), choose this option.

The three following dialogs will appear to setup the http proxy, the https proxy and the domains/IPs that do not need proxy access. After that, an Ansible playbook will run to reflect the configuration changes.

```bash
                                 ┌──────────────────────────────────────────────────────────┐
                                 │ Enter the http proxy value                               │
                                 │ ┌──────────────────────────────────────────────────────┐ │
                                 │ │                                                      │ │
                                 │ └──────────────────────────────────────────────────────┘ │
                                 │                                                          │
                                 ├──────────────────────────────────────────────────────────┤
                                 │               <  OK  >        <Cancel>                   │
                                 └──────────────────────────────────────────────────────────┘

                                 ┌──────────────────────────────────────────────────────────┐
                                 │ Enter the https proxy value                              │
                                 │ ┌──────────────────────────────────────────────────────┐ │
                                 │ │                                                      │ │
                                 │ └──────────────────────────────────────────────────────┘ │
                                 │                                                          │
                                 ├──────────────────────────────────────────────────────────┤
                                 │               <  OK  >        <Cancel>                   │
                                 └──────────────────────────────────────────────────────────┘

                                 ┌──────────────────────────────────────────────────────────┐
                                 │ Enter the no_proxy value                                 │
                                 │ ┌──────────────────────────────────────────────────────┐ │
                                 │ │                                                      │ │
                                 │ └──────────────────────────────────────────────────────┘ │
                                 │                                                          │
                                 ├──────────────────────────────────────────────────────────┤
                                 │               <  OK  >        <Cancel>                   │
                                 └──────────────────────────────────────────────────────────┘
```

After the fields are filled up, Ansible will run to reconfigure OpenNebula. This may take some minutes.

### `tmate`: Remote console support {#tmate}

This will launch tmate, a tmux based terminal that has been made to share the connection. This is very useful for remote management.
After selecting the option, a message like the following will appear:

```bash
Tip: if you wish to use tmate only for remote access, run: tmate -F                                                       [0/0]
To see the following messages again, run in a tmate session: tmate show-messages
Press <q> or <ctrl-c> to continue
---------------------------------------------------------------------
Connecting to ssh.tmate.io...
Note: clear your terminal before sharing readonly access
web session read only: https://tmate.io/t/ro-XXXXXXXXXXXXXXXXXXXX
ssh session read only: ssh ro-XXXXXXXXXXXXXXXX@lon1.tmate.io
web session: https://tmate.io/t/XXXXXXXXXXXXXXXXXXX
ssh session: ssh XXXXXXXXXXXXXXXXXXXXXXXX@lon1.tmate.io
```

The links can be shared with a remote partner so the terminal will be shared between the two parts.


### `show_oneadmin_pass`:  Show oneadmin password` {#show_oneadmin_pass}

This option shows the password for the user oneadmin

```bash
The oneadmin password is XXXXXXXXXXXXXXXXXXXXXXXXXXX
Press any key to continue
```

- Finally, the `quit` option, that leaves onefemenu


## OpenNebula Host Menu `onehostmenu` options {#onehostmenu}

In this PoC ISO, the installation with `onehostmenu` only needs the following options

- [`netconf`](#netconf) (Network Configuration with nmtui)
- [`enable_fw`](#firewalld) (Enable firewalld)
- [`disable_fw`](#firewalld) (Disable firewalld)

No other configuration needs to be done on the hosts.

{{< alert color="success" >}}
All hosts should have different hostnames. Please, take that into account when configuring the network of the nodes
{{< /alert >}}

## Networking advanced Configuration

### Configure Gateway and NAT {#gateway}

In order to access VMs via Network the virtual network must have a reachable gateway

To set the gateway there are some helpers on the file /usr/lib/one/onepoc/one\_aliases.sh

- The aliases `onevnet_add_gw` and `onevnet_del_gw` create or delete the gateway for the necessary bridge if the bridge exists in the frontend (a VM from the desired VNET is running on the frontend).
- The aliases `enable_masquerade` and `disable_masquerade` allow ALL the virtual networks with a gateway to have access to the same external networks as the frontend has.

### Setting interface altnames {#altnames}

If the hosts have different names for the physical interface that has the network (i.e., on one of the hosts the name is `enp3s0` and in another is `eno1`) alternative names can be set for every  interface.  For instance, the following file can be created in the host with interface `eno1`

`/etc/systemd/system/altnames-opennebula.service`

With the following contents

```bash
[Unit]
Description=Set OpenNebula network interface alternative name

[Service]
Type=simple
ExecStart=ip link property add dev eno1 altname one_if

[Install]
WantedBy=multi-user.target
```

Note that the line `ExecStart` has the name of the interface (`eno1`) and the desired name for this physdev (`one_if').
After that is finished, reload, enable and start the service:

```bash
systemctl daemon-reload
systemctl enable altnames-opennebula.service
systemctl start altnames-opennebula.service
```

This will set up the interface `one_if` on this server. It can be checked with the command `ip link show dev one_if`

```bash
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether xx:xx:xx:xx:xx:xx brd ff:ff:ff:ff:ff:ff
    altname one_if
```

Repeat the same on the other hosts but changing eno1 for the required device name in the file.

When all nodes have the altname for the interface, change the PHYDEV of the required virtual networks to `one_if`.

