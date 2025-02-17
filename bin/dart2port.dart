import 'dart:io';

import 'package:args/args.dart';
import 'package:dart2port/dart2port.dart';
import 'package:pubspec_lock_parse/pubspec_lock_parse.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag('version', negatable: false, help: 'Print the tool version.');
}

void printUsage(ArgParser argParser) {
  print('Usage: dart2port <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.flag('help')) {
      printUsage(argParser);
      return;
    }
    if (results.flag('version')) {
      print('dart2port version: $version');
      return;
    }
    if (results.flag('verbose')) {
      verbose = true;
    }
    if (results.rest.isEmpty) {
      printUsage(argParser);
      exit(64);
    }

    for (final arg in results.rest) {
      if (verbose) {
        stderr.writeln('Processing: $arg');
      }
      final file = File(arg);
      if (!file.existsSync()) {
        stderr.writeln('File not found: $arg');
        continue;
      }
      try {
        final lockStr = file.readAsStringSync();
        final lockfile = PubspecLock.parse(lockStr);
        lockToPort(lockfile);
      } catch (e) {
        stderr.writeln('Error processing $arg: $e');
      }
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
    exit(64);
  }
}
