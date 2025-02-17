import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:pub2port/pub2port.dart';
import 'package:pubspec_lock/pubspec_lock.dart';

const version = String.fromEnvironment('APP_VERSION', defaultValue: 'unknown');

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
  print('Usage: pub2port <flags> [arguments]');
  print(argParser.usage);
}

Future<String?> readArg(String arg) async {
  if (arg == '-') {
    return await stdin.transform(utf8.decoder).join();
  }

  final file = File(arg);
  if (!file.existsSync()) {
    stderr.writeln('File not found: $arg');
    return null;
  }
  try {
    return file.readAsStringSync();
  } catch (e) {
    stderr.writeln('Error reading $arg: $e');
    return null;
  }
}

bool hasStdin() => switch (stdioType(stdin)) {
  StdioType.pipe => true,
  StdioType.file => true,
  _ => false,
};

void main(List<String> arguments) async {
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
      print('pub2port version: $version');
      return;
    }
    if (results.flag('verbose')) {
      verbose = true;
    }

    final restArgs = [...results.rest];

    if (hasStdin() && !restArgs.contains('-')) {
      restArgs.add('-');
    }

    if (restArgs.isEmpty) {
      printUsage(argParser);
      exit(64);
    }

    for (final arg in restArgs) {
      if (verbose) stderr.writeln('Processing: $arg');

      final lockStr = await readArg(arg);
      if (lockStr == null) continue;

      try {
        final lockfile = lockStr.loadPubspecLockFromYaml();
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
