---
title: ""
type: docs
#description: "The OpenNebula Documentation"
weight: "1"
main_menu: true
hide_feedback: true
no_list: true
breadcrumb_disable: true
---

# Welcome to OpenNebula {{< version >}}

<p></p>

[OpenNebula](https://opennebula.io) is a powerful, but easy-to-use open source platform for enterprise, private, hybrid or edge cloud infrastructure. OpenNebula focuses on simplicity, flexibility, scalability and vendor independence.

This site contains the OpenNebula technical documentation. For additional resources, see the [OpenNebula Community Forum](https://forum.opennebula.io/) and [blog](https://opennebula.io/blog/).

To access additional material including white papers, guides and screencasts, see [Official Guides](https://opennebula.io/docs/).

<!-- temporary inline styling until we define cards for manual use -->
<style>
.td-card {
  display: flex !important;
  flex: 0 2 45% !important;
}
.card-text {
  margin-left: 1rem !important;
}
.card-group {
  margin-bottom: 0rem !important;
}
.me-4 {
    margin-right: 1rem !important;
}
</style>

<div class="card-columns">
<div class="entry">
{{< cardpane >}}
  {{< card header="[Getting Started](/getting_started)" >}}
  Gain a high-level view of OpenNebula, and easily deploy a cloud for evaluation and testing.
  {{< /card >}}
  {{< card header="[Product](/product)" >}}
  Follow guides and consult references to expand, enhance, secure and monitor your OpenNebula cloud.
  {{< /card >}}
{{< /cardpane >}}

{{< cardpane >}}
  {{< card header="[Software](/software)" >}}
  Release notes, upgrade guides, available installation methods, and migration tools.
  {{< /card >}}
  {{< card header="[Integrations](/integrations)" >}}
  Extend functionalities for orchestration, storage, backup, billing, and application management.
  {{< /card >}}
{{< /cardpane >}}
</div>
</div>
