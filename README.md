# effective-shell-installer

[![Release Please](https://github.com/dwmkerr/effective-shell-installer/actions/workflows/release-please.yaml/badge.svg)](https://github.com/dwmkerr/effective-shell-installer/actions/workflows/release-please.yaml) ![Version Badge](https://img.shields.io/github/v/tag/dwmkerr/effective-shell-installer?label=Version) 

This is the install script for the https://effective-shell.com samples. This repo hosts the https://effective.sh installer.

## Usage

To install the [Effective Shell](https://effective-shell.com) samples, just run:

```sh
curl effective.sh | sh
```

That's it! This will download the Effective Shell samples to the folder:

```
~/effective-shell
```

If you already have the samples and they appear to be at the same version of the online samples, the script will not attempt to download and install the same version again. You can force the script to install them anyway by setting `ES_FORCE_INSTALL=1`.

If the `~/effective-shell` folder already exists, you can choose one of three options:

- `d` - delete and install - this option will delete the existing folder and replace it with the downloaded folder
- `o` - overwrite - this option will extract the downloaded samples over the existing folder, meaning files you have added will be preserved (but files that you have _modified_ will be overwritten)
- `q` - quit - this will abort the script, allowing you to backup the existing folder or move it and then run the script again

If you want to run the installer non-interactively, you can set `ES_EXISTING_FOLDER_ACTION` to either `d`, `o` or `q` to provide a choice from the options above.

## Installation Options

There are a number of options that can be set to change how the samples are installed.

| Option                      | Default   | Usage                                                                                                                   |
|-----------------------------|-----------|-------------------------------------------------------------------------------------------------------------------------|
| `ES_DEBUG`                  | `0`       | If set to `1` debug level log messages are printed.                                                                     |
| `ES_FORCE_INSTALL`          | `0`       | If set to `1` then samples are installed even if they appear to be up to date.                                          |
| `ES_EXISTING_FOLDER_ACTION` | (Not Set) | Set to `d`, `o`, or `q` to delete, overwrite or quit if the samples folder exists. If not set, the user will be prompted. |

## Versioning

The version of the script is defined in the [`version.txt`](./version.txt) file. This makes it reasonably straightforward to script actions which require the version.

Releasing in managed via [Release Please](https://github.com/googleapis/release-please) in the [`release-please.yaml`](./.github/workflows/release-please.yaml) workflow file.

## Source

The samples are available at: [github.com/dwmkerr/effective-shell/samples](https://github.com/effective-shell). The two sample repositories are available at in the [github.com/effective-shell](https://github.com/effective-shell) organisation. The repositories have to be hosted separately so that they can have their own commit history. The main Effective Shell project clones these repositories and adds them to the samples archive.
