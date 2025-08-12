---
title: "Example Appliance Development"
type: docs
linkTitle: "Example Appliance Development"
description: "This section describes how to create a new appliance for the Community Marketplace using Zabbix server as an example. The whole process will be showcased from the creation of the appliance code to the necessary steps to contribute to the marketplace. An appliance for Zabbix server will be created using Ubuntu 24.04 as a base image."
weight: 5
---

## Overview

The following sections describe how to build an appliance from scratch, and include:

- Prepare Environment. Prepare the work directory and files, using the `example` appliance as the base. Then customize the Packer build scripts for this appliance.
- User Inputs. Define User Inputs for the appliance, which will allow for customizations when instantiating it.
- Appliance Code. Code that installs and configures the Zabbix software using Ubuntu 24.04 as a base image.
- Generating Image. Instructions on how to build the disk image for the appliance locally.
- VM Template. How to create a VM Template using the local image and instantiate a VM.
- Tests. Definition of tests that need to be contributed to validate the appliance.
- Metadata. Metadata files that are needed to contribute the appliance to the Community Marketplace.
- Pull Request. Prepare a pull request to the GitHub repository to start the contribution process.

## Prepare Environment

The first step is to fork and clone the [marketplace-community](https://github.com/OpenNebula/marketplace-community) repository. Once  the repository has been cloned, the base folder and files structure for the appliance should be created. The `example` appliance should be used as the base for the new appliance, so the following should be done:

- Copy appliances/example -> appliances/zabbix
    - Generate a new UUID with the uuidgen command, then rename the UUID.yaml file to this new UUID.
- Copy apps-code/packer/example -> apps-code/packer/zabbix
    - Rename example.pkr.hcl to zabbix.pkr.hcl
    - Replace all references of “example” with “zabbix” in zabbix.pkr.hcl and variables.pkr.hcl
- Add Zabbix logo to logos folder
- Edit Makefile.config, adding zabbix to SERVICES

The language of choice for this appliance is Ruby instead of bash, so the file `appliances/zabbix/appliance.sh` needs to be deleted and two new files need to be created: `appliances/zabbix/main.rb` and `appliances/zabbix/config.rb`. The working directory should look like this:

![Zabbix appliance working directory](/images/community-marketplace/community_marketplace_working_dir.png)

The packer script needs to be adjusted so it has the correct files for ruby instead of bash. The following code in `apps-code/community-apps/packer/zabbix/zabbix.pkr.hcl`:

```bash
  # Contains the appliance service management tool
  # https://github.com/OpenNebula/one-apps/wiki/apps_intro#appliance-life-cycle
  provisioner "file" {
    source      = "../one-apps/appliances/service.sh"
    destination = "/etc/one-appliance/service"
  }
  # Pull your own custom logic here. Must be called appliance.sh if using bash tools
  provisioner "file" {
    sources     = ["appliances/example/appliance.sh"]
    destination = "/etc/one-appliance/service.d/"
  }
```

Needs to be replaced with:

```ruby
  provisioner "file" {
    sources     = ["../../lib/helpers.rb"]
    destination = "/etc/one-appliance/lib/"
  }

  # Contains the appliance service management tool
  # https://github.com/OpenNebula/one-apps/wiki/apps_intro#appliance-life-cycle
  provisioner "file" {
    source      = "../one-apps/appliances/service.rb"
    destination = "/etc/one-appliance/service"
  }
  # Pull your own custom logic here. Must be called appliance.sh if using bash tools
  provisioner "file" {
    sources     = ["../../appliances/zabbix"]
    destination = "/etc/one-appliance/service.d/"
  }
```

## User Inputs

[User Inputs](https://docs.opennebula.io/7.0/product/virtual_machines_operation/virtual_machine_definitions/vm_templates/#user-inputs) is an OpenNebula feature that allows the possibility to customize VMs on instantiation by asking for dynamic values in the VM Template. Appliances can be configured to accept these User Inputs as variables to customize the software installation or make special configurations. In this example, the file `appliances/zabbix/config.rb` contains the definition of the User Inputs that will be available in the Zabbix appliance:

```ruby
# frozen_string_literal: true

begin
   require '/etc/one-appliance/lib/helpers'
rescue LoadError
   require_relative '../lib/helpers'
end

ZABBIX_SERVER_CONF = "/etc/zabbix/zabbix_server.conf"
ZABBIX_NGINX_CONF = "/etc/zabbix/nginx.conf"

# These variables are not exposed to the user and only used during install
ONEAPP_ZABBIX_RELEASE_VERSION = env :ONEAPP_ZABBIX_RELEASE_VERSION, '7.0'

# Zabbix configuration parameters

# ------------------------------------------------------------------------------
# Postgres database parameters
# ------------------------------------------------------------------------------
#  ONEAPP_ZABBIX_DB_USER: User for the Zabbix database
#
#  ONEAPP_ZABBIX_DB_PASSWORD: Password for Zabbix database user
#
#  ONEAPP_ZABBIX_DB_NAME: Name for the Zabbix database
# ------------------------------------------------------------------------------
ONEAPP_ZABBIX_DB_USER = env :ONEAPP_ZABBIX_DB_USER, 'zabbix'
ONEAPP_ZABBIX_DB_PASSWORD = env :ONEAPP_ZABBIX_DB_PASSWORD, ''
ONEAPP_ZABBIX_DB_NAME = env :ONEAPP_ZABBIX_DB_NAME, 'zabbix'

# ------------------------------------------------------------------------------
# Zabbix configuration parameters
# ------------------------------------------------------------------------------
#  ONEAPP_ZABBIX_PORT: Listen port for Nginx configuration
#
#  ONEAPP_ZABBIX_SERVER_NAME: Server name for Nginx configuration
# ------------------------------------------------------------------------------
ONEAPP_ZABBIX_PORT = env :ONEAPP_ZABBIX_PORT, '8080'
ONEAPP_ZABBIX_SERVER_NAME = env :ONEAPP_ZABBIX_SERVER_NAME, 'example.com'
```

## Appliance Code

All the logic for the installation and configuration of the software is placed in `appliances/zabbix/main.rb`. This appliance implements the necessary steps to install Zabbix on Ubuntu 24.04 with Nginx following the [official Zabbix documentation](https://www.zabbix.com/download?zabbix=7.0&os_distribution=ubuntu&os_version=24.04&components=server_frontend_agent&db=pgsql&ws=nginx). The previously defined User Inputs are used in this script to configure the appliance with the parameters provided in the VM template.

```ruby
# frozen_string_literal: true

begin
   require '/etc/one-appliance/lib/helpers'
rescue LoadError
   require_relative '../lib/helpers'
end

require_relative 'config'

# Base module for OpenNebula services
module Service

   # Zabbix appliance implmentation
   module Zabbix

       extend self

       DEPENDS_ON    = []

       def install
           msg :info, 'Zabbix::install'
           install_repo
           install_zabbix
           msg :info, 'Installation completed successfully'
       end

       def configure
           msg :info, 'Zabbix::configure'
           update_zabbix_conf
           create_database
           start_zabbix
           msg :info, 'Configuration completed successfully'
       end

       def bootstrap
           msg :info, 'Zabbix::bootstrap'
       end
   end

   def install_repo
       # repository for Zabbix
       puts bash <<~SCRIPT
           wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb
           dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb
           apt-get update
       SCRIPT
   end

   def install_zabbix
       # installs Zabbix and dependencies
       puts bash "apt-get install -y zabbix-server-pgsql zabbix-frontend-php php8.3-pgsql zabbix-nginx-conf zabbix-sql-scripts zabbix-agent postgresql"
   end

   def create_database
       msg :info, 'Creating Zabbix database...'
       if database_exists?
           msg :info, 'Database already exists, continuing'
           return
       end

       unless !ONEAPP_ZABBIX_DB_PASSWORD.empty?
           raise "Error: ONEAPP_ZABBIX_DB_PASSWORD not defined"
       end

       msg :info, 'Configuring PostgreSQL for Zabbix database access...'

       pg_version = `ls /etc/postgresql/ 2>/dev/null | grep -E '^[0-9]+$' | sort -rV | head -n 1`.strip
       if pg_version.empty?
           raise "Error: Could not determine PostgreSQL version. Please set it manually."
       end
       pg_hba_conf_path = "/etc/postgresql/#{pg_version}/main/pg_hba.conf"

       # Backup pg_hba.conf
       puts bash "sudo cp #{pg_hba_conf_path} #{pg_hba_conf_path}.bak"

       puts bash <<~HBA_SCRIPT
           set -e

           MD5_ENTRY="local   #{ONEAPP_ZABBIX_DB_NAME}      #{ONEAPP_ZABBIX_DB_USER}          md5"

           if ! grep -qF "$MD5_ENTRY" #{pg_hba_conf_path}; then
               if grep -qE "^local\\s+#{ONEAPP_ZABBIX_DB_NAME}\\s+#{ONEAPP_ZABBIX_DB_USER}\\s+peer" #{pg_hba_conf_path}; then
                   sudo sed -i "s/^local\\s\\+#{ONEAPP_ZABBIX_DB_NAME}\\s\\+#{ONEAPP_ZABBIX_DB_USER}\\s\\+peer/$MD5_ENTRY/" #{pg_hba_conf_path}
                   echo "Replaced existing 'peer' entry for Zabbix with 'md5'."
               else
                   if grep -qE "^local\\s+all\\s+all\\s+peer" #{pg_hba_conf_path}; then
                       sudo awk -v insert="$MD5_ENTRY" '/^local\\s+all\\s+all\\s+peer/ && !inserted { print insert; inserted=1 } { print }' #{pg_hba_conf_path} > /tmp/pg_hba.conf.tmp && sudo mv /tmp/pg_hba.conf.tmp #{pg_hba_conf_path}
                       echo "Inserted new 'md5' entry before 'local all all peer'."
                   else
                       echo "$MD5_ENTRY" | sudo tee -a #{pg_hba_conf_path}
                       echo "Appended new 'md5' entry as a fallback."
                   fi
               fi
           else
               echo "'md5' entry for Zabbix already exists."
           fi
       HBA_SCRIPT

       msg :info, 'Restarting PostgreSQL service and waiting for it to be ready...'
       puts bash <<~RESTART_WAIT_SCRIPT
           sudo systemctl restart postgresql
           ATTEMPTS=0
           MAX_ATTEMPTS=30
           SLEEP_TIME=2 # seconds

           while [ $ATTEMPTS -lt $MAX_ATTEMPTS ]; do
               if sudo -u postgres pg_isready -q -h /var/run/postgresql -p 5432; then
                   echo "PostgreSQL is ready!"
                   break
               fi
               echo "Waiting for PostgreSQL to start... (Attempt $((ATTEMPTS+1)) of $MAX_ATTEMPTS)"
               sleep $SLEEP_TIME
               ATTEMPTS=$((ATTEMPTS+1))
           done

           if [ $ATTEMPTS -eq $MAX_ATTEMPTS ]; then
               echo "Error: PostgreSQL did not become ready in time." >&2
               exit 1
           fi
       RESTART_WAIT_SCRIPT

       puts bash <<~SCRIPT
           sudo -u postgres psql -c "CREATE USER #{ONEAPP_ZABBIX_DB_USER} WITH PASSWORD '#{ONEAPP_ZABBIX_DB_PASSWORD}';"
           sudo -u postgres createdb -O #{ONEAPP_ZABBIX_DB_USER} #{ONEAPP_ZABBIX_DB_NAME};


           zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u postgres PGPASSWORD='#{ONEAPP_ZABBIX_DB_PASSWORD}' psql -d #{ONEAPP_ZABBIX_DB_NAME} -U #{ONEAPP_ZABBIX_DB_USER}
       SCRIPT
       msg :info, 'Database created and initial schema imported'
   end

   def update_zabbix_conf
       msg :info, 'Updating zabbix_server.conf and nginx.conf files...'
       unless File.exist?("#{ZABBIX_SERVER_CONF}")
           raise "Error: Zabbix server configuration file not found at '#{ZABBIX_SERVER_CONF}'."
       end

       begin
           zabbix_conf_file = File.read("#{ZABBIX_SERVER_CONF}")
           nginx_conf_file = File.read("#{ZABBIX_NGINX_CONF}")

           zabbix_conf_file = zabbix_conf_file.gsub(/^(\s*)#?\s*(DBPassword=.*$)/, "\\1\\2'#{ONEAPP_ZABBIX_DB_PASSWORD}'")

           nginx_conf_file = nginx_conf_file.gsub(/^(\s*)#?\s*listen\s+\d+;/, "\\1listen #{ONEAPP_ZABBIX_PORT};")
           nginx_conf_file = nginx_conf_file.gsub(/^(\s*)#?\s*server_name\s+[^;]+;/, "\\1server_name #{ONEAPP_ZABBIX_SERVER_NAME};")

           File.write("#{ZABBIX_SERVER_CONF}", zabbix_conf_file)
           File.write("#{ZABBIX_NGINX_CONF}", nginx_conf_file)
           msg :info, 'Zabbix configuration files updated...'
       rescue => e
           raise "Error updating Zabbix server configuration file: #{e.message}"
       end
   end

   def start_zabbix
       msg :info, 'Starting and enabling Zabbix...'
       puts bash <<~SCRIPT
           systemctl restart zabbix-server zabbix-agent nginx php8.3-fpm
           systemctl enable zabbix-server zabbix-agent nginx php8.3-fpm
       SCRIPT
   end

   def database_exists?
       `sudo su postgres -c 'psql -l | grep zabbix | wc -l'`.strip.to_i > 0
   end
end
```

## Generating Image

It should be possible now to generate the qcow2 image for the Zabbix appliance. The appliance development process will require the user to ensure the image is built properly and use the local built image to run tests. In order to build the image, the Ubuntu 24.04 base image for the appliance should be built first, from `apps-code/one-apps`:

```bash
user@pc:~/marketplace-community$ cd apps-code/one-apps/
user@pc:~/marketplace-community/apps-code/one-apps$ sudo make ubuntu2404
packer/build.sh 'ubuntu' '2404' export/ubuntu2404.qcow2
null.null: output will be in this color.
qemu.ubuntu: output will be in this color.

==> qemu.ubuntu: Retrieving ISO
...
==> Wait completed after 4 minutes 7 seconds

==> Builds finished. The artifacts of successful builds are:
--> null.null: Did not export anything. This is the null builder
--> qemu.ubuntu: VM files in directory: build/ubuntu2404
--> qemu.ubuntu: VM files in directory: build/ubuntu2404
[INFO] Packer ubuntu2404 done
```

With the base image ready, it will be possible to build the Zabbix image from the `apps-code/community-marketplace`:

```bash
user@pc:~/marketplace-community/apps-code/community-apps$ sudo make zabbix
packer/build.sh 'zabbix' '' export/zabbix.qcow2
Warning: A checksum of 'none' was specified. Since ISO files are so big,
a checksum is highly recommended.

  on packer/zabbix/zabbix.pkr.hcl line 19:
  (source code not available)


null.null: output will be in this color.
qemu.zabbix: output will be in this color.

==> qemu.zabbix: Retrieving ISO
==> qemu.zabbix: Trying ../one-apps/export/ubuntu2404.qcow2
==> qemu.zabbix: Trying ../one-apps/export/ubuntu2404.qcow2
...
==> Wait completed after 2 minutes 11 seconds

==> Builds finished. The artifacts of successful builds are:
--> null.null: Did not export anything. This is the null builder
--> qemu.zabbix: VM files in directory: build/zabbix
--> qemu.zabbix: VM files in directory: build/zabbix
[INFO] Packer zabbix done
```

After the build process has finished, a file will be created in `apps-code/community-marketplace/export/zabbix.qcow2`. To create a new OpenNebula Image from this file, first it should be copied to the OpenNebula Frontend under `/var/tmp`, then the Image can be created in OpenNebula:

```bash
[user@one-fe ~]$ oneimage create -d 101 --name "Zabbix" --type OS --prefix vd --format qcow2 --path /var/tmp/zabbix.qcow2
ID: 283
[user@one-fe ~]$ oneimage list
  ID USER     GROUP    NAME    DATASTORE     SIZE TYPE PER STAT RVMS
 283 onepoc   oneadmin Zabbix  NFS image     4.9G OS    No rdy     0
```

{{< alert title="Note" color="success" >}}
The contributor does not need to generate and upload the image file, since this will be taken care of by the OpenNebula Team when reviewing and validating the appliance. This step will be useful during the appliance development process for testing it under a local OpenNebula environment.
{{< /alert >}}

## VM Template

In order to test the appliance, a VM template can be created with the defined user inputs in `appliances/zabbix/config.rb`.

```bash
[onepoc@nebulito ~]$ cat zabbix.tmpl
NAME="zabbix"
CONTEXT=[
  NETWORK="YES",
  ONEAPP_ZABBIX_DB_NAME="$ONEAPP_ZABBIX_DB_NAME",
  ONEAPP_ZABBIX_DB_PASSWORD="$ONEAPP_ZABBIX_DB_PASSWORD",
  ONEAPP_ZABBIX_DB_USER="$ONEAPP_ZABBIX_DB_USER",
  ONEAPP_ZABBIX_PORT="$ONEAPP_ZABBIX_PORT",
  ONEAPP_ZABBIX_SERVER_NAME="$ONEAPP_ZABBIX_SERVER_NAME",
  SSH_PUBLIC_KEY="$USER[SSH_PUBLIC_KEY]" ]
CPU="1"
DISK=[
  IMAGE="Zabbix",
  IMAGE_UNAME="onepoc" ]
GRAPHICS=[
  LISTEN="0.0.0.0",
  TYPE="VNC" ]
HYPERVISOR="kvm"
INPUTS_ORDER="ONEAPP_ZABBIX_DB_PASSWORD,ONEAPP_ZABBIX_DB_USER,ONEAPP_ZABBIX_DB_NAME,ONEAPP_ZABBIX_PORT,ONEAPP_ZABBIX_SERVER_NAME"
MEMORY="2048"
NIC=[
  NETWORK="local",
  NETWORK_ID="1",
  NETWORK_UID="2",
  NETWORK_UNAME="onepoc" ]
NIC_DEFAULT=[
  MODEL="virtio" ]
SCHED_REQUIREMENTS="HYPERVISOR=kvm"
USER_INPUTS=[
  ONEAPP_ZABBIX_DB_NAME="O|text|DB name| |zabbix",
  ONEAPP_ZABBIX_DB_PASSWORD="M|password|DB password| |",
  ONEAPP_ZABBIX_DB_USER="O|text|DB username| |zabbix",
  ONEAPP_ZABBIX_PORT="O|number|Nginx port| |8080",
  ONEAPP_ZABBIX_SERVER_NAME="O|text|Nginx server name| |example.com" ]
VCPU="2"
[onepoc@nebulito ~]$ onetemplate create zabbix.tmpl
ID: 148
```

It should be possible to instantiate the VM template, providing the needed user inputs:

```bash
[onepoc@nebulito ~]$ onetemplate instantiate 148
There are some parameters that require user input. Use the string <<EDITOR>> to launch an editor (e.g. for multi-line inputs)
  * (ONEAPP_ZABBIX_DB_NAME) DB name
    Press enter for default (zabbix).
  * (ONEAPP_ZABBIX_DB_PASSWORD) DB password
    Password:
  * (ONEAPP_ZABBIX_DB_USER) DB username
    Press enter for default (zabbix).
  * (ONEAPP_ZABBIX_PORT) Nginx port
    Press enter for default (8080). Integer:
  * (ONEAPP_ZABBIX_SERVER_NAME) Nginx server name
    Press enter for default (example.com).
VM ID: 259
```

The user inputs are also available when instantiating the template from Sunstone, as it can be seen below.

![Zabbix appliance working directory](/images/community-marketplace/community_marketplace_sunstone_user_inputs.png)

After the VM has booted and the contextualization scripts executed, the Zabbix server should be available from a web browser in the VM's IP address:

![Zabbix appliance working directory](/images/community-marketplace/community_marketplace_zabbix_install.png)

## Tests

Tests are required for contributing to the Community Marketplace, so a basic test file has been implemented for the Zabbix appliance. These tests decide wether the installation steps were successful or not by checking the status of zabbix-server and postgresql services status among other checks:

```ruby
require_relative '../../../lib/community/app_handler' # Loads the library to handle VM creation and destruction


# You can put any title you want, this will be where you group your tests
describe 'Appliance Certification' do
   # This is a library that takes care of creating and destroying the VM for you
   # The VM is instantiated with your APP_CONTEXT_PARAMS passed
   # "onetemplate instantiate base --context SSH_PUBLIC_KEY=\\\"\\$USER[SSH_PUBLIC_KEY]\\\",NETWORK=\"YES\",ONEAPP_DB_NAME=\"dbname\",ONEAPP_DB_USER=\"username\",ONEAPP_DB_PASSWORD=\"upass\",ONEAPP_DB_ROOT_PASSWORD=\"arpass\" --disk service_example"
   include_context('vm_handler')


   # if the psql command exists in $PATH, we can assume it is installed
   it 'postgresql is installed' do
       cmd = 'which psql'


       # use @info[:vm] to test the VM running the app
       @info[:vm].ssh(cmd).expect_success
   end


   # if the zabbix_server command exists in $PATH, we can assume it is installed
   it 'zabbix_server is installed' do
       cmd = 'which zabbix_server'


       # use @info[:vm] to test the VM running the app
       @info[:vm].ssh(cmd).expect_success
   end


   # Use the systemd cli to verify that postgresql is up and runnig. will fail if it takes more than 30 seconds to run
   it 'postgresql service is running' do
       cmd = 'systemctl is-active postgresql'
       start_time = Time.now
       timeout = 30


       loop do
           result = @info[:vm].ssh(cmd)
           break if result.success?


           if Time.now - start_time > timeout
               raise "MySQL service did not become active within #{timeout} seconds"
           end


           sleep 1
       end
   end


   # Use the systemd cli to verify that zabbix-server is up and runnig. will fail if it takes more than 60 seconds to run
   it 'zabbix-server service is running' do
       cmd = 'systemctl is-active postgresql'
       start_time = Time.now
       timeout = 60


       loop do
           result = @info[:vm].ssh(cmd)
           break if result.success?


           if Time.now - start_time > timeout
               raise "Zabbix-server service did not become active within #{timeout} seconds"
           end


           sleep 1
       end
   end


   # Check if the service framework from one-apps reports that the app is ready
   it 'checks oneapps motd' do
       cmd = 'cat /etc/motd'
       timeout_seconds = 60
       retry_interval_seconds = 5


       begin
           Timeout.timeout(timeout_seconds) do
               loop do
                   execution = @info[:vm].ssh(cmd)


                   if execution.exitstatus == 0 && execution.stdout.include?('All set and ready to serve')
                       expect(execution.exitstatus).to eq(0) # Assert exit status
                       expect(execution.stdout).to include('All set and ready to serve')
                       break
                   else
                       sleep(retry_interval_seconds)
                   end
               end
           end
       rescue Timeout::Error
           fail "Timeout after #{timeout_seconds} seconds: MOTD did not contain 'All set and ready to serve'. Appliance not configured."
       rescue StandardError => e
           fail "An error occurred during MOTD check: #{e.message}"
       end
   end


   # use mysql CLI to verify that the database has been created
   it 'database exists' do
       db = APP_CONTEXT_PARAMS[:ZABBIX_DB_NAME]


       cmd = "sudo su postgres -c 'psql -l | grep #{db} | wc -l'"


       execution = @info[:vm].ssh(cmd)
       expect(execution.stdout.strip.to_i).to eq(1)
   end
end
```

In order to validate these tests, they can be executed locally if an OpenNebula local installation is available. The `metadata.yaml` file must be populated with the correct appliance parameters and template attributes:

```yaml
---
:app:
  :name: zabbix # name used to make the app with the makefile
  :type: service # there are service (complex apps) and distro (base apps)
  :os:
    :type: linux # linux, freebsd or windows
    :base: ubuntu2404 # distro where the app runs on
  :hypervisor: KVM
  :context: # which context params are used to control the app
    :prefixed: true # params are prefixed with ONEAPP_
    :params:
      :ZABBIX_DB_USER: 'dbusername'
      :ZABBIX_DB_PASSWORD: 'db.passw0rd'
      :ZABBIX_DB_NAME: 'dbname'
      :ZABBIX_PORT: '8080'
      :ZABBIX_SERVER_NAME: 'server_name'

:one:
  # reference template for running the virtual appliance.
  # Must be diskless, with ssh access and accessible by  the frontend
  :template: # how the VM template is expected to be on OpenNebula
    NAME: base
    TEMPLATE:
      ARCH: x86_64
      CONTEXT:
        NETWORK: 'YES'
        SSH_PUBLIC_KEY: "$USER[SSH_PUBLIC_KEY]"
      CPU: '0.1'
      CPU_MODEL:
        MODEL: host-passthrough
      GRAPHICS:
        LISTEN: 0.0.0.0
        TYPE: vnc
      MEMORY: '1024'
      NIC:
        NETWORK: service
      NIC_DEFAULT:
        MODEL: virtio
  :datastore_name: default # target datatore to import the one-apps produced image
  :timeout: '90' # timeout for XMLRPC calls

:infra:
  :disk_format: qcow2 # oneapps built image disk format
  :apps_path: /opt/one-apps/export # directory where one-apps exports the appliances to
```

{{< alert title="Note" color="success" >}}
The `:infra` section must not be edited, since those parameters are going to be used by OpenNebula to run the tests in their infrastructure.
{{< /alert >}}

It is possible to run the tests as the oneadmin user, from the lib/community directory, using the command `./app_readiness.rb zabbix`:

```bash
oneadmin@PC06:~/marketplace-community/lib/community$ ./app_readiness.rb zabbix

Appliance Certification
  postgresql is installed
  zabbix_server is installed
  postgresql service is running
  zabbix-server service is running
  checks oneapps motd
  database exists

Finished in 1 minute 55.35 seconds (files took 1.28 seconds to load)
6 examples, 0 failures
```

## Metadata

After the appliance code is ready and the tests have been validated, the appliance should be ready to upload to the Community Marketplace. Two metadata files need to be updated before contributing:

- metadata.yaml. Has all the needed information to run the tests once the pull request has been created. It is important to check locally that the context parameters and VM template attributes are valid before contributing.
- UUID.yaml. This file contains all the information about the appliance including the version, publisher and template options amongst other things. The `publisher_email` is specially important since it's the address that will be used for notifying about the status of the contribution process. In this Zabbix appliance, the file has been created:
```yaml
---
name: Zabbix
version: 7.0-LTS
one-apps_version: 7.0.0-0
publisher: OpenNebula Systems
publisher_email: engineering@opennebula.io
description: |-
  Appliance with preinstalled [Zabbix](https://www.zabbix.com/documentation/7.0/en/manual).

  Installs Zabbix 7.0 LTS from official repositories. The following configuration parameters are available:

  - ONEAPP_ZABBIX_DB_USER: User for the Zabbix database
  - ONEAPP_ZABBIX_DB_PASSWORD: Password for Zabbix database user
  - ONEAPP_ZABBIX_DB_NAME: Name for the Zabbix database
  - ONEAPP_ZABBIX_PORT: Listen port for Nginx configuration
  - ONEAPP_ZABBIX_SERVER_NAME: Server name for Nginx configuration
short_description: Appliance with preinstalled Zabbix for KVM hosts
tags:
- zabbix
- ubuntu
- service
format: qcow2
creation_time: 1752141600
os-id: Ubuntu
os-release: 24.04 LTS
os-arch: x86_64
hypervisor: KVM
opennebula_version: 6.10, 7.0
opennebula_template:
  context:
    network: 'YES'
    oneapp_zabbix_db_user: "$ONEAPP_ZABBIX_DB_USER"
    oneapp_zabbix_db_password: "$ONEAPP_ZABBIX_DB_PASSWORD"
    oneapp_zabbix_db_name: "$ONEAPP_ZABBIX_DB_NAME"
    oneapp_zabbix_port: "$ONEAPP_ZABBIX_PORT"
    oneapp_zabbix_server_name: "$ONEAPP_ZABBIX_SERVER_NAME"
    ssh_public_key: "$USER[SSH_PUBLIC_KEY]"
  cpu: '1'
  graphics:
    listen: 0.0.0.0
    type: vnc
  inputs_order: >-
    ONEAPP_ZABBIX_DB_USER, ONEAPP_ZABBIX_DB_PASSWORD, ONEAPP_ZABBIX_DB_NAME, ONEAPP_ZABBIX_PORT, ONEAPP_ZABBIX_SERVER_NAME
  memory: '768'
  os:
    arch: x86_64
  user_inputs:
    oneapp_zabbix_db_user: M|text|DB username| |zabbix
    oneapp_zabbix_db_password: M|password|DB password| |
    oneapp_zabbix_db_name: M|text|DB name| |zabbix
    oneapp_zabbix_port: M|number|Nginx listen port| |8080
    oneapp_zabbix_server_name: M|text|Nginx server_name| |example.com
logo: zabbix.png
images:
- name: zabbix
  url: >-
    https://d38nm155miqkyg.cloudfront.net/service_Lithops-6.10.0-3-20250513.qcow2
  type: OS
  dev_prefix: vd
  driver: qcow2
  size: 5242880000
  checksum:
    md5: 5a2836f94361200f4a74e36cf56b7429
    sha256: 90de590ea070c33809924ad85bfab59e299a50328a2c19c89bb937569d8e65d2
```

## Pull Request


![Zabbix appliance working directory](/images/community-marketplace/community_marketplace_pull_request.png)