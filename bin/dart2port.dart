import 'dart:io';

import 'package:args/command_runner.dart';

const version = '0.0.1';

CommandRunner buildRunner() {
  final runner =
      CommandRunner('dart2port', 'Dart to port tool.')
        ..addCommand(GetCommand())
        ..addCommand(UpdateCommand());
  runner.argParser
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'debug',
      abbr: 'd',
      negatable: false,
      help: 'Print debug information.',
    )
    ..addFlag('version', negatable: false, help: 'Print the version.');
  return runner;
}

class GetCommand extends Command {
  GetCommand() {
    argParser
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Output FILE ("-" for stdout).',
        valueHelp: 'FILE',
        defaultsTo: '-',
      )
      ..addOption(
        'dir',
        abbr: 'd',
        help: 'Directory of lockfile in repo.',
        valueHelp: 'DIR',
        defaultsTo: '/',
      );
  }

  @override
  String get name => 'get';

  @override
  String get description =>
      'Generate a MacPorts portfile and output it to stdout.';

  @override
  void run() {
    // TODO(aaron): Implement the get command.
    print('Get command not yet implemented.');
    exit(0);
  }
}

class UpdateCommand extends Command {
  UpdateCommand() {
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'Output FILE ("-" for stdout).',
    );
  }

  @override
  String get name => 'update';

  @override
  String get description => 'Overwrite an existing MacPorts portfile.';

  @override
  void run() {
    // TODO(aaron): Implement the update command.
    print('Update command not yet implemented.');
    exit(0);
  }
}

void printUsage(CommandRunner runner) {
  print('Usage: dart dart2port.dart <flags> [arguments]');
  print(runner.usage);
}

void main(List<String> arguments) async {
  final runner = buildRunner();
  try {
    final results = runner.argParser.parse(arguments);
    if (results.flag('version')) {
      print('dart2port version: $version');
      return;
    }
  } catch (_) {
    // ignore
  }

  try {
    runner.run(arguments);
  } catch (error) {
    if (error is! UsageException) rethrow;
    print(error);
    exit(64); // Exit code 64 indicates a usage error.
  }
}
