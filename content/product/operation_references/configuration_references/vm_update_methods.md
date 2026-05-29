---
title: 'Updating Virtual Machine Configuration'
linkTitle: 'Updating VM Configuration'
---
<!-- README before editing: This document contains an automatically generated table! -->
<!-- Add rows to the source Excel file to update the table, do not change the column structure! -->
<!-- Table source:  assets/tables/vm_update_methods.xlsx -->
<!-- Run the converter script from the root directory to regenerate the table: -->
<!-- Install dependencies first: python3 -m pip install openpyxl -->
<!-- python3 scripts/vm_update_methods_converter.py -->
<!-- You may edit the text above and below the table directly in this document. Do not edit the table here! -->

OpenNebula provides a powerful set of tools through the GUI, CLI and API that allow you to update Virtual Machine configuration on the fly, even while the VM is running. This flexibility enables you to optimize performance, adjust resource allocation, and manage your virtual infrastructure with ease. The following table details all the VM configuration update methods available with interface coverage and notes. Use the filter to find the methods relevant to your use case.

## VM Configuration Update Methods Reference

<!-- VM METHODS TABLE -->
{{< vm-methods-table >}}
<table id="data-spreadsheet" class="display" style="width:100%">
  <thead>
    <tr class="dt-layout-row">
      <th>SectionTracker</th>
      <th style="width: 20%;">Method</th>
      <th style="width: 15%;">Attribute</th>
      <th style="width: 12%;">Description</th>
      <th style="width: 12%;">Updating in Running state</th>
      <th style="width: 12%;">Updating in POWEROFF state</th>
      <th style="width: 5%;">API</th>
      <th style="width: 5%;">CLI</th>
      <th style="width: 5%;">GUI</th>
      <th style="width: 20%;">Limitations/Notes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Compute</td>
      <td>one.vm.resize</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/CPU">VM/TEMPLATE/CPU</td>
      <td>Changes VM CPU allocation factor</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Scheduler/resource allocation attribute; changes applied after power cycle for effective runtime impact</td>
    </tr>
    <tr>
      <td>Compute</td>
      <td>one.vm.resize</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/VCPU">VM/TEMPLATE/VCPU</td>
      <td>Changes VM virtual CPU count</td>
      <td>Partial</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>VCPU hotplug support required for live effect; otherwise applied after reboot</td>
    </tr>
    <tr>
      <td>Compute</td>
      <td>one.vm.resize</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/MEMORY">VM/TEMPLATE/MEMORY</td>
      <td>Changes VM memory allocation</td>
      <td>Partial</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Memory hotplug support required for live effect; otherwise applied after reboot</td>
    </tr>
    <tr>
      <td>Disk</td>
      <td>one.vm.attach</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/DISK">VM/TEMPLATE/DISK</td>
      <td>Attaches a disk to the VM</td>
      <td>Partial</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Disk hotplug support depends on disk bus/controller</td>
    </tr>
    <tr>
      <td>Disk</td>
      <td>one.vm.detach</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/DISK">VM/TEMPLATE/DISK</td>
      <td>Detaches a disk from the VM</td>
      <td>Partial</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>May fail for active/system disks or unsupported buses</td>
    </tr>
    <tr>
      <td>Disk</td>
      <td>one.vm.diskresize</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/DISK">VM/TEMPLATE/DISK</td>
      <td>Resizes VM disk</td>
      <td>Partial</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>May fail for active/system disks or unsupported buses</td>
    </tr>
    <tr>
      <td>Disk</td>
      <td>one.vm.disksaveas</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/DISK">VM/TEMPLATE/DISK</td>
      <td>Saves VM disk as image</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>NIC</td>
      <td>one.vm.attachnic</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/NIC">VM/TEMPLATE/NIC</td>
      <td>Attaches NIC to the VM</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>NIC</td>
      <td>one.vm.detachnic</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/NIC">VM/TEMPLATE/NIC</td>
      <td>Detaches NIC from the VM</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>NIC</td>
      <td>one.vm.updatenic</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/NIC">VM/TEMPLATE/NIC</td>
      <td>Updates VM NIC configuration</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>NIC</td>
      <td>one.vm.attachsg</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/NIC/SECURITY_GROUPS">VM/TEMPLATE/NIC/SECURITY_GROUPS</td>
      <td>Attaches security group to VM NIC</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>NIC</td>
      <td>one.vm.detachsg</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/NIC/SECURITY_GROUPS">VM/TEMPLATE/NIC/SECURITY_GROUPS</td>
      <td>Detaches security group from VM NIC</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>PCI</td>
      <td>one.vm.attachpci</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/PCI">VM/TEMPLATE/PCI</td>
      <td>Attaches PCI device to the VM</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Only in POWER OFF state</td>
    </tr>
    <tr>
      <td>PCI</td>
      <td>one.vm.detachpci</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/PCI">VM/TEMPLATE/PCI</td>
      <td>Detaches PCI device from the VM</td>
      <td>NO </td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Only in POWER OFF state</td>
    </tr>
    <tr>
      <td>Snapshots</td>
      <td>one.vm.snapshotcreate</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/SNAPSHOT">VM/TEMPLATE/SNAPSHOT</td>
      <td>Creates VM snapshot</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>Snapshots</td>
      <td>one.vm.snapshotrevert</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/SNAPSHOT">VM/TEMPLATE/SNAPSHOT</td>
      <td>Reverts VM to snapshot state</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Only in POWER OFF state</td>
    </tr>
    <tr>
      <td>Snapshots</td>
      <td>one.vm.snapshotdelete</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/SNAPSHOT">VM/TEMPLATE/SNAPSHOT</td>
      <td>Deletes VM snapshot</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>Snapshots</td>
      <td>one.vm.disksnapshotcreate</td>
      <td class="truncated-attribute" title="VM/SNAPSHOTS/SNAPSHOT">VM/SNAPSHOTS/SNAPSHOT</td>
      <td>Creates disk snapshot</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>Snapshots</td>
      <td>one.vm.disksnapshotdelete</td>
      <td class="truncated-attribute" title="VM/SNAPSHOTS/SNAPSHOT">VM/SNAPSHOTS/SNAPSHOT</td>
      <td>Deletes disk snapshot</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>Snapshots</td>
      <td>one.vm.disksnapshotrevert</td>
      <td class="truncated-attribute" title="VM/SNAPSHOTS/SNAPSHOT">VM/SNAPSHOTS/SNAPSHOT</td>
      <td>Reverts disk to snapshot state</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Only in POWER OFF state</td>
    </tr>
    <tr>
      <td>Snapshots</td>
      <td>one.vm.disksnapshotrename</td>
      <td class="truncated-attribute" title="VM/SNAPSHOTS/SNAPSHOT">VM/SNAPSHOTS/SNAPSHOT</td>
      <td>Renames disk snapshot</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>Backups</td>
      <td>one.vm.backup</td>
      <td class="truncated-attribute" title="VM/BACKUPS">VM/BACKUPS</td>
      <td>Creates VM backup</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>Backups</td>
      <td>one.vm.backupcancel</td>
      <td class="truncated-attribute" title="VM/BACKUPS">VM/BACKUPS</td>
      <td>Cancels running VM backup job</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>Backups</td>
      <td>one.vm.restore</td>
      <td class="truncated-attribute" title="VM/BACKUPS">VM/BACKUPS</td>
      <td>Restores VM disks/state from backup</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Only in POWER OFF state</td>
    </tr>
    <tr>
      <td>VM attributes</td>
      <td>one.vm.update</td>
      <td class="truncated-attribute" title="VM/USER_TEMPLATE">VM/USER_TEMPLATE</td>
      <td>Updates VM user template</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Updates on the next power cycle</td>
    </tr>
    <tr>
      <td>VM attributes</td>
      <td>one.vm.rename</td>
      <td class="truncated-attribute" title="VM/NAME">VM/NAME</td>
      <td>Renames VM</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>VM attributes</td>
      <td>one.vm.chown</td>
      <td class="truncated-attribute" title="VM/UID, VM/GID, VM/UNAME, VM/GNAME">VM/UID, VM/GID, VM/UNAME, VM/GNAME</td>
      <td>Changes VM ownership</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>VM attributes</td>
      <td>one.vm.chmod</td>
      <td class="truncated-attribute" title="VM/PERMISSIONS">VM/PERMISSIONS</td>
      <td>Changes VM permissions</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>VM scheduled actions</td>
      <td>one.vm.schedadd</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/SCHED_ACTION">VM/TEMPLATE/SCHED_ACTION</td>
      <td>Adds scheduled VM action</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>VM scheduled actions</td>
      <td>one.vm.schedupdate</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/SCHED_ACTION">VM/TEMPLATE/SCHED_ACTION</td>
      <td>Updates scheduled VM action</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>VM scheduled actions</td>
      <td>one.vm.scheddelete</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/SCHED_ACTION">VM/TEMPLATE/SCHED_ACTION</td>
      <td>Deletes scheduled VM action</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>Other</td>
      <td>one.vm.lock</td>
      <td class="truncated-attribute" title="VM/LOCK">VM/LOCK</td>
      <td>Locks VM actions</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>Other</td>
      <td>one.vm.unlock</td>
      <td class="truncated-attribute" title="VM/LOCK">VM/LOCK</td>
      <td>Unlocks VM actions</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>Other</td>
      <td>one.vm.exec</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/QEMU_GA_EXEC">VM/TEMPLATE/QEMU_GA_EXEC</td>
      <td>Executes command inside guest</td>
      <td>YES</td>
      <td>NO</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Requires guest agent</td>
    </tr>
    <tr>
      <td>Other</td>
      <td>one.vm.retryexec</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/QEMU_GA_EXEC">VM/TEMPLATE/QEMU_GA_EXEC</td>
      <td>Retries guest command</td>
      <td>YES</td>
      <td>NO</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Requires guest agent</td>
    </tr>
    <tr>
      <td>Other</td>
      <td>one.vm.cancelexec</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/QEMU_GA_EXEC">VM/TEMPLATE/QEMU_GA_EXEC</td>
      <td>Cancels guest command</td>
      <td>YES</td>
      <td>NO</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Requires guest agent</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/OS/ARCH">VM/TEMPLATE/OS/ARCH</td>
      <td>Defines guest CPU architecture</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Effectively immutable for existing VM</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/OS/MACHINE">VM/TEMPLATE/OS/MACHINE</td>
      <td>Defines machine/chipset type used by hypervisor</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/OS/KERNEL">VM/TEMPLATE/OS/KERNEL</td>
      <td>Defines kernel image for direct kernel boot</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Applied after poweroff/resume; direct kernel boot only</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/OS/INITRD">VM/TEMPLATE/OS/INITRD</td>
      <td>Defines initrd image for direct kernel boot</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Applied after poweroff/resume; direct kernel boot only</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/OS/BOOTLOADER">VM/TEMPLATE/OS/BOOTLOADER</td>
      <td>Defines external bootloader</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Not applicable/ignored in KVM</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/OS/BOOTLOADER">VM/TEMPLATE/OS/BOOTLOADER</td>
      <td>Defines VM boot device</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Reflected in OpenNebula UI; libvirt may resolve as default disk boot</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/OS/KERNEL_CMD">VM/TEMPLATE/OS/KERNEL_CMD</td>
      <td>Defines kernel command line parameters</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Applied after poweroff/resume; direct kernel boot only</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/OS/ROOT">VM/TEMPLATE/OS/ROOT</td>
      <td>Defines guest root device</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Applied after poweroff/resume; direct kernel boot only</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/OS/SD_DISK_BUS">VM/TEMPLATE/OS/SD_DISK_BUS</td>
      <td>Defines bus type for SD disks</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Applied after poweroff/resume; </td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/OS/UUID">VM/TEMPLATE/OS/UUID</td>
      <td>Defines VM UUID</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/OS/FIRMWARE">VM/TEMPLATE/OS/FIRMWARE</td>
      <td>Defines VM firmware/UEFI loader</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Applied after poweroff/resume; requires valid OVMF path</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/OS/FIRMWARE_FORMAT">VM/TEMPLATE/OS/FIRMWARE_FORMAT</td>
      <td>Defines firmware image format</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Applied after poweroff/resume with firmware</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/CPU_MODEL/MODEL">VM/TEMPLATE/CPU_MODEL/MODEL</td>
      <td>Defines guest CPU model exposed to VM</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Applied after poweroff/resume if CPU model is valid for host</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/CPU_MODEL/FEATURES">VM/TEMPLATE/CPU_MODEL/FEATURES</td>
      <td>Defines guest CPU feature flags</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Applied after poweroff/resume if features are supported by host CPU</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/FEATURES/ACPI">VM/TEMPLATE/FEATURES/ACPI</td>
      <td>Enables ACPI support</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/FEATURES/PAE">VM/TEMPLATE/FEATURES/PAE</td>
      <td>Enables Physical Address Extension support</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/FEATURES/APIC">VM/TEMPLATE/FEATURES/APIC</td>
      <td>Enables APIC support</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/FEATURES/LOCALTIME">VM/TEMPLATE/FEATURES/LOCALTIME</td>
      <td>Configures guest RTC clock mode</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/FEATURES/HYPERV">VM/TEMPLATE/FEATURES/HYPERV</td>
      <td>Enables Hyper-V enlightenments</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/FEATURES/GUEST_AGENT">VM/TEMPLATE/FEATURES/GUEST_AGENT</td>
      <td>Enables QEMU guest agent channel</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/FEATURES/VIRTIO_SCSI_QUEUES">VM/TEMPLATE/FEATURES/VIRTIO_SCSI_QUEUES</td>
      <td>Configures virtio-scsi queue count</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/FEATURES/VIRTIO_BLK_QUEUES">VM/TEMPLATE/FEATURES/VIRTIO_BLK_QUEUES</td>
      <td>Configures virtio-blk queue count</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/FEATURES/IOTHREADS">VM/TEMPLATE/FEATURES/IOTHREADS</td>
      <td>Configures disk IO threads</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/INPUT/TYPE">VM/TEMPLATE/INPUT/TYPE</td>
      <td>Defines guest input device type</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/INPUT/BUS">VM/TEMPLATE/INPUT/BUS</td>
      <td>Defines guest input device bus</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/GRAPHICS/TYPE">VM/TEMPLATE/GRAPHICS/TYPE</td>
      <td>Defines graphics protocol/backend</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Template changes while running; applied after poweroff/resume. SPICE works with external clients, not FireEdge/Guacamole in this setup</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/GRAPHICS/LISTEN">VM/TEMPLATE/GRAPHICS/LISTEN</td>
      <td>Defines graphics listen address</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/GRAPHICS/PASSWD">VM/TEMPLATE/GRAPHICS/PASSWD</td>
      <td>Defines graphics console password</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Applied after poweroff/resume; password prompt works with external VNC/SPICE clients, not via FireEdge/Guacamole</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/GRAPHICS/KEYMAP">VM/TEMPLATE/GRAPHICS/KEYMAP</td>
      <td>Defines keyboard layout for graphics console</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/GRAPHICS/COMMAND">VM/TEMPLATE/GRAPHICS/COMMAND</td>
      <td>Defines graphics command parameters</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Stored in template but not passed to libvirt domain XML in KVM</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/VIDEO/TYPE">VM/TEMPLATE/VIDEO/TYPE</td>
      <td>Defines virtual video adapter type</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td>Live-applied; without VRAM/related options may fall back to default model such as cirrus</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/VIDEO/IOMMU">VM/TEMPLATE/VIDEO/IOMMU</td>
      <td>Enables IOMMU support for video device</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/VIDEO/ATS">VM/TEMPLATE/VIDEO/ATS</td>
      <td>Enables Address Translation Service for video device</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/VIDEO/VRAM">VM/TEMPLATE/VIDEO/VRAM</td>
      <td>Defines virtual video memory size</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/VIDEO/RESOLUTION">VM/TEMPLATE/VIDEO/RESOLUTION</td>
      <td>Defines guest display resolution</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/RAW/DATA">VM/TEMPLATE/RAW/DATA</td>
      <td>Defines raw hypervisor XML snippet</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Applied after poweroff/resume</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/RAW/DATA_VMX">VM/TEMPLATE/RAW/DATA_VMX</td>
      <td>Defines VMX-specific raw configurationDefines VMX-specific raw configuration</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Not applicable to KVM; template-only/no effect</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/RAW/TYPE">VM/TEMPLATE/RAW/TYPE</td>
      <td>Defines hypervisor backend type</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Acts as driver selector; for KVM must be kvm</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/RAW/VALIDATE">VM/TEMPLATE/RAW/VALIDATE</td>
      <td>Enables raw XML validation</td>
      <td>NO</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>NO</td>
      <td>Template/validation behavior; not a live libvirt change</td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/BACKUP_CONFIG/FS_FREEZE">VM/TEMPLATE/BACKUP_CONFIG/FS_FREEZE</td>
      <td>Enables filesystem freeze during backup</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/BACKUP_CONFIG/KEEP_LAST">VM/TEMPLATE/BACKUP_CONFIG/KEEP_LAST</td>
      <td>Defines number of retained backups</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/BACKUP_CONFIG/BACKUP_VOLATILE">VM/TEMPLATE/BACKUP_CONFIG/BACKUP_VOLATILE</td>
      <td>Includes volatile disks in backup</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/BACKUP_CONFIG/MODE">VM/TEMPLATE/BACKUP_CONFIG/MODE</td>
      <td>Defines backup mode</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
    <tr>
      <td>one.vm.updateconf</td>
      <td>one.vm.updateconf</td>
      <td class="truncated-attribute" title="VM/TEMPLATE/BACKUP_CONFIG/INCREMENT_MODE">VM/TEMPLATE/BACKUP_CONFIG/INCREMENT_MODE</td>
      <td>Defines incremental backup mode</td>
      <td>YES</td>
      <td>YES</td>
      <td>YES </td>
      <td>YES</td>
      <td>YES</td>
      <td></td>
    </tr>
  </tbody>
</table>
{{< /vm-methods-table >}}