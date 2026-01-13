---
title: "HuggingFace Hub Marketplace"
linkTitle: "HF Hub"
date: "2025-02-19"
description:
categories:
pageintoc: "188"
tags:
weight: "4"
---

<a id="market-hfhub"></a>

<!--# HuggingFace Hub Marketplace -->

The HuggingFace Hub Marketplace (HFHUB) provides a metadata-rich catalog of AI models from the [Hugging Face Hub](https://huggingface.co/), enabling users to discover, import, and deploy AI models on OpenNebula clusters. The marketplace stores only URIs (`hf://model_id`) and metadata without downloading artifacts at index time.

{{< alert title="Note" color="success" >}}
The OpenNebula Front-end needs access to the Internet to use the HuggingFace Hub Marketplace. For gated models, a HuggingFace token must be configured in the oneadmin environment.{{< /alert >}}

## Overview

The HFHUB Marketplace enables:

- **Model Discovery**: Browse and search AI models from HuggingFace with rich metadata (task, license, downloads, etc.)
- **Metadata Catalog**: Lightweight catalog storing only model metadata and URIs, not actual model files
- **On-Demand Import**: Models are downloaded only when imported to a datastore
- **Certified Models**: Support for OpenNebula's curated model collections from the official OpenNebula organization
- **Flexible Indexing**: Index from public models, specific organizations, or curated collections
- **Multi-Source Support**: Index from multiple organizations or collections simultaneously with automatic deduplication

## Requirements

- **Network**: Outbound HTTPS access to `https://huggingface.co` (port 443)
- **Python**: Python 3.9+ (stdlib + `requests` library - available as system package `python3-requests`)
- **Authentication** (optional): `HUGGING_FACE_HUB_TOKEN` environment variable for gated models
- **QCOW2 imports** (optional): `fuse2fs` package and sudoers configuration (see [QCOW2 Format Prerequisites](#qcow2-format-prerequisites))

## Configuration

### oned.conf Configuration

Add `hfhub` to `MARKET_MAD`:

```ruby
MARKET_MAD = [
    EXECUTABLE = "one_market",
    ARGUMENTS  = "-t 15 -m hfhub,http,s3,one,linuxcontainers"
]
```

Add `MARKET_MAD_CONF` entry:

```ruby
MARKET_MAD_CONF = [
    NAME = "hfhub",
    SUNSTONE_NAME = "Hugging Face Hub",
    REQUIRED_ATTRS = "",
    APP_ACTIONS = "monitor",
    PUBLIC = "yes",
    MARKET_MAD_CONF = ""
]
```

### Marketplace Creation

Create a marketplace template:

```default
NAME="HF Hub"
MARKET_MAD="hfhub"
HFHUB_ORG="ONEnextgen"
HFHUB_TASK="text-generation"
HFHUB_LIMIT="100"
HFHUB_AUTO_INDEX="YES"
```

Create the marketplace:

```default
$ onemarket create market_hfhub.tmpl
ID: 100
```

### Configuration Attributes

| Attribute | Required | Description | Default |
|-----------|----------|-------------|---------|
| `NAME` | **YES** | Marketplace name | - |
| `MARKET_MAD` | **YES** | Must be `hfhub` | - |
| `HFHUB_ORG` | No | Organization(s) to index from (comma-separated, e.g., `ONEnextgen, mycompany-ai`) | `ONEnextgen` |
| `HFHUB_TASK` | No | Pipeline tag filter (e.g., `text-generation`, `text-to-image`) | - |
| `HFHUB_COLLECTION` | No | Collection slug(s) to index from (comma-separated, e.g., `org/collection-slug`; overrides org/task) | - |
| `HFHUB_LIMIT` | No | Maximum models to index (global limit across all sources) | `50` |
| `HFHUB_AUTO_INDEX` | No | Enable/disable auto-indexing | `YES` |
| `HFHUB_SORT` | No | Sort field (`downloads`, `likes`, `lastModified`) | `downloads` |
| `HFHUB_DIRECTION` | No | Sort direction (`-1` = descending, `1` = ascending) | `-1` |

### Indexing Modes

The marketplace supports multiple indexing modes with **multi-source support**:

#### 1. Single Organization Mode (Default)

Index models from a single HuggingFace organization:

```default
NAME="HF Hub - OpenNebula Certified"
MARKET_MAD="hfhub"
HFHUB_ORG="ONEnextgen"
HFHUB_TASK="text-generation"
HFHUB_LIMIT="100"
HFHUB_AUTO_INDEX="YES"
```

Models from the `ONEnextgen` organization are automatically tagged with `OPENNEBULA_CERTIFIED="YES"`.

#### 2. Multiple Organizations Mode

Index models from multiple HuggingFace organizations simultaneously. Models are automatically deduplicated if they appear in multiple organizations:

```default
NAME="HF Hub - Enterprise & Certified"
MARKET_MAD="hfhub"
HFHUB_ORG="ONEnextgen, mycompany-ai, partner-org"
HFHUB_TASK="text-generation"
HFHUB_LIMIT="100"
HFHUB_AUTO_INDEX="YES"
```

**Benefits**:
- Single marketplace for all trusted models
- Centralized model catalog
- Automatic deduplication if models exist in multiple orgs
- Easier for users to discover available models

#### 3. Single Collection Mode

Index models from a specific HuggingFace collection:

```default
NAME="HF Hub - Custom Collection"
MARKET_MAD="hfhub"
HFHUB_COLLECTION="org/collection-slug"
HFHUB_LIMIT="50"
HFHUB_AUTO_INDEX="YES"
```


#### 4. Multiple Collections Mode

Index models from multiple HuggingFace collections simultaneously:

```default
NAME="HF Hub - Curated Collections"
MARKET_MAD="hfhub"
HFHUB_COLLECTION="org1/collection-slug1, org2/collection-slug2"
HFHUB_LIMIT="150"
HFHUB_AUTO_INDEX="YES"
```

**Benefits**:
- Combine multiple themed collections (e.g., text-generation, text-to-image)
- Centralized access to all curated models
- Automatic deduplication if models appear in multiple collections

## Authentication

### Gated Models

Some models on HuggingFace Hub are "gated" and require authentication. To access gated models:

1. Obtain a HuggingFace token from [https://huggingface.co/settings/tokens](https://huggingface.co/settings/tokens)
2. Configure the token in the oneadmin environment:

```default
$ sudo su - oneadmin
$ echo 'export HUGGING_FACE_HUB_TOKEN="hf_..."' >> ~/.bashrc
$ source ~/.bashrc
```

The token is read from the environment by the HFHUB marketplace scripts.

## Marketplace App Metadata

When models are indexed, the following metadata is stored in MarketPlace Apps:

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `MODEL_ID` | string | HF model identifier | `meta-llama/Meta-Llama-3-8B-Instruct` |
| `SOURCE` | URI | Logical URI to artifact | `hf://meta-llama/Meta-Llama-3-8B-Instruct` |
| `FORMAT` | string | Artifact format | `dir` |
| `SIZE` | integer | Model size in MB from HF storage | `15360` |
| `TASK` | string | HF pipeline_tag | `text-generation`, `text-to-image` |
| `LICENSE` | string | Model license | `mit`, `apache-2.0`, `llama3` |
| `DOWNLOADS` | integer | Total download count from HF | `12345678` |
| `LAST_MODIFIED` | ISO8601 | Last modification timestamp | `2024-03-15T10:30:00.000Z` |
| `HAS_CHAT_TEMPLATE` | YES/NO | Whether model has conversation formatting template (requires `--full 1`) | `YES` |
| `HF_URL` | URL | Web link to HF model page | `https://huggingface.co/meta-llama/...` |
| `METADATA_ONLY` | YES | Indicates no artifact downloaded yet | `YES` |
| `OPENNEBULA_CERTIFIED` | YES/NO | Official OpenNebula support (if from ONEnextgen org) | `YES` |

## Manual Indexing

The marketplace automatically indexes models via the `monitor` script, but you can also manually trigger indexing using `hf_catalog.py`:

```default
$ python3 /var/lib/one/remotes/market/hfhub/hf_catalog.py \
  --org ONEnextgen \
  --task text-generation \
  --limit 100 \
  --full 1
```

**Note**: The `hf_catalog.py` script is called by the `monitor` script automatically. Manual execution is typically only needed for testing or troubleshooting.

### Indexing Parameters

- `--collection <id>`: HF collection ID to index from (can be specified multiple times)
- `--org <name>`: Organization name to filter by (can be specified multiple times, default: `ONEnextgen`)
- `--task <task>`: Filter by HF pipeline_tag (e.g., `text-generation`)
- `--search <query>`: Free-text search across model names/descriptions
- `--sort <field>`: Sort by field (`downloads`, `likes`, `lastModified`)
- `--direction <-1\|1>`: Sort direction (-1 = descending, 1 = ascending)
- `--limit <n>`: Maximum number of models to index globally across all sources (default: 50)
- `--full <1>`: Check for chat template support (downloads tokenizer config per model, sets `HAS_CHAT_TEMPLATE` field)

### Multi-Source Indexing Examples

**Multiple Organizations**:
```default
$ python3 /var/lib/one/remotes/market/hfhub/hf_catalog.py \
  --org ONEnextgen \
  --org mycompany-ai \
  --task text-generation \
  --limit 100 \
  --full 1
```

**Multiple Collections**:
```default
$ python3 /var/lib/one/remotes/market/hfhub/hf_catalog.py \
  --collection org/collection-slug \
  --collection org2/collection-slug2 \
  --full 1
```

**Note**: It's recommended to use either collections **or** organizations, not both.

### About Chat Templates

The `--full 1` flag checks for **chat templates** in models. A chat template is a Jinja2 template that defines how to format multi-turn conversations for instruction/chat models. Models with chat templates can automatically format messages like:

```python
messages = [
    {"role": "system", "content": "You are a helpful assistant"},
    {"role": "user", "content": "Hello!"}
]
```

**When to use `--full 1`:**
- Indexing chat/instruction models where conversation formatting matters
- Building a catalog specifically for conversational AI applications

**When to omit it:**
- General model indexing (faster, lower API usage)
- Non-chat models (text-to-image, embeddings, etc.)
- Large-scale indexing where performance is critical

## Importing Models

When a user imports an HFHUB MarketPlace App into a datastore, the following workflow occurs:

1. The datastore driver's `cp` script receives the `hf://model_id` URI
2. The driver detects the `hf://` scheme and delegates to the downloader scripts
3. The model is downloaded from HuggingFace Hub using `hfhub_downloader.py`
4. The model is materialized according to the datastore type:
   - **Block-based datastores** (fs, qcow2, lvm, ceph): Model converted to `qcow2` disk image
   - **Shared filesystem datastores** (sharedfs): Model stored as native directory structure
5. An Image is created in the datastore with metadata from the marketplace

### Format Selection

The download format is automatically determined by the datastore type:

- **Block-based datastores**: Default to `qcow2` format
- **Shared filesystem datastores**: Default to `dir` format

Users can also explicitly specify the format in the URI:

```default
# Explicit qcow2 format
hf://meta-llama/Llama-3-8B?format=qcow2

# Explicit directory format
hf://meta-llama/Llama-3-8B?format=dir
```

### QCOW2 Format Prerequisites

When importing models to block-based datastores (qcow2 format), additional configuration is required on the OpenNebula Front-end:

#### 1. Install fuse2fs

The `fuse2fs` tool allows mounting ext4 disk images without root privileges:

```bash
# Debian/Ubuntu
apt-get install -y fuse2fs

# RHEL/CentOS/AlmaLinux
dnf install -y fuse2fs
```

#### 2. Configure Sudoers

The `create_hf_image.sh` helper script requires passwordless sudo for the `oneadmin` user:

```bash
echo 'oneadmin ALL=(ALL) NOPASSWD: /usr/lib/one/sh/create_hf_image.sh' \
    > /etc/sudoers.d/oneadmin-hfhub
chmod 440 /etc/sudoers.d/oneadmin-hfhub
```

#### 3. Configure HuggingFace Token for Datastore Driver

For gated models, the datastore driver needs access to the HuggingFace token. Add it to the fs datastore configuration:

```bash
echo 'export HUGGING_FACE_HUB_TOKEN="hf_..."' \
    >> /var/lib/one/remotes/etc/datastore/fs/fs.conf
```

{{< alert title="Note" color="warning" >}}
Without these prerequisites, importing models to qcow2 datastores will fail with errors like "Helper script not found" or "sudo: a password is required".
{{< /alert >}}

## OpenNebula Certified Models

OpenNebula maintains an official organization account on HuggingFace with curated collections:

- **Organization**: `ONEnextgen` ([https://huggingface.co/ONEnextgen](https://huggingface.co/ONEnextgen))
- **Collections**: Production-ready models tested and validated by OpenNebula
- **Certification**: Models from the `ONEnextgen` organization are automatically tagged with `OPENNEBULA_CERTIFIED="YES"`

### Indexing Certified Models

By default, the marketplace indexes from the OpenNebula organization:

```default
NAME="HF Hub - OpenNebula Certified"
MARKET_MAD="hfhub"
HFHUB_ORG="ONEnextgen"
HFHUB_TASK="text-generation"
HFHUB_LIMIT="100"
```

### Combining Certified and Enterprise Models

You can combine OpenNebula certified models with your own enterprise models in a single marketplace:

```default
NAME="HF Hub - Enterprise & Certified"
MARKET_MAD="hfhub"
HFHUB_ORG="ONEnextgen, myorganization-ai"
HFHUB_TASK="text-generation"
HFHUB_LIMIT="100"
HFHUB_AUTO_INDEX="YES"
```

This creates a unified catalog with:
- OpenNebula certified models (tagged with `OPENNEBULA_CERTIFIED="YES"`)
- Your organization's internal models
- Automatic deduplication if any models exist in both organizations