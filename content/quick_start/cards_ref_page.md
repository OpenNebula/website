---
title: "Cards Test Reference"
date: "2025-02-17"
description: "Hidden page, quick ref. for relative links in cards"
toc_hide: true
categories:
hide_feedback: true
no_list: true
pageintoc: "1"
tags:
weight: "1"
---

Reference for including intra-site links in cards.

For relative links:

   - In HTML, the link must be one level above reality, e.g. from this page `understand_opennebula/opennebula_concepts` becomes `../understand_opennebula/opennebula_concepts`. Otherwise Hugo renders the links relative to this page, i.e. `cards_test_page/understand_opennebula/opennebula_concepts`.
   - In Markdown, relative links work with the `relref` shortcode.

Card pane, HTML, format:

```go-html-template
{{/*< cardpane */>}}
```

{{< cardpane >}}
   {{< card header="OpenNebula concepts, features and components" >}}
         <inl>
            <a href="../understand_opennebula/opennebula_concepts">OpenNebula Concepts</a>
         </inl>
         <inl>
            <a href="../understand_opennebula/opennebula_concepts/key_features">Key Features</a>
         </inl>
   {{< /card >}}
   <p></p>
   {{< card header="Pathway to designing an OpenNebula cloud" >}}
      <inl>
         <a href="../understand_opennebula/cloud_architecture_and_design/cloud_architecture_design">Cloud Architecture Design</a>
      </inl>
      <inl>
         <a href="../understand_opennebula/cloud_architecture_and_design/edge_cloud_reference_architecture">Edge Cloud Architecture</a>
      </inl>
      <inl>
         <a href="../understand_opennebula/cloud_architecture_and_design/open_cloud_reference_architecture">Open Cloud Architecture</a>
      </inl>
   {{< /card >}}
{{< /cardpane >}}

Card pane, Markdown, format:

```go-html-template
{{/*% cardpane %*/}}
```

{{% cardpane %}}
   {{% card header="OpenNebula concepts, features and components" %}}
- [OpenNebula Concepts]({{% relref "understand_opennebula/opennebula_concepts" %}})
- [Key Features]({{% relref "understand_opennebula/opennebula_concepts/key_features" %}})
   {{% /card %}}

   {{% card header="Pathway to designing an OpenNebula cloud" %}}

[Cloud Arch. Design]({{% relref "understand_opennebula/cloud_architecture_and_design/cloud_architecture_design" %}})

[Edge Cloud Arch.]({{% relref "understand_opennebula/cloud_architecture_and_design/edge_cloud_reference_architecture" %}})

   {{% /card %}}
{{% /cardpane %}}
