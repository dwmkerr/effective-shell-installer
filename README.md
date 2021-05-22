# effective-shell-installer

[![Release Please](https://github.com/dwmkerr/effective-shell-installer/actions/workflows/release-please.yaml/badge.svg)](https://github.com/dwmkerr/effective-shell-installer/actions/workflows/release-please.yaml) ![Version Badge](https://img.shields.io/github/v/tag/dwmkerr/effective-shell-installer?label=Version) 

This is the install script for the https://effective-shell.com samples. This repo hosts the https://effective.sh installer.

## Usage

To install the [Effective Shell](https://effective-shell.com) samples, just run:

```sh
curl effective.sh | sh
```

That's it!

If you run the script and the downloaded samples have the same version number as the installed samples, the installed samples will not be overwritten.

## Installation Options

There are a number of options that can be set to change how the samples are installed.

| Option             | Default | Usage                                                                          |
|--------------------|---------|--------------------------------------------------------------------------------|
| `ES_DEBUG`         | `0`     | If set to `1` debug level log messages are printed.                            |
| `ES_FORCE_INSTALL` | `0`     | If set to `1` then samples are installed even if they appear to be up to date. |

## Versioning

The version of the script is defined in the [`version.txt`](./version.txt) file. This makes it reasonably straightforward to script actions which require the version.

Releasing in managed via [Release Please](https://github.com/googleapis/release-please) in the [`release-please.yaml`](./.github/workflows/release-please.yaml) workflow file.
