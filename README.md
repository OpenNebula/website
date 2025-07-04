# OpenNebula 7.0 Documentation

This is the official repository of OpenNebula's technical documentation. This documentation is live at:
[http://docs.opennebula.io/7.0](http://docs.opennebula.io/7.0).

You are encouraged to fork this repo and send us pull requests!

To create issues to report changes and requests, please use the [OpenNebula main repository](https://github.com/OpenNebula/one), with label `Documentation`.

For details on contributing to the documentation, including full instructions for building the environment, formatting and spell checking, please see [Contributing to the Documentation](#contributing-to-the-documentation) below.

## Quick Intro

To build the documentation, you will need:

- The [Hugo](https://gohugo.io/) static site generator and web server: **extended version** between `0.128.0` and `0.145.0`. Version `0.145.0` is **highly** recommended since the documentation was built with this version
- [Go](https://go.dev/doc/install)
- [Node.js LTS](https://github.com/nodesource/distributions/blob/master/README.md#using-debian-as-root-nodejs-current)
- [npm](https://www.npmjs.com/)
- PostCSS

The environment can be automatically bootstrapped by running the `./setup.sh` script. This will download and install hugo `0.145.0` along with all other build requirements.
Thereafter you can use `npm run start` to download the different modules and start the server.

The documentation uses the [Docsy](https://www.docsy.dev/) theme. It is installed automatically as a Hugo module when Hugo first runs from the documentation root folder.

To build the documentation:

- Clone the repository
- From the repository root folder, run `hugo server`

Hugo should build the site and expose it on `localhost:1313/7.0/`.

The sections below provide a complete guide for contributing to the documentation.

## Contributing to the Documentation

To work on the documentation, you will need to install the Hugo web server on your machine and deploy the site locally, to preview your changes. The basic steps are:

1. Install the Hugo web server on your machine and all the pre-requisites.  
2. Fork the GH repo of the docs, and clone your fork locally.
3. Create a new branch in your local copy.
4. Deploy the docs site on your local machine.  
5. Make the desired modifications, live-previewing on your local site.  
6. Commit signed and using the usual format as defined in the GitHub Issue Resolution Process.  
7. Create the PR as per the GH Issue Resolution Process.

**Contents for quick reference:**

- [Quick Links](#quick-links)
- [Prepare your Environment](#prepare-your-environment)
- [Preview the Docs in Hugo](#preview-the-docs-in-hugo)
- [Basic Hugo Site Structure](#basic-hugo-site-structure)
- [Editing the Docs](#editing-the-docs)
  - [Links](#links)
  - [Images](#images)
  - [Alerts](#alerts)
  - [Tables](#tables)
  - [OpenAPI](#openapi)
  - [Version Variables](#using-documentation-and-software-version-variables)
  - [Checking Spelling](#checking-spelling)

## Quick Links

### Hugo

Hugo homepage: [https://gohugo.io/](https://gohugo.io/).

To download the recommended version, 0.145.0: [0.145.0 release page](https://github.com/gohugoio/hugo/releases/tag/v0.145.0).

> [!WARNING]
> It is recommended to download Hugo version 0.145.0, since this is the version used by the GitHub Action. Do not install a version higher than 0.145.0, since version 0.146.0 (released April 10 2025\) introduced changes in the template system, and the site won't build on this version.

(For reference, see: [https://gohugo.io/installation/](https://gohugo.io/installation/).)

## Prepare your Environment

When modifying the docs, it is highly recommended to preview your changes before creating the PR, to ensure there are no errors. Some errors in docs pages (such as unresolvable intra-site links) will cause the GitHub build to fail and changes not to be deployed.

To download and install the Hugo web server and site dependencies, you can follow the below steps manually or use the provided `setup.sh` script (see [above](#quick-intro)).

### Pre-requisites

1. **Install Go**, you can use your distribution packages, for reference, see the [Go Installation Guide](https://go.dev/doc/install)
2. **Install Node.js LTS & NPM**, You will need to install Node v22 and NPM. To avoid possible errors, the recommended installation method is to use NVM (Node Version Manager, check the [installation instructions](https://github.com/nvm-sh/nvm?tab=readme-ov-file#install--update-script))
3. **Clone** this Github repository
4. **Install node dependencies**, trun ``npm install`` in the root directory of the repository.
5. **Download and Install Hugo**, It is recommended to install Hugo 0.145.0 (note that 0.146.0 will not work because of changes in template system). For reference, see: [https://gohugo.io/installation/](https://gohugo.io/installation/).)

The docs site uses Hugo \+ the [Docsy theme](https://www.docsy.dev/), which is a Hugo module. When you deploy the site locally for the first time, Hugo should automatically download the theme.

## Preview the Docs in Hugo

In your terminal, cd to the root directory of your local repo of the docs, and run `hugo server`. Hugo should download the site’s modules and dependencies and deploy the site locally via its embedded web server, by default on port 1313\.

```
hugo server
hugo: downloading modules …
hugo: collected modules in 31780 msWatching for changes in /home/adm/opennebula/website-version_5/{assets,content,layouts,package.json}
Watching for config changes in /home/adm/opennebula/website-version_5/hugo.toml, /home/adm/opennebula/website-version_5/go.mod
Start building sites … 
hugo v0.145.0-666444f0a52132f9fec9f71cf25b441cc6a4f355+extended linux/amd64 BuildDate=2025-02-26T15:41:25Z VendorInfo=gohugoio

                   | EN   
-------------------+------
  Pages            | 508  
  Paginator pages  |   0  
  Non-page files   |   2  
  Static files     |  30  
  Processed images |   2  
  Aliases          |   0  
  Cleaned          |   0  

Built in 6508 ms
Environment: "development"
Serving pages from disk
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at //localhost:1313/ (bind address 127.0.0.1)
```

Hugo will build the HTML files in the site’s `public` directory and serve the site on localhost port 1313, or another port if 1313 isn’t available.

To view the site, fire up a browser and go to `localhost:1313/7.0/`. You should see the home page of the OpenNebula docs site, with the table of  contents on the left.

If you change the contents of a doc page in the docs repo, the page shown in the browser will be automatically updated.

> [!TIP]
> Useful options for running Hugo in server mode:  
> `--disableFastRender` \- Enables full renders on changes  
> `--noHTTPCache` \- Prevent HTTP caching

## Basic Hugo Site Structure

### Directory Structure

The docs repo contents are similar to this:

```
<docs_root_folder>$ ls
assets/  content/  go.sum     layouts/  node_modules/  package-lock.json  README.md   static/
CNAME    go.mod    hugo.toml  LICENSE   package.json   public/            resources/
```

The docs Markdown files are in `content/`. When you run Hugo, it builds the complete HTML site into `public/`. The `public/` folder is not pushed to the online repo; you can delete its contents when not running Hugo.

`assets/images/` contains all images for the site. New images should be placed here.

The directory structure of the local site in Markdown is the same as the finished site in HTML. You can find a specific page in the Markdown files by simply following the URL in the online, e.g. `product/cloud_system_administration/multitenancy/auth_overview/`.

```
<docs_root_folder>$ ls content/product/cloud_system_administration/multitenancy/auth_overview.md 
content/product/cloud_system_administration/multitenancy/auth_overview.md
```

For instance, the directories for the "Cloud Architecture and Design" section:

```
├── cloud_architecture_and_design
│   ├── cloud_architecture_design.md
│   ├── edge_cloud_reference_architecture.md
│   ├── _index.md
│   └── open_cloud_reference_architecture.md
├── _index.md
└── opennebula_concepts
    ├── cloud_access_model_and_roles.md
    ├── _index.md
    ├── key_features.md
    ├── knowledge_base.md
    ├── opennebula_overview.md
    └── use_cases.md
```

### Index Files

In Hugo, all sections and subsections must have an `_index.md` file, or they will not be shown in the auto-generated content tables.

The Markdown `_index.md` files are empty except for the mandatory "front matter" (more on that below). When building the site, Hugo autogenerates a table of contents (ToC) for the section, and fills the resulting index.html file with it. This is the default behavior unless `no_page_list = true` is present in the `_index.md` front matter.

```
understand_opennebula$ cat _index.md 
---
title: "Understand OpenNebula"
date: "2025-02-17"
description: "Overview of OpenNebula, its key concepts and features"
categories:
pageintoc: "2"
tags:
weight: "1"
---

<a id="understand-opennebula"></a>

<!--# Understand OpenNebula -->
```

The "front matter" is the YAML content between the `---`. (The HTML ID and the commented-out title were produced during the docs migration, and can be ignored.)

When creating a new section or subsection, you will need to create an `_index.md` file with the front matter, but no other content is needed in the file.

### Markdown and Hugo "Shortcodes"

Hugo is written in the Go language. It exposes an API through which you can call Go templates from within a page’s markup. These templates define formatting for elements within a page.

Invoking a shortcode from Markup takes the form `{{<...>}}` or `{{%...%}}`. The first tells Hugo that the inner content is HTML/plain text and needs no further processing. The second tells Hugo that the contents are Markdown.

In the site, the most-often used shortcode by far is `relref` (although it may be removed, see note below). Others include the `image` shortcode for setting image size, and the `card` and `cardpane` shortcodes used in the index files.

For more information on shortcodes, see the [Hugo documentation](https://gohugo.io/content-management/shortcodes/).

### Page Front Matter

Each docs page must have a section at the beginning called the "front matter", or it will not be shown in the finished site.

Currently most pages contain front matter like the following:

```
understand_opennebula$ head opennebula_concepts/opennebula_overview.md
---
title: "OpenNebula Overview"
date: "2025-02-17"
description:
categories: [Introduction, Overview]
pageintoc: "4"
tags:
weight: "1"
---
```

- `title` will be automatically shown in the ToCs and at the top of the docs page. So when creating a new page, do not include the title as a Markdown header.
- `date` can be safely ignored. There is no need to include it when creating a new page.
- `description` is currently used for "Chapters" (top-level, H1), sections and subsections. It's shown in the auto-generated index files. When creating a new page, there is no need to include it.
- `categories` are used to populate the tag cloud; for the moment their use is limited to the Quick Start.
- `pageintoc` is a residue from the migration and can be ignored.
- `weight` determines the order that the section or page will appear in the ToC. If `weight` = `1` the section or page appears at the beginning of the ToC for the section that it resides in. If two pages in a section have the same weight number, or if they do not have a weight number, their order in the ToC is determined alphabetically by their titles.

## Editing the Docs

Writing in a Hugo site is very similar to writing GitHub wiki pages.

For a syntax reference, see [Basic writing and formatting syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) in GH.

### Links

Links format:

```
[Link Name](https://www.example.com)
```

### Intra-site Links

When linking to a page within the documentation site, we can either:

>1. **Use relative links as usual in Markdown**, which requires entering the relative path of the page we are linking to; or
>2. **if linking to a page with a unique filename, we can use the Hugo `relref` shortcode**, which allows to omit the path and link only by filename.

#### Option 1: Use Relative Links

Use relative links as usual in Markdown, in the form:

```
[Link Name](path/to/file)
```

For example:

```
[Self Provision](../../virtual_machines_operation/virtual_machines_networking/self_provision)
```

Use _relative_ paths. On Bash, to quickly find out the relative path of a file, from the directory of the referrer file you can use `ls` with the autocomplete feature (`TAB`).

Note that:
- You can link to sections within a page with `#<section name>`
- The `.md` suffix is not necessary

#### Option 2: Use the `relref` Shortcode

The `relref` shortcode allows you to create intra-site links by referencing only the page filename (and page section if desired). Using `relref` requires that the referenced page has a unique filename on the site.

`relref` is handy for writing quickly and for preventing broken links in case of changes in the ToC structure.

Format:

```
[Link name]({{% relref "linked_page" %}})
```

For example:

```
For further configuration, check the specific [guide]({{% relref "kvm_driver#kvmg" %}}).
```

As with relative links, note that:
- You can link to sections within a page with `#<section name>`
- The `.md` suffix is not necessary

>[!WARNING]
>Hugo shortcodes, including `relref`, are not rendered in GitHub, so links created with `relref` will not work when viewing a docs page on GitHub.

### Images

To insert an image:

```
![image tag](/images/image.png)
```

For example:

```
![image1](/images/sunstone_user_info_quotas.png)
```

#### Setting Image Size

To set the image size, we use the `image` "shortcode". (A shortcode passes HTML to Hugo to inject in the page, or invokes the Hugo Go API to format something based on a template.)

To link to an image and set its size:

```
{{< image path=/images/image width=XXX height=XXX >}}
```

where `width` and `height` are in pixels. For example:

```
{{< image path=/images/one_deploy_basic_arch.png width=720 height=446 >}}
```

(As you can see in this case, the `image` shortcode simply passes the width and height to Hugo in HTML.)

#### Aligning Images

We are currently placing most images without alignment (by default they are aligned left); however, in some cases it may be necessary to align an image, for example to center an image that is narrower than usual.

For the time being, to manually align an image we are using the `alt` attribute for the image:

- `alt="<"` aligns left
- `alt=">"` aligns right
- `alt="><"` aligns center

**Examples**:

Center image, using regular Markdown:

```
![><](/images/fs_ssh.png)
```

Center image, using the `image` shortcode:

```
{{< image alt="><" path=/images/local_ds_cache.png width=837 height=557 >}}
```

### Alerts

To place an alert, use the `alert` shortcode:

```
{{< alert title = "Title" color = "color" >}}Text of the alert.{{< /alert >}}
```

For example:

```
{{< alert title="Warning" color="warning" >}}
Make sure that every OpenNebula process is stopped. The output of `systemctl list-units | grep opennebula` should be empty.
{{< /alert >}}
```

#### Supported Alert Types

In the docs we are currently using:

| Alert title | Color |
|--------|--------------|
| `Note` | `success` |
| `Important` | `success` |
| `Warning` | `warning` |
| `Tip` | `info` |

The `alerts` shortcode automatically inserts the appropriate icon into the alert HTML, based on the alert title. If the alert title is other than those listed in the table above, a generic "info" icon (the same as for title "Note") is inserted, and if there is no title, no icon is inserted.

### Tables

Example:

```
| Parameter                   | Description                                                           |
|-----------------------------|-----------------------------------------------------------------------|
| `--name name`               | Name of the new Image                                                 |
| `--datastore name \| ID`    | Name/ID of the Datastore to store the new Image                       |
| `--description description` | Description for the new Image (Optional)                              |
```

Formatted output:

| Parameter                   | Description                                                           |
|-----------------------------|-----------------------------------------------------------------------|
| `--name name`               | Name of the new Image                                                 |
| `--datastore name \| ID`    | Name/ID of the Datastore to store the new Image                       |
| `--description description` | Description for the new Image (Optional)                              |


#### Table Formatting

In tables, the "pipe" character ( `|` ) must be escaped, or it will be interpreted as a column delimiter.

Unlike in ReStructured Text, it is not mandatory for columns in the Markdown file to have the same width (although it's recommended for readability).

For long paragraphs, if possible do *not* insert line breaks in tables, since that would force a line break in the HTML even if it's not necessary in the rendered page. If you need to insert a line break, you can use the HTML `<br>`, as below:

```
| `--datastore name \| ID`    | Name/ID of the Datastore<br>to store the new Image                       |
```

The row above produces:

| Parameter                   | Description                                                           |
|-----------------------------|-----------------------------------------------------------------------|
| `--name name`               | Name of the new Image                                                 |
| `--datastore name \| ID`    | Name/ID of the Datastore<br> to store the new Image                   |
| `--description description` | Description for the new Image (Optional)                              |

Markdown tables do not support merged columns or rows.

### OpenAPI

You can reference API documentation from a YAML or JSON file in one of two ways:

1. With the `redoc` shortcode:

>```
>{{< redoc "path/to/file/api.json" >}}
>```

2. With the `swaggerui` shortcode:

>```
>{{< swaggerui src="/path/to/file/api.yaml" >}}
>```

Note that for the `swaggerui` shortcode to work, the page must be of type `swagger`, i.e. the page front matter must declare:

```
type = "swagger"
```

For reference, see the [Docsy documentation](https://www.docsy.dev/docs/adding-content/shortcodes/#swaggerui).

### Using Documentation and Software Version Variables

You can insert the following variables:

- `version`: The short version of OpenNebula, e.g. `7.0`.
- `release`: The full release version of OpenNebula, e.g. `6.99.85`.
- `context_release`: Version of the context packages, e.g. `7.0.0`.
- `docs_version`: Version of the documentation, e.g. `7.0`.

Note that `docs_version` may be used by some shortcodes to reference part of the site's URL.

To insert a version with a variable, use a shortcode with the variable name. Examples:

```
The upgrade to OpenNebula EE {{< version >}}...
```

```
https://<token>@enterprise.opennebula.io/repo/{{< release >}}/Debian/11 stable
```

To consult the current values of the variables, see the `hugo.toml` configuration file (look for `### Version variables`).


### Checking Spelling

After editing a document or creating a new document, spell check for typos using PysPelling with Aspell, with the OpenNebula wordlist provided in the repository.

Spell checking tools:

#### Requisites:

- Python >=3.8 (for PysPelling)
- `aspell`
- `aspell-en`
- `pyspelling`
- `pymdownx-blocks` (for parsing Markdown)

#### Installation

##### Aspell

If you're on Linux, most probably Aspell and the dictionary used (`en_US`) is already installed. Otherwise, on most Linux distributions Aspell and its dictionaries will be available in the distribution's package manager.

To install Aspell and the US English dictionary on Debian/Ubuntu:

```
sudo apt-get install aspell aspell-en
```

Installation example on macOS:

```
brew install aspell
```

On macOS, you will have to download a dictionary and place it in `/Library/Spelling`. You can obtain Aspell dictionaries from `https://ftp.gnu.org/gnu/aspell/dict/en/`.

##### Installing PysPelling

```
pip install pyspelling
pip install pymdownx-blocks
```

After installation, ensure that the directory to which the scripts are installed is included in your `PATH` environment variable. In Linux, by default they are installed in `~/.local/bin`. To add this directory to your environment, edit the configuration file for your command interpreter (for example `~/.bashrc`) and add the following:

```
export PATH="$PATH:~/local/.bin"
```

Then, log out and log back in or reload your environment with `source ~/.bashrc`.

##### Running the Spell Checker

Run the spell checker indicating the config file, `.spellcheck.yml`.

```
pyspelling -c .spellcheck.yml
```

Alternatively you can use the provided `spellcheck.sh`:

```
./spellecheck.sh
```

This runs the spell checker for the whole repo, excluding the words provided in the OpenNebula wordlist (in `dicts/OpenNebula.dic`).


If you wish to only check the files that you wrote or modified:

```
--name Markdown -c .spellcheck.yml --source <file>
```

Or using the script:

```
./spellcheck.sh --source <file>
```

For example:

```
pyspelling --name Markdown -c .spellcheck.yml --source content/product/my_new_section/*.md
```

```
./spellcheck.sh --source content/product/my_new_section/*.md
```

Both of the above commands check every Markdown file (\*md) in the specified section. Note that if not using `spellcheck.sh`, in order to check only specific file(s) you have to pass the `--name Markdown` parameter.

To specify the number of parallel processes that `pyspelling` should run, you can use the `--jobs` flag, e.g. `--jobs 8`. This can be useful when spellchecking the whole site.

For help, `pyspelling -h`.

##### Failed Spell Checks/Adding Words to the Dictionary

The spell checker displays its results on standard output, including any errors and the names of the files where they occur. If you get any errors you will need to correct them or, if an error is a false positive, update the dictionary at `dicts/OpenNebula.dic` and include the update in your PR.

If you get unexpected behavior, please check the default options for your Aspell installation (to quickly check your Aspell config, you can run `aspell dump config`).
