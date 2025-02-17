import 'dart:io';

import 'package:pubspec_lock_parse/pubspec_lock_parse.dart';

void lockToPort(PubspecLock lockfile, {StringSink? out, StringSink? err}) {
  out ??= stdout;
  err ??= stderr;

  final packageNames = lockfile.packages.keys.toList()..sort();
  if (!packageNames.any(
    (p) => lockfile.packages[p]!.source == PackageSource.hosted,
  )) {
    err.writeln('No hosted packages found');
    return;
  }
  final maxNameLength = packageNames
      .where((p) => lockfile.packages[p]!.source == PackageSource.hosted)
      .map((e) => e.length)
      .reduce((a, b) => a > b ? a : b);

  final versions =
      lockfile.packages.values
          .where((p) => p.source == PackageSource.hosted)
          .map((e) => e.version.toString())
          .toList();
  final maxVersionLength = versions
      .map((e) => e.length)
      .reduce((a, b) => a > b ? a : b);

  out.writeln(r'pub.packages \');
  for (final packageName in packageNames) {
    final package = lockfile.packages[packageName]!;
    if (package.source != PackageSource.hosted) {
      err.writeln('Skipping $packageName: not hosted');
      continue;
    }
    final description = package.description as HostedPackageDescription;
    out
      ..write('    ')
      ..write(packageName.padRight(maxNameLength))
      ..write('  ')
      ..write(package.version.toString().padLeft(maxVersionLength))
      ..write('  ')
      ..write(description.sha256);
    if (packageName != packageNames.last) {
      out.write(r' \');
    }
    out.writeln();
  }
}
