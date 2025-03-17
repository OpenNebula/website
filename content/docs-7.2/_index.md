---
title: "OpenNebula Development Version Documentation"
type: docs
weight: 1
---

This is a test of versioning for the documentation.

The Docsy "Versions" drop-down menu can link to different versions of the docs.

However, the Hugo static site builder does not support proper separation between versions, and thus:

- Searches span all sections
- Categories and tags are shared across all versions
- Relative links are relative to the whole site, not to the version root, so when creating a new version from an existing one all links need to be adapted (or all links should be converted to relative links, i.e. linking by tags should be disallowed on the site)

TODO:

Try workarounds misusing some of Hugo's features such as language versions and environments.
