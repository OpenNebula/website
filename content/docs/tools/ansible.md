---
title: "Ansible"
date: "2025/02/17"
description:
categories:
pageintoc: "267"
tags:
weight: "3"
---

<a id="ansible"></a>

<!--# Ansible -->

OpenNebula Ansible modules allow managing common OpenNebula resources, e.g. VMs, images or hosts, using Ansible playbooks. In the latest Ansible version OpenNebula modules are part of the collection [community.general](https://galaxy.ansible.com/community/general). Formerly, they were distributed together with Ansible main package.

For the module usage, please follow the official Ansible documentation:

> * [one_host.py](https://docs.ansible.com/ansible/latest/collections/community/general/one_host_module.html)
> * [one_image.py](https://docs.ansible.com/ansible/latest/collections/community/general/one_image_module.html)
> * [one_service.py](https://docs.ansible.com/ansible/latest/collections/community/general/one_service_module.html)
> * [one_vm.py](https://docs.ansible.com/ansible/latest/collections/community/general/one_vm_module.html)
> * [one_template.py](https://docs.ansible.com/ansible/latest/collections/community/general/one_template_module.html)

## Dependencies

For OpenNebula Ansible modules [Python bindings PYONE]({{% relref "../integration_framework/integration_references/system_interfaces/python#python" %}}) are necessary, for `one_image.py` also legacy [Python OCA](https://github.com/python-oca/python-oca)
