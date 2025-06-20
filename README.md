# OpenNebula 7.0 Documentation

This is the official repository of OpenNebula's Documentation, currently in development. This documentation is live at:
[http://docs.opennebula.io/7.0](http://docs.opennebula.io/7.0).

You are encouraged to fork this repo and send us pull requests!

To create issues to report changes and requests, please use the [OpenNebula main repository](https://github.com/OpenNebula/one), with label `Documentation`.

## Building

To build the documentation, you will need:

- The [Hugo](https://gohugo.io/) static site generator and web server: **extended version** between `0.128.0` and `0.145.0` (`0.145.0` recommended)
- [Go](https://go.dev/doc/install)
- [Node.js LTS](https://github.com/nodesource/distributions/blob/master/README.md#using-debian-as-root-nodejs-current)
- [npm](https://www.npmjs.com/)
- PostCSS

#### Installation

The environment can be automatically bootstrapped by running the `./setup.sh` file. This will download and install hugo `0.145.0` along with all other build requirements.
Thereafter you can use `npm run start` to download the different modules and start the server.

---

The documentation uses the [Docsy](https://www.docsy.dev/) theme. It is installed automatically as a Hugo module when Hugo first runs from the documentation root folder.

To build the documentation:

- Clone the repository
- From the repository root folder, run `hugo server`

Hugo should build the site and expose it on `localhost:1313/7.0/`.

## Spell Checking

Please ensure to check for typos before contributing!

To ensure compatibility with the OpenNebula wordlist, it is recommended to use `pyspelling` with the Aspell spell checking tool and the config file provided in the repo.

```
pyspelling -c .spellcheck.yml
```

This will run the spellcheck including the words in the dictionary provided in this repo, `dicts/OpenNebula.dic`.

You can also run the command from the provided script, `spellcheck.sh`.

For installation details on Linux and macOS please see SPELLCHECKING.md.

## More Info

- [Hugo installation](https://gohugo.io/installation/)
- [Hugo releases on GitHub](https://github.com/gohugoio/hugo/releases)
- [PySpelling](https://facelessuser.github.io/pyspelling/)
