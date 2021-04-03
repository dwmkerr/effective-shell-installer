# effective-shell-installer

[![Release Please](https://github.com/dwmkerr/effective-shell-installer/actions/workflows/release-please.yaml/badge.svg)](https://github.com/dwmkerr/effective-shell-installer/actions/workflows/release-please.yaml)

This is the install script for the https://effective-shell.com samples. This repo hosts the https://effective.sh installer.

## Usage

To install the [Effective Shell](https://effective-shell.com) samples, just run:

```sh
curl effective.sh | sh
```

That's it!

## Versioning

The version of the script is defined in the [`version.txt`](./version.txt) file. This makes it reasonably straightforward to script actions which require the version.

Releasing in managed via [Release Please](https://github.com/googleapis/release-please) in the [`release-please.yaml`](./.github/workflows/release-please.yaml) workflow file.
