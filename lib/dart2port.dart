import 'dart:io';

import 'package:pubspec_lock/pubspec_lock.dart';

void lockToPort(PubspecLock lockfile, {StringSink? out, StringSink? err}) {
  out ??= stdout;
  err ??= stderr;

  final packages = lockfile.packages.toList(growable: false);

  if (packages.every(
    (p) => p.iswitcho(hosted: (_) => false, otherwise: () => true),
  )) {
    err.writeln('No hosted packages found');
    return;
  }
  final maxNameLength = packages
      .where((p) => p.iswitcho(hosted: (_) => true, otherwise: () => false))
      .map((e) => e.package().length)
      .reduce((a, b) => a > b ? a : b);
  final maxVersionLength = packages
      .where((p) => p.iswitcho(hosted: (_) => true, otherwise: () => false))
      .map((e) => e.version().length)
      .reduce((a, b) => a > b ? a : b);

  out.writeln(r'pub.packages \');
  for (final package in packages) {
    if (!package.iswitcho(hosted: (_) => true, otherwise: () => false)) {
      err.writeln('Skipping ${package.package()}: not hosted');
      continue;
    }
    final hash = package.iswitcho(
      hosted: (h) => h.sha256,
      otherwise: () => null,
    );
    if (hash == null) {
      err.writeln('Skipping ${package.package()}: missing sha256');
      continue;
    }
    out
      ..write('    ')
      ..write(package.package().padRight(maxNameLength))
      ..write('  ')
      ..write(package.version().padLeft(maxVersionLength))
      ..write('  ')
      ..write(hash);
    if (!identical(package, packages.last)) {
      out.write(r' \');
    }
    out.writeln();
  }
}
