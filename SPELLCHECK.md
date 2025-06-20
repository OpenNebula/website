
# Checking Spelling in this Repo

To quickly check spelling including the words in the provided dictionary, you can use PySpelling with Aspell and the `aspell-en` U.S. English dictionary.

## Requisites:

- Python >=3.8 (for PysPelling)
- `aspell`
- `aspell-en`
- `pyspelling`
- `pymdownx-blocks` (for parsing Markdown)

## Installation

### Installing Aspell

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

### Installing PysPelling

```
pip install pyspelling
pip install pymdownx-blocks
```

After installation, ensure that the directory to which the scripts are installed is included in your `PATH` environment variable. In Linux, by default they are installed in `~/.local/bin`. To add this directory to your environment, edit the configuration file for your command interpreter (for example `~/.bashrc`) and add the following:

```
export PATH="$PATH:~/local/.bin"
```

Then, log out and log back in or reload your environment with `source ~/.bashrc`.

### Running the Spellchecker

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
./spellchecker.sh --source <file>
```

For example:

```
pyspelling --name Markdown -c .spellcheck.yml --source content/product/my_new_section/*.md
```

```
./spellchecker.sh --source content/product/my_new_section/*.md
```

Both of the above commands check every Markdown file (\*md) in the specified section. Note that if not using `spellcheck.sh`, in order to check only specific file(s) you have to pass the `--name Markdown` parameter.

To specify the number of parallel processes that `pyspelling` should run, you can use the `--jobs` flag, e.g. `--jobs 8`. This can be useful when spellchecking the whole site.

For help, `pyspelling -h`.

### Failed Spell Checks/Adding Words to the Dictionary

The spell checker displays its results on standard output, including any errors and the names of the files where they occur. If you get any errors you will need to correct them or, if an error is a false positive, update the dictionary at `dicts/OpenNebula.dic` and include the update in your PR.

If you get unexpected behavior, please check the default options for your Aspell installation (to quickly check your Aspell config, you can run `aspell dump config`).

## More Info

- [Hugo installation](https://gohugo.io/installation/)
- [Hugo releases on GitHub](https://github.com/gohugoio/hugo/releases)
- [PySpelling](https://facelessuser.github.io/pyspelling/)
