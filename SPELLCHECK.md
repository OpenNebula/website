
# Checking Spelling in this Repo

To quickly check spelling including the words in the provided dictionary, you can use PySpelling with Aspell and the `aspell-en` English dictionary.

### Requisites:

- `aspell`
- `aspell-en`
- `pyspelling`
- `pymdownx-blocks` (for parsing Markdown)

### Installation

On most Linux distributions Aspell and its dictionaries will be available in the distribution's package manager.

Installation example on Debian/Ubuntu:

```
sudo apt-get install aspell aspell-en
```

Installation example on macOS:

```
brew install aspell
```

On macOS, you will have to download a dictionary and place it in `/Library/Spelling`. You can obtain Aspell dictionaries from `https://ftp.gnu.org/gnu/aspell/dict/en/`.

**To install `pyspelling`**:

```
pip install pyspelling
pip install pymdownx-blocks
```

Ensure that the directory to which the scripts are installed is included in your `PATH` environment variable. In Linux, by default they are installed in `~/.local/bin`. To add this directory to your environment, edit the configuration file for your command interpreter (for example `~/.bashrc`) and add the following:

```
export PATH="$PATH:~/local/.bin"
```

Then, log out and log back in or reload your environment with `source ~/.bashrc`.

### Running the Spellchecker

Running the spellchecker with the provided configuration file will automatically spell-check all files in the repository and exclude the words in the OpenNebula wordlist (in `dicts/OpenNebula.dic`).

To run the spellchecker:

```
pyspelling -c .spellcheck.yml
```

If you wish to only check the files that you wrote or modified:

```
--name Markdown -c .spellcheck.yml --source <file>
```

For example:

```
--name Markdown -c .spellcheck.yml --source content/product/my_new_section/*.md
```

checks every Markdown file (\*md) in the specified section. Note that to check only specific file(s) you have to pass the `--name Markdown` parameter.

To specify the number of parallel processes that `pyspelling` should run, you can use the `--jobs` flag, e.g. `--jobs 8`. This can be useful when spellchecking the whole site.

For help, `pyspelling -h`.


## More Info

- [Hugo installation](https://gohugo.io/installation/)
- [Hugo releases on GitHub](https://github.com/gohugoio/hugo/releases)
- [PySpelling](https://facelessuser.github.io/pyspelling/)
