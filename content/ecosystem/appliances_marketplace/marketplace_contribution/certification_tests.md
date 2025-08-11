---
title: "Appliances Certification Tests"
type: docs
linkTitle: "Appliances Certification Tests"
description: "The section outlines the process for certifying appliances for OpenNebula."
weight: 3
---

# Scope

## What is the objective of the Certification Tests?
Certification Tests intend to provide a way of certifying that a contributor submitted appliance is working as intended according to the features it provides while still being compatible at Operating System level with the basic contextualization features.

## Who is the target audience?
Certification Tests must be developed by contributors, looking to create an appliance for OpenNebula end users. This document should help during the contribution process.

## What is the objective of the document?
This document intends to provide a guide regarding how to develop and run tests. The tests can be divided into two sections

* **App Specific tests:** The appliance features must be tested. For this we provide some example tests and libraries to aid in the process of developing these. The test suite is built around the usage of [rspec](https://rspec.info/).  
* **General Context tests:** The appliance features are built on top of the [contextualization service](https://github.com/OpenNebula/one-apps/wiki/linux_feature). While the purpose of the appliance is to provide its specific features, compliance with the baseline context features must be guaranteed. 

# General Contextualization tests

To keep appliances provided via Marketplace fully operational on any supported version of the OpenNebula and platforms there are tests performed on a regular basis on the OpenNebula Systems Company’s internal infrastructure. To integrate the VM guests with the OpenNebula services a set of contextualization packages for different operating systems are provided. The OpenNebula contextualization process allows to automatically do the following:

* Configure guest networking and hostname settings.  
* Set up user credentials for seamless VM access.  
* Define the system timezone.  
* Resize disk partitions as needed.  
* Execute custom actions during boot.

All appliances available via Marketplace have OpenNebula contextualization packages installed. To keep the user experience consistent all contributors’ appliances must have OpenNebula contextualization packages installed too.

The tools from the [OneApps project](https://github.com/OpenNebula/one-apps) can be used to build an image for the contributing appliances.

These appliances need to be validated against contextualization tests as well as a set of tests specific for that particular appliance (such tests are provided by the appliance’s contributor). The appliance  contributor’s responsibility is to provide the tests which are specific for the contributing appliance only. The contributing appliance will be validated against the OpenNebula contextualization tests by the OpenNebula team. That means there is no need for the contributor to test the appliance against such OpenNebula contextualization tests.

# Specific Appliance tests

The tests are built around [rspec](https://rspec.info/). You describe certain tests, called examples, and define conditions where the test fails or succeeds based on expectations. The tests are assumed to be executed in the OpenNebula frontend. This means the opennebula **systemd** unit runs in the same host where the tests are executed.

We are going to showcase the contribution process with a database appliance. For a more visual showcase please refer to this [webinar](https://www.youtube.com/watch?v=UstX_KyOi0k).

## App structure

The application logic resides at `appliances/<appliance>` folder in the Community Marketplace GitHub [repository](https://github.com/OpenNebula/marketplace-community). Within that directory resides also the appliance metadata and the tests directory.

```
appliances/example/
├── CHANGELOG.md
├── README.md
├── UUID.yaml
├── appliance.sh
├── context.yaml # generated after the tests are executed based on metadata
├── metadata.yaml # appliance metadata used in testing
├── tests
│   └─ 00-example_basic.rb
└── tests.yaml # list of test files to be executed
```

The file `00-example_basic.rb` contains some tests that verify the mysql database within the Virtual Machine.

## Example tests

The appliance provides the following custom contextualization parameters

| CONTEXT Parameter | Description |
| :---- | :---- |
| `ONEAPP_DB_NAME` | Database name |
| `ONEAPP_DB_USER` | Database service user |
| `ONEAPP_DB_PASSWORD` |Database service password |
| `ONEAPP_DB_ROOT_PASSWORD` | Database password for root |

The tests basically verify that using these parameters are working as intended.

In this case 6 tests are performed using *rspec it* blocks

* mysql is installed.  
  * This verifies that the app built correctly with the required software  
  * The app could have successfully built, but failed to perform some install tasks  
* mysql is running  
* one-apps service framework reports the app as ready  
* every time the VM containing the app starts, the service within, in this case mysql, will be reconfigured according to what is stated in the CONTEXT section.  
*  one-apps will trigger the configuration and if everything goes well, it will report ready

To run the tests one needs to have the infrastructure with a proper software environment deployed. That can be a single VM with nested virtualization enabled, OpenNebula software installed, enough CPU, MEMORY and DISK resources as well as the network properly configured (i.e. the VM running in such test environment has to have an access to the Internet to download required packages).

The [Basic OpenNebula Deployment](basic_deployment.md) section contains particular steps required to build the basic OpenNebula environment.

Clone community-marketplace GH repository:

```
git clone --recurse-submodules https://github.com/OpenNebula/marketplace-community.git
```

Before running the tests make sure you have rspec gem installed 

```
gem info rspec
```

as well as `opennebula` packages. Otherwise refer to the guide [Appliances Development](appliances_development.md).

The tests assume certain conditions to be met on the host running OpenNebula:

* an existence of a virtual network where the test VMs will run  
* an existence of a VM Template with  
  * abovementioned virtual network,  
  * no disk (the disk will be passed dynamically as your app is built),  
  * SSH\_PUBLIC\_KEY="$USER\[SSH\_PUBLIC\_KEY\]”  
* an existence of the `oneadmin` user since the tests will be run by it  
* a capability to reach these VMs by the `oneadmin` user (you have to set the `SSH_PUBLIC_KEY` on the user template for that)  
* an existence of a hypervisor node where the test VMs are expected to be run.

If you used the `miniONE` tool to create an OpenNebula environment then the virtual network should already exist. One can check that from the CLI with help of the following command:

```
onevnet list
```

The `metadata.yaml` file within \[:one:\]\[:template:\]-\> NIC \-\> NETWORK tags and attributes mentions vnet name (by default it is called ‘service’). So it might be needed either to change vnet name in the `metadata.yaml` file or rename the vnet (preferable) with help of the command as below:

```
onevnet rename <vnet_id> service
```

One of the possible ways to create a VM template is to export it from OpenNebula Public Marketplace:

```
onemarketapp export <marketapp_id> <appliance_template_name> -d <datastore_id>
```

where 

* `<marketapp_id>` is the ID of the appliance in the marketplace,  
* `<appliance_template_name>` is the VM template name and   
* `<datastore_id>` is the ID of the datastore where the exporting from the marketplace appliance image needs to be stored.

 For example,

```
onemarketapp export 81 base -d 1
```

The VM template name which needs to be used during the `app_readiness.rb` script execution is specified in the `metadata.yml` file in the value for the \[:one:\]\[:template:\] \-\> NAME attribute.

Do not forget to align the VM template attributes and values according to the one specified in the appliance `metadata.yaml` file (`CPU`, `MEMORY`, `NETWORK`, remove the whole `DISK` attribute, etc).

Since the tests are going to be executed inside the running VM there is a need to have a hypervisor (HV) node capable of having such a VM running.

The execution of the following command should help you to understand if there is such HV node:

```
onehost list
```

Before running the tests it needs to do the following:

1) copy the `example.qcow2` file to one of the dirs specified in `SAFE_DIRS` attribute of the datastore where the image is going to be registered

```
cp ~/marketplace-community/apps-code/community-apps/export/example.qcow2 /var/tmp/
```

2) make the changes in the `metadata.yaml` file:

```
diff ../../example/metadata.yaml{,.orig}
43c43
<   :apps_path: /var/tmp # directory where one-apps exports the appliances to
---
>   :apps_path: /opt/one-apps/export # directory where one-apps exports the appliances to
```

3) define `IMAGES_URL` variable pointing to the same location (note the required trailing slash):

```
export IMAGES_URL="/var/tmp/"
```

To run the tests, go to the directory `~/marketplace-community/lib/community/` and then execute the `./app_readiness.rb <app_name> <app_image_name>`, as follows:

```
./app_readiness.rb example example.qcow2

Appliance Certification
  mysql is installed
  mysql service is running
"\n" +
"    ___   _ __    ___\n" +
"   / _ \\ | '_ \\  / _ \\   OpenNebula Service Appliance\n" +
"  | (_) || | | ||  __/\n" +
"   \\___/ |_| |_| \\___|\n" +
"\n" +
" All set and ready to serve 8)\n" +
"\n"
  check one-apps motd
  can connect as root with defined password
  database exists
  can connect as user with defined password

Finished in 1 minute 10.07 seconds (files took 0.20889 seconds to load)
6 examples, 0 failures
```

Only the tests defined at `tests.yaml` will be executed. The `example` appliance has them defined as below:
```
---
- '00-example_basic.rb'
```
With this you can define multiple test files to verify independent workflows and also test them separately.

## **Creating rspec example groups from scratch**

In order to develop your Certification Tests test, you will need to create your example group(s).

Taking a look at the file `00-example_basic.rb` we have the group `Appliance Certification` with 6 examples. Each example is an `it` block. Within the blocks there is some regular code and some code that **checks expectations**. An example of this special code is

```
expect(execution.exitstatus).to eq(0)
expect(execution.stdout).to include('All set and ready to serve')
```

The test in this case succeeds, given that the command runs without errors and its output contains a string. Both are required to pass the test.

Here is an example that does nothing useful, yet still runs

```
# /tmp/new_app_test.rb file
describe 'Useless test' do
    it 'Checks running state' do
        running = true
        expect(running).to be(true)
    end

    it 'Checks state' do
        status = 'running'
        expect(status).to eql('amazing') # will fail
    end
end
```

If you run this with `rspec -f d /tmp/new_app_test.rb` you'll get

```
Useless test
  Checks running state
  Checks state (FAILED - 1)

Failures:

  1) Useless test Checks state
     Failure/Error: expect(status).to eql('amazing')

       expected: "amazing"
            got: "running"

       (compared using eql?)
     # /tmp/new_app_test.rb:9:in `block (2 levels) in <top (required)>'

Finished in 0.01369 seconds (files took 0.09474 seconds to load)
2 examples, 1 failure

Failed examples:

rspec /tmp/new_app_test.rb:7 # Useless test Checks state
```

Now you need to make your tests useful. For this we provide some libraries to aid you. If you notice, in the mysql test file there are some calls that reference remote command execution in VMs. However we never create a VM in this code. This file uses the `app_handler.rb` library, which takes care of this. You can use this library to abstract from the complexity of creating and destroying a VM with custom context parameters.

To use it you need to do the following on the rspec file at `appliances/<appliance>/tests/<rspec_file>.rb`

* load the library with `require_relative ../../../lib/community/app_handler`
* load the library example group within your example group with `include_context('vm_handler')`

Afterwards the VM instance will be stored in the variable @info\[:vm\]. You can execute commands in there with the ssh instance method. The execution will return as an object where you can inspect parameters like the `existstatus`, `stderr` and `stdout`.

For an in-depth look at what you can do with the VM, please take a look at the file `lib/community/clitester/VM.rb`. This class abstracts lots of operations performed to a VM via CLI.

As it was stated above these tests assume certain conditions on the host running OpenNebula:

* an existence of a virtual network where the test VMs will run
* an existence of a VM Template with
  * a virtual network with proper name,
  * no disk (the disk will be passed dynamically as your app is built),  
  * `SSH_PUBLIC_KEY="$USER[SSH_PUBLIC_KEY]”` 
* an existence of the `oneadmin` user since the tests will be run by it  
* a capability to reach these VMs by the `oneadmin` user (you have to set the `SSH_PUBLIC_KEY` on the user template for that)  
* an existence of a hypervisor node where the test VMs are expected to be run.

You can use [one-deploy](https://github.com/OpenNebula/one-deploy) tool to quickly create a compatible test scenario. A simple node containing both the frontend and a kvm node will do. An inventory file is provided as a reference at `lib/community/ansible/inventory.yaml`.

Lastly you have to define a `metadata.yaml` file. This describes the appliance, showcasing information like the `CONTEXT` attributes used to control the App and the Linux distro used.

```
---
:app:
  :name: example # name used to make the app with the makefile
  :type: service # there are service (complex apps) and distro (base apps)
  :os:
    :type: linux # linux, freebsd or windows
    :base: alma8 # distro where the app runs on
  :hypervisor: KVM
  :context: # which context params are used to control the app
    :prefixed: true # params are prefixed with ONEAPP_ on the appliance logic ex. ONEAPP_DB_NAME
    :params:
      :DB_NAME: 'dbname'
      :DB_USER: 'username'
      :DB_PASSWORD: 'upass'
      :DB_ROOT_PASSWORD: 'arpass'

:one:
  :datastore_name: default # target datatore to import the one-apps produced image
  :timeout: '90' # timeout for XMLRPC calls

:infra:
  :disk_format: qcow2 # one-apps built image disk format
  :apps_path: /opt/one-apps/export # directory where one-apps exports the appliances to
```

After executing the tests, the `context.yaml` file is generated. This file should be included in the Pull Request as well. We will use it to pass the **context** tests in our infrastructure.

The table below contains a set of examples of tests for our OneKE appliance. Please, keep in mind that these tests are more advanced, and may include additional configurations that should be covered by the support library.

| Name&nbsp;of&nbsp;the&nbsp;test | Description of the test |
| ----- | ----- |
| [Cilium](https://github.com/OpenNebula/one-apps/blob/master/appliances/OneKE/cilium_spec.rb) | The script handles the configuration of Cilium (a networking and security solution for Kubernetes), specifically the definition of IP address ranges for load balancing and performs the checks to validate that configuration. |
| [Cleaner](https://github.com/OpenNebula/one-apps/blob/master/appliances/OneKE/cleaner_spec.rb) | the script returns a list of invalid nodes which need to be removed |
| [Metallib](https://github.com/OpenNebula/one-apps/blob/master/appliances/OneKE/metallb_spec.rb) | the script covers the validation of various use cases related to IP addresses range |
| [OneGate](https://github.com/OpenNebula/one-apps/blob/master/appliances/OneKE/onegate_spec.rb) | the script performs the checks related to assigned VMs roles and IP addresses |
