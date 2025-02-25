---
title: "Grafana Visualization"
date: "2025/02/17"
description:
categories:
pageintoc: "130"
tags:
weight: "3"
---

<a id="monitor-alert-grafana"></a>

<!--# Grafana Visualization -->

## Requirements

This guide assumes you already have a up and running Grafana service. If you do not already have Grafana installed, refer to the following guides:

> - [Download and Installation](https://grafana.com/grafana/download).
> - [Add a new Prometheus Data sources](https://grafana.com/blog/2022/01/26/video-how-to-set-up-a-prometheus-data-source-in-grafana/).

{{< alert title="Note" color="success" >}}
Prometheus is listening on the standard port (9090) as described in the installation guide.{{< /alert >}} 

## Grafana Dashboards

We provide three dashboard templates that can be customized to your needs:

  - Dashboard to visualize Virtual Machine information: `/usr/share/one/grafana/dashboards/vms.json`.
  - Dashboard to visualize Host information: `/usr/share/one/grafana/dashboards/hosts.json`.
  - Dashboard to visualize the overall status of the OpenNebula cloud: `/usr/share/one/grafana/dashboards/opennebula.json`.

You can easily import these dashboards by copying the contents of these files in the Dashboards > + Import form.

The Virtual Machine and Host dashboards are by default indexed by ID but it can easily changed in the Settings > Variables dialog to use one_vm_name and one_host_name, respectively.

![grafana-dashboard](/images/grafana-dashboard.png)

## Grafana Provisioning

Grafana supports provisioning which can be used to automatically reconfigure Grafana instances
in shell scripts or automation engines like ansible.

In case of OpenNebula you can use it to, for instance, configure datasources and dashboards:

```default
# mkdir -p /etc/grafana/provisioning/datasources/
# cat >/etc/grafana/provisioning/datasources/prometheus.yml <<'EOF'
apiVersion: 1
datasources:
- name: prometheus
  type: prometheus
  access: proxy
  url: http://localhost:9090
  isDefault: true
  editable: false
EOF
```

{{< alert title="Important" color="success" >}}
In the case that your Grafana instance is running alongside Prometheus on the same OpenNebula server, then the **http://localhost:9090** above, can be accessed with ssh tunneling:

```default
$ ssh -L 9090:localhost:9090 user@opennebula-server-running-prometheus
```

Otherwise, provide the FQDN or IP address and make sure that you can access the Prometheus instance from your web browser.{{< /alert >}}  

```default
# mkdir -p /etc/grafana/provisioning/dashboards/
# cat >/etc/grafana/provisioning/dashboards/opennebula.yml <<'EOF'
apiVersion: 1
providers:
- name: opennebula
  type: file
  folder: ONE
  options: { path: /usr/share/one/grafana/dashboards/ }
EOF
```

```default
# systemctl restart grafana-server.service
```

After the grafana-server.service restarts you should be able to connect and verify that the `prometheus` datasource
is operational and the OpenNebula dashboards show live data.

Please refer to the official documentation to learn more about
[Grafana provisioning](https://grafana.com/docs/grafana/latest/administration/provisioning/).
