# pub2port: a MacPorts (partial) portfile generator for Dart projects

pub2port is a tool for generating `pub.packages` stanzas for use in
[MacPorts](https://www.macports.org/) portfiles that build projects written in
[Dart](https://dart.dev/).

## Installation

TODO

## Usage

```
pub2port path/to/pubspec.lock
```

Or, for instance

```
curl https://example.com/git/raw/pubspec.lock | pub2port
```

## License

pub2port is available under the three-clause BSD license.
