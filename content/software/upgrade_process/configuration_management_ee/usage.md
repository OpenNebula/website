---
title: "Basic Usage"
date: "2025-02-17"
description:
categories:
pageintoc: "252"
tags:
weight: "2"
---

<a id="cfg-usage"></a>

<!--# Basic Usage -->

This section covers `onecfg` tool subcommands:

- [status]({{% relref "#cfg-status" %}}) - Version status
- [init]({{% relref "#cfg-init" %}}) - Initialize version management state
- [validate]({{% relref "#cfg-validate" %}}) - Validate current configuration files
- [diff]({{% relref "#cfg-diff" %}}) - Identify changes in configuration files
- [patch]({{% relref "#cfg-patch" %}}) - Apply ad-hoc changes (from diff) in configuration files
- [upgrade]({{% relref "#cfg-upgrade" %}}) - Upgrade configuration files to a new version

{{< alert title="Important" color="success" >}}
This command must be always run under privileged user `root` directly or via `sudo`. For example:

```default
$ sudo onecfg status
```{{< /alert >}}  

The tool comes with help for each subcommand and command-line option. Simply run without any parameter or run with the parameter `--help` to print the brief documentation (e.g., `onecfg status --help`).

<a id="cfg-status"></a>

## Status

The `status` subcommand provides an overview of the OpenNebula installation. It shows:

- Current OpenNebula version.
- Current configuration files version.
- Backup from previous OpenNebula version to process.
- Available updates with the corresponding migrators.

{{< alert title="Note" color="success" >}}
If status subcommand fails on an **unknown** configuration version, check the section on [init]({{% relref "#cfg-init" %}}) subcommand below.{{< /alert >}} 

Example:

```default
# onecfg status
--- Versions -----------------
OpenNebula: 5.10.1
Config:     5.6.0

--- Backup to Process ---------------------
Snapshot:    /var/lib/one/backups/config/backup
(will be used as one-shot source for next update)

--- Available updates --------
New config: 5.10.0
- from 5.6.0 to 5.8.0 (YAML,Ruby)
- from 5.8.0 to 5.10.0 (YAML,Ruby)
```

{{< alert title="Important" color="success" >}}
**OpenNebula version** and **Configuration version** are tracked independently, but both versions are closely related and must be from the same `X.Y` release (i.e., OpenNebula 5.10.Z must have a configuration on version 5.10.Z). Minor configuration releases `X.Y.Z` are linked to the OpenNebula version for which a significant update has happened. Usually, the configuration version **remains on the same version for all OpenNebula releases** within the same `X.Y` release (i.e., configuration version 5.10.0 is valid for all OpenNebula releases from 5.10.0 to the latest available 5.10.5).{{< /alert >}} 

**Backup to Process** is a one-shot backup that needs to be processed. It’s created automatically by OpenNebula packages (since 5.10.2) during the upgrade and contains a backup of all configuration files from the previous version. Content of the backup is taken, upgraded for the current OpenNebula version, and placed into production directories (`/etc/one/` and `/var/lib/one/remotes/etc`). Any existing content will be replaced there.

Example of status without available updates:

```default
# onecfg status
--- Versions ------------------------------
OpenNebula:  5.10.2
Config:      5.10.0

--- Available Configuration Updates -------
No updates available.
```

### Exit codes

Based on the various statuses, the command will end with the following exit codes:

- **0** - No update available.
- **1** - Updates available.
- **255** - Unspecified error (e.g., unknown versions)

<a id="cfg-init"></a>

## Init

For clean new installations, the `init` subcommand initializes the configuration management state based on the currently installed OpenNebula version.

Parameters:

| Parameter      | Description                                                          | Mandatory   |
|----------------|----------------------------------------------------------------------|-------------|
| `--force`      | Force (re)initialization                                             | NO          |
| `--to` VERSION | Configuration version override (default: current OpenNebula version) | NO          |

Examples:

```default
# onecfg init
INFO  : Initialized on version 5.10.0

# onecfg init
ANY   : Already initialized
```

You can also force configuration reinitialization based on the detected OpenNebula version:

```default
# onecfg init --force
INFO  : Initialized on version 5.10.0
```

Or force reinitialization on your own provided version:

```default
# onecfg init --force --to 5.8.0
INFO  : Initialized on version 5.8.0
```

{{< alert title="Note" color="success" >}}
The version state is stored in the configuration file `/etc/onecfg.conf`. You **shouldn’t modify this file directly**, as it might result in unpredictable behavior.{{< /alert >}} 

### Example

Initialization is necessary when the Onecfg is not sure about the version of current configuration files. When running `onecfg status` in the uninitialized environment, you might get the following error:

```default
# onecfg status
--- Versions ------------------------------
OpenNebula:  5.8.0
Config:      unknown
ERROR: Unknown config version
```

If you are sure the configuration files are current for the OpenNebula version you have (i.e., 5.8.0 in the example above), you can initialize the version management by using OpenNebula version (e.g., `onecfg init`) or by explicitly providing the version configuration files match (e.g., `onecfg init --to 5.6.0`).

In both cases, after the initialization, the configuration version should be known:

```default
# onecfg status
--- Versions ------------------------------
OpenNebula:  5.8.0
Config:      5.8.0

--- Available Configuration Updates -------
No updates available.
```

<a id="cfg-validate"></a>

## Validate

The `validate` subcommand checks that all known [configuration files]({{% relref "appendix#cfg-files" %}}) can be parsed.

Parameters:

| Parameter       | Description                         | Mandatory   |
|-----------------|-------------------------------------|-------------|
| `--prefix` PATH | Root location prefix (default: `/`) | NO          |

Without any parameter provided, it validates and returns only problematic files:

```default
# onecfg validate
ERROR : Unable to process file '/etc/one/oned.conf' - Failed to parse file
```

When running in verbose mode with `--verbose`, it writes all checked files:

```default
# onecfg validate --verbose
INFO  : File '/etc/one/ec2_driver.default' - OK
INFO  : File '/etc/one/az_driver.default' - OK
INFO  : File '/etc/one/auth/ldap_auth.conf' - OK
INFO  : File '/etc/one/auth/server_x509_auth.conf' - OK
...
```

{{< alert title="Note" color="success" >}}
You can also validate files inside a dedicated directory instead of a system-wide installation location using the option `--prefix`. Directory structure inside the prefix **must follow the structure on real locations** (e.g., for real `/etc/one` there must be `$PREFIX/etc/one`).

```default
# onecfg validate --prefix /tmp/ONE --verbose
INFO  : File '/tmp/ONE/etc/one/ec2_driver.default' - OK
INFO  : File '/tmp/ONE/etc/one/az_driver.default' - OK
INFO  : File '/tmp/ONE/etc/one/auth/ldap_auth.conf' - OK
INFO  : File '/tmp/ONE/etc/one/auth/server_x509_auth.conf' - OK
...
```{{< /alert >}}  

### Exit codes

- **0** - all files are OK
- **1** - error when processing some file

<a id="cfg-diff"></a>

## Diff

Similarly to the validation functionality above, the `diff` subcommand reads all [configuration files]({{% relref "appendix#cfg-files" %}}) and identifies changes that were made by the user when compared to base configuration files. It doesn’t make any changes in the files; it only reads and compares them.

Parameters:

| Parameter         | Description                                                           | Mandatory   |
|-------------------|-----------------------------------------------------------------------|-------------|
| `--format` FORMAT | Format of patch data on input: `text` (default), `line` or `yaml`     | NO          |
| `--prefix` PATH   | Root location prefix (default: `/`)                                   | NO          |

Example:

```default
# onecfg diff
/etc/one/oned.conf
- set DEFAULT_DEVICE_PREFIX "\"sd\""
- ins HM_MAD/ARGUMENTS "\"-p 2101 -l 2102 -b 127.0.0.1\""
- ins VM_RESTRICTED_ATTR "\"NIC/FILTER\""
```

Read more about all output formats in [Diff Formats]({{% relref "diff_formats#cfg-diff-formats" %}}) section.

<a id="cfg-patch"></a>

## Patch

{{< alert title="Note" color="success" >}}
This subcommand is also available in OpenNebula **Community Edition**.{{< /alert >}} 

Patch applies diffs, change descriptors, generated by the `diff` subcommand or created manually (as `line` or `yaml` formats) and provided on standard input or as a filename passed as an argument. Changes are applied in `replace` [mode]({{% relref "conflicts#cfg-patch-modes" %}}) and any user customizations on addressed places are overwritten.

Parameters:

| Parameter         | Description                                                                 | Mandatory   |
|-------------------|-----------------------------------------------------------------------------|-------------|
| `-a` or `--all`   | All patch changes must be applied successfully or patch doesn’t<br/>proceed | NO          |
| `-n` or `--noop`  | Runs patch without changing system state                                    | NO          |
| `--format` FORMAT | Format of patch data on input: `line` (default) or `yaml`                   | NO          |
| `--prefix` PATH   | Root location prefix (default: `/`)                                         | NO          |
| `--unprivileged`  | Skip privileged operations (e.g., `chown`) - only for testing               | NO          |

Example with diff passed on standard input:

```default
# onecfg patch --verbose --format line <<EOF
/etc/one/oned.conf set PORT 2633
/etc/one/oned.conf set LISTEN_ADDRESS "\"127.0.0.1\""
/etc/one/oned.conf set DB/BACKEND "\"mysql\""
/etc/one/oned.conf ins DB/SERVER "\"localhost\""
/etc/one/oned.conf ins DB/USER "\"oneadmin\""
/etc/one/oned.conf ins DB/PASSWD "\"secret_password\""
/etc/one/oned.conf ins DB/NAME "\"opennebula\""
EOF
INFO  : Applying patch to 1 files
ANY   : Backup stored in '/var/lib/one/backups/config/2020-12-22_01:20:40_2878523'
INFO  : Patched '/etc/one/oned.conf' with 6/7 changes
INFO  : Applied 7/7 changes
```

Here is the same example with diff passed as a file:

```default
# onecfg patch --verbose --format line /tmp/diff-oned1
```

By default, patch process finishes successfully even if all changes were not applied. We can distinguish between full or partial application by checking the exit code of the command. We can also request to apply all or none of the changes by using `--all` argument.

```default
# onecfg patch --verbose --format line --all /tmp/diff-oned2
INFO  : Applying patch to 1 files
ANY   : Backup stored in '/var/lib/one/backups/config/2020-12-22_01:31:18_2881111'
INFO  : Patched '/etc/one/oned.conf' with 3/7 changes
INFO  : Applied 3/7 changes
ERROR : Modifications not saved due to 4 unapplied changes!
```

Subcommands `diff` and `patch` can be chained to apply changes from one Front-end to another Front-end (use carefully!):

```default
# onecfg diff --format yaml | ssh frontend2 onecfg patch --format yaml --verbose
```

### Exit codes

- **0** - All patch changes were applied
- **1** - Some diff changes were applied
- **255** - Error during application, nothing to apply or other error

<a id="cfg-upgrade"></a>

## Upgrade

The `upgrade` subcommand makes all the changes in configuration files to update content from one version to another. It mainly does the following steps:

- Detect if an upgrade is necessary (or, at least, if one-shot backup should be processed)
- Back up existing configuration files
- Apply upgrades (run migrators)
- Copy upgraded files back

{{< alert title="Important" color="success" >}}
Upgrade operation is always done on a copy of your production configuration files in the temporary directory. If anything fails during the upgrade process, it doesn’t affect the real files. When the upgrade is successfully completed for all files and for all intermediate versions, the new state is copied back to production locations. In case of serious failure during the final copy back, there should be a backup stored in `/var/lib/one/backups/config/` for manual restore.{{< /alert >}} 

{{< alert title="Note" color="success" >}}
You can first test the dry upgrade with `--noop`, which doesn’t change real production files. It skips the final copy back phase.{{< /alert >}} 

{{< alert title="Important" color="success" >}}
Upgrade operation detects changed values and preserves their content. Using patch mode’s **replace** described in [Troubleshooting]({{% relref "conflicts#cfg-conflicts" %}}), the user can request to replace changed values with default ones for which **new default appears in the newer version**.{{< /alert >}} 

Parameters:

| Parameter             | Description                                                                                 | Mandatory   |
|-----------------------|---------------------------------------------------------------------------------------------|-------------|
| `--from` VERSION      | Old configuration version (default: current)                                                | NO          |
| `--to` VERSION        | New configuration version (default: autodetected from OpenNebula)                           | NO          |
| `-n` or `--noop`      | Runs upgrade without changing system state                                                  | NO          |
| `--unprivileged`      | Skip privileged operations (e.g., `chown`) - only for testing                               | NO          |
| `--patch-modes` MODES | Patch modes per file and version                                                            | NO          |
| `--patch-safe`        | Use the default patch safe mode for each file type                                          | NO          |
| `--recreate`          | Recreate deleted files that would be changed                                                | NO          |
| `--prefix` PATH       | Root location prefix (default: `/`)                                                         | NO          |
| `--read-from` PATH    | Backup directory to take as source of current state<br/>(instead of production directories) | NO          |

In most cases, the upgrade from one version to another will be as easy as simply running the command `onecfg upgrade` without any extra parameters. It’ll upgrade based on internal configuration version tracking and the currently installed OpenNebula. For example:

```default
# onecfg upgrade
ANY   : Backup stored in '/tmp/onescape/backups/2019-12-16_13:10:16_18130'
ANY   : Configuration updated to 5.10.0
```

{{< alert title="Important" color="success" >}}
The upgrade process tries to apply changes from newer versions to your current configuration files (i.e., diff/patch approach modified for each different configuration file type). If the configuration files have been heavily modified, the upgrade might easily fail. The dedicated section describes how to [deal with conflicts]({{% relref "conflicts#cfg-conflicts" %}}) during the upgrade (patching) process.{{< /alert >}} 

If there is no upgrade available, the tool will not do anything:

```default
# onecfg upgrade
ANY   : No updates available
```

To see the files changed during the upgrade, run the command in verbose mode via `--verbose` parameter. For example:

```default
# onecfg upgrade --verbose
INFO  : Checking updates from 5.8.0 to 5.10.0
ANY   : Backup stored in '/tmp/onescape/backups/2019-12-12_15:14:39_18278'
INFO  : Updating from 5.8.0 to 5.10.0
INFO  : Incremental update from 5.8.0 to 5.10.0
INFO  : Update file '/etc/one/cli/onegroup.yaml'
INFO  : Update file '/etc/one/cli/onehost.yaml'
INFO  : Update file '/etc/one/cli/oneimage.yaml'
...
```

### Versions Override

It can be useful to control the upgrade process by providing custom source configuration version (`--from VERSION`), target configuration version (`--to VERSION`), or both configuration versions in cases when some version is not known or when the user wants to have control over the process when upgrading over multiple major versions.

The example below demonstrates step-by-step manual upgrade with versions enforcing (verbose output was filtered):

```default
# onecfg upgrade --verbose --from 5.4.0 --to 5.6.0
INFO  : Checking updates from 5.4.0 to 5.6.0
ANY   : Backup stored in '/tmp/onescape/backups/2019-12-17_18:08:05_28564'
INFO  : Updating from 5.4.0 to 5.6.0
INFO  : Incremental update from 5.4.0 to 5.4.1
INFO  : Incremental update from 5.4.1 to 5.4.2
INFO  : Incremental update from 5.4.2 to 5.4.6
INFO  : Incremental update from 5.4.6 to 5.6.0
ANY   : Configuration updated to 5.6.0

# onecfg upgrade --verbose --to 5.8.0
INFO  : Checking updates from 5.6.0 to 5.8.0
ANY   : Backup stored in '/tmp/onescape/backups/2019-12-17_18:10:18_29087'
INFO  : Updating from 5.6.0 to 5.8.0
INFO  : Incremental update from 5.6.0 to 5.8.0
ANY   : Configuration updated to 5.8.0

# onecfg upgrade --verbose
INFO  : Checking updates from 5.8.0 to 5.10.0
ANY   : Backup stored in '/tmp/onescape/backups/2019-12-17_18:11:19_29405'
INFO  : Updating from 5.8.0 to 5.10.0
INFO  : Incremental update from 5.8.0 to 5.10.0
ANY   : Configuration updated to 5.10.0
```

Successful upgrade saves the target version as a new current configuration version.

### Debug Output

The tool provides more detailed information even about individual changes made in the configuration files and status of their application, if run with the debug logging enabled via parameter `--debug`. In the example below, see the **Patch Report** section which uses the format introduced for [diff subcommand]({{% relref "#cfg-diff" %}}) prefixed by patch application status in square brackets:

```default
$ onecfg upgrade --debug
DEBUG : Loading migrators
INFO  : Checking updates from 5.4.0 to 5.10.0
DEBUG : Backing up multiple dirs into '/tmp/onescape/backups/2019-12-16_13:16:16_22128'
DEBUG : Backing up /tmp/ONE540/etc/one in /tmp/onescape/backups/2019-12-16_13:16:16_22128/etc/one
DEBUG : Backing up /tmp/ONE540/var/lib/one/remotes in /tmp/onescape/backups/2019-12-16_13:16:16_22128/var/lib/one/remotes
DEBUG : Loading migrators
ANY   : Backup stored in '/tmp/onescape/backups/2019-12-16_13:16:16_22128'
DEBUG : Restoring multiple dirs from '/tmp/ONE540'
DEBUG : Restoring /tmp/ONE540/etc/one to /tmp/d20191216-22128-qqek6g/etc/one
DEBUG : Restoring /tmp/ONE540/var/lib/one/remotes to /tmp/d20191216-22128-qqek6g/var/lib/one/remotes
INFO  : Updating from 5.4.0 to 5.10.0
INFO  : Incremental update from 5.4.0 to 5.4.1
DEBUG : 5.4.0 -> 5.4.1 - No Ruby pre_up available
INFO  : Update file '/etc/one/az_driver.conf'
DEBUG : --- PATCH REPORT '/etc/one/az_driver.conf' ---
DEBUG : Patch [OK] set instance_types/ExtraSmall/memory = 0.768
DEBUG : Patch [OK] ins instance_types/Standard_A1_v2 = {"cpu"=>1, "memory"=>2.0}
DEBUG : Patch [OK] ins instance_types/Standard_A2_v2 = {"cpu"=>2, "memory"=>4.0}
DEBUG : Patch [OK] ins instance_types/Standard_A4_v2 = {"cpu"=>4, "memory"=>8.0}
DEBUG : Patch [--] ins instance_types/Standard_A8_v2 = {"cpu"=>8, "memory"=>16.0}
DEBUG : Patch [--] ins instance_types/Standard_A2m_v2 = {"cpu"=>2, "memory"=>16.0}
DEBUG : Patch [--] ins instance_types/Standard_A4m_v2 = {"cpu"=>4, "memory"=>32.0}
DEBUG : Patch [--] ins instance_types/Standard_A8m_v2 = {"cpu"=>8, "memory"=>64.0}
DEBUG : Patch [--] ins instance_types/Standard_G1 = {"cpu"=>2, "memory"=>28.0}
...
```
