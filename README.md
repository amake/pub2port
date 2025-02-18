# pub2port: a MacPorts (partial) portfile generator for Dart projects

pub2port is a tool for generating `pub.packages` stanzas for use in
[MacPorts](https://www.macports.org/) portfiles that build projects written in
[Dart](https://dart.dev/).

## Installation

Install with MacPorts:

```
sudo port install pub2port
```

Or with Dart:

```
dart pub global activate pub2port
```

## Usage

Generate from a local file:

```
pub2port path/to/pubspec.lock
```

Or from a remote file like so:

```
curl https://example.com/git/raw/pubspec.lock | pub2port
```

## License

pub2port is available under the three-clause BSD license.

## See also

- [pub-1.0
  PortGroup](https://github.com/macports/macports-ports/blob/master/_resources/port1.0/group/pub-1.0.tcl)
