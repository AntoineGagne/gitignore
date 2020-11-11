# gitignore

Use [gitignore.io](https://www.toptal.com/developers/gitignore) API to fetch
`.gitignore` content according to a specified set of tools/languages.

## Usage

### Listing Tools/Languages

To list the allowed tools/languages, the following command may be used:

```sh
gitignore list
```

### Creating a `.gitignore`

To create a `.gitignore`, the following command may be used:

```sh
gitignore create ${TOOLS} > .gitignore
```

For example, to create a `.gitignore` for working on a Rust project in a Linux
environment with the Vim editor:

```sh
gitignore create rust linux vim > .gitignore
```

## Compiling

To compile this project, the following command can be used:

```sh
cargo build --release
```

## License

This projet is licensed under the MIT license.
