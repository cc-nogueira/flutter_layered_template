#!/usr/bin/env dart

import 'dart:io';

import 'dart:math';

Future<void> main(List<String> arguments) async => await Main(arguments).run();

class Main {
  Main(this.arguments);

  static const leftPad = 6;
  static const rightPad = 10;

  final List<String> arguments;
  late final LayersProject project;

  Future<void> run() async {
    project = LayersProject(Directory.current);
    if (!project.isOK) {
      _printProjectNotOK();
      return;
    }

    if (arguments.isEmpty) {
      _printUsage();
      return;
    }

    late final ExecutionOptions options;
    switch (arguments.first) {
      case 'init':
        options = _initOptions;
        break;
      case 'build':
        options = _buildOptions;
        break;
      case 'clean':
        options = _cleanOptions;
        break;
      case 'test':
        options = _testOptions;
        break;
      default:
        _printUsage('Invalid commnad "${arguments.first}".');
        return;
    }

    if (options.args.isNotValid) {
      options.args.printInvalidArgsForCommand(arguments.first);
    }
    if (options.args.hasHelp || options.args.isNotValid) {
      options.args.printOptions();
      return;
    }

    final command = Execution(project: project, options: options);
    await command.execute();
    _writeln();
  }

  ExecutionOptions get _initOptions {
    final args = InitArguments(arguments.sublist(1));
    return ExecutionOptions.forInit(args);
  }

  ExecutionOptions get _buildOptions {
    final args = BuildArguments(arguments.sublist(1));
    return ExecutionOptions.forBuild(args);
  }

  ExecutionOptions get _cleanOptions {
    final args = CleanArguments(arguments.sublist(1));
    return ExecutionOptions.forClean(args);
  }

  ExecutionOptions get _testOptions {
    final args = TestArguments(arguments.sublist(1));
    return ExecutionOptions.forTest(args);
  }

  void _printUsage([String? message]) {
    if (message != null) {
      _writeln(message);
    }
    _writeln('Usage: dart project_build.dart <commmand> [options]\n'
        'Commands:\n'
        '${' ' * leftPad}${'init'.padRight(rightPad)} initialized flutter layered project\n'
        '${' ' * leftPad}${'build'.padRight(rightPad)} build the project\n'
        '${' ' * leftPad}${'clean'.padRight(rightPad)} clean the project\n'
        '${' ' * leftPad}${'test'.padRight(rightPad)} test all packages\n');
  }

  void _printProjectNotOK() {
    _writeln('Could not find the right project structure.\n'
        'Expecting to find a "packages" folder containg project layers.\n');
  }
}

class LayersProject extends Package {
  LayersProject(Directory root) : super(name: _projectName(root), dir: root) {
    _init();
  }

  static String _projectName(Directory root) {
    final segments = root.uri.pathSegments;
    for (int pos = segments.length - 1; pos >= 0; --pos) {
      final name = segments[pos];
      if (name.isNotEmpty) {
        return name;
      }
    }
    throw ArgumentError('Could not extract the current dir name');
  }

  static final _layerRegExp = RegExp(r'.*[/\\](_[^_]+_layer)$');

  late final Directory packagesDir;
  final layers = <Package>[];

  @override
  bool get isMainProject => true;

  @override
  String get description => 'main project';

  bool get isOK => layers.isNotEmpty;

  void _init() {
    packagesDir = Directory(dir.path + '/packages');
    if (!packagesDir.existsSync()) {
      return;
    }

    final layerEntries = <List<String>>[];
    for (final sub in packagesDir.listSync()) {
      final match = _layerRegExp.firstMatch(sub.path);
      if (match != null) {
        layerEntries.add([sub.path, match.group(1)!]);
      }
    }

    layerEntries.sort(_layerOrder);
    for (final each in layerEntries) {
      final dir = Directory(packagesDir.path + '/' + each[1]);
      if (dir.existsSync()) {
        layers.add(Package(name: each[1], dir: dir));
      }
    }
  }

  /// Sort
  ///   - Core Layer first
  ///   - Domain Layer second
  ///   - Data Layer third
  ///   - Presentation second last
  ///   - DI Layer last
  ///   - other layers alphabetically
  int _layerOrder(List<String> aList, List<String> bList) {
    final a = aList.last;
    final b = bList.last;
    if (a == b) return 0;
    if (a.contains('core')) return -1;
    if (b.contains('core')) return 1;
    if (a.contains('domain')) return -1;
    if (b.contains('domain')) return 1;
    if (a.contains('data')) return -1;
    if (b.contains('data')) return 1;
    if (a.contains('di')) return 1;
    if (b.contains('di')) return -1;
    if (a.contains('presentation')) return 1;
    if (b.contains('presentation')) return -1;
    return a.compareTo(b);
  }
}

class Package {
  Package({required this.name, required this.dir}) {
    maxDescLength = max(maxDescLength, description.length);
  }

  static int maxDescLength = 0;

  final String name;
  final Directory dir;

  bool get isMainProject => false;
  bool get isNotMainProject => !isMainProject;
  String get description => name;

  bool hasDependency(String dep) {
    final pubspec = File(dir.path + '/pubspec.yaml');
    if (!pubspec.existsSync()) {
      return false;
    }
    final lines = pubspec.readAsLinesSync();
    final depRX = RegExp('^ *$dep:.*');
    return lines.any((line) => depRX.hasMatch(line));
  }

  bool get hasBuildFiles {
    final packagesFile = File(dir.path + '/.packages');
    final dartToolDir = Directory(dir.path + '/.dart_tool');
    return packagesFile.existsSync() || dartToolDir.existsSync();
  }

  bool hasTestCases() {
    final testDir = Directory(dir.path + '/test');
    return _hasAnyTestIn(testDir);
  }

  bool _hasAnyTestIn(Directory dir) {
    if (!dir.existsSync()) {
      return false;
    }
    for (final entry in dir.listSync()) {
      if (entry is File) {
        if (entry.path.endsWith('test.dart')) {
          return true;
        }
      } else if (entry is Directory) {
        if (_hasAnyTestIn(entry)) {
          return true;
        }
      }
    }
    return false;
  }
}

abstract class Arguments {
  Arguments([List<String> arguments = const []]) {
    read(arguments);
  }

  static final _argRX = RegExp(r'([\w-]+)=?([\w-]+$)?');

  static const help = '--help';
  static const showOutput = '--show-output';

  final options = <String, String>{};
  final invalidArgs = [];

  List<String> get allOptions => [help, showOutput];

  bool get isValid => invalidArgs.isEmpty;
  bool get isNotValid => !isValid;

  bool get hasHelp => contains(help);
  bool get hasShowOutput => contains(showOutput);

  bool contains(String key) => options.containsKey(key);
  String operator [](String key) => options[key]!;

  void read(List<String> arguments) {
    for (final arg in arguments) {
      final entry = _parseArg(arg);
      if (entry != null && allOptions.contains(entry.key)) {
        options[arg] = entry.value;
      } else {
        invalidArgs.add(arg);
      }
    }
  }

  void printOptions([int padLeft = 6, int padRight = 30]) {
    _writeln('Global options:\n'
        '${' ' * padLeft}${help.padRight(30)} print usage.\n'
        '${' ' * padLeft}${showOutput.padRight(30)} show commands output.\n');
  }

  void printInvalidArgsForCommand(String command,
      [int padLeft = 6, int padRight = 30]) {
    if (invalidArgs.length == 1) {
      _writeln('Invalid option for $command command: "${invalidArgs.first}"\n');
    } else if (invalidArgs.length > 1) {
      _writeln('Invalid options dor $command command: "$invalidArgs"\n');
    }
  }

  MapEntry<String, String>? _parseArg(String arg) {
    final match = _argRX.firstMatch(arg);
    if (match == null) return null;
    final key = match.group(1)!;
    final value = match.group(2) ?? '';
    return MapEntry(key, value);
  }
}

class InitArguments extends Arguments {
  InitArguments([List<String> arguments = const []]) {
    read(arguments);
  }

  static const force = '--force';
  static const noBuild = '--no-build';

  bool get hasNoBuild => contains(noBuild);

  @override
  List<String> get allOptions => [
        ...super.allOptions,
        noBuild,
        force,
      ];

  @override
  void printOptions([int padLeft = 6, int padRight = 30]) {
    _writeln('Initializes the main project and all layer packages.\n'
        'Skips packages the have been initialized before (configurable).\n'
        'Runs a full build after each initialization (configurable>).\n');
    super.printOptions(padLeft, padRight);
    _writeln('Init options:\n'
        '${' ' * padLeft}${force.padRight(30)} force initialization even on already initilized packages.\n'
        '${' ' * padLeft}${noBuild.padRight(30)} do not build after init.\n');
  }
}

class CleanArguments extends Arguments {
  CleanArguments([List<String> arguments = const []]) {
    read(arguments);
  }

  static const noBuild = '--no-build';

  bool get hasNoBuild => contains(noBuild);

  @override
  List<String> get allOptions => [
        ...super.allOptions,
        noBuild,
      ];

  @override
  void printOptions([int padLeft = 6, int padRight = 30]) {
    _writeln('Cleans the main project and all layer packages.\n'
        'Runs a full build after each package clean (configurable>).\n');
    super.printOptions(padLeft, padRight);
    _writeln('Clean options:\n'
        '${' ' * padLeft}${noBuild.padRight(30)} do not build after cleanning.\n');
  }
}

class BuildArguments extends Arguments {
  BuildArguments([List<String> arguments = const []]) {
    read(arguments);
  }

  static const noPubGet = '--no-pub';
  static const noBuildRunner = '--no-build-runner';

  bool get hasNoPubGet => contains(noPubGet);
  bool get hasNoBuildRunner => contains(noBuildRunner);

  @override
  List<String> get allOptions => [
        ...super.allOptions,
        noPubGet,
        noBuildRunner,
      ];

  @override
  void printOptions([int padLeft = 6, int padRight = 30]) {
    _writeln('Builds the main project and all layer packages.\n');
    super.printOptions(padLeft, padRight);
    _writeln('Build options:\n'
        '${' ' * padLeft}${noPubGet.padRight(30)} do not run pub get.\n'
        '${' ' * padLeft}${noBuildRunner.padRight(30)} do not run build_runner.\n');
  }
}

class TestArguments extends Arguments {
  TestArguments([List<String> arguments = const []]) {
    read(arguments);
  }

  @override
  void printOptions([int padLeft = 6, int padRight = 30]) {
    _writeln(
        'Test the main project and all layer packages that have test cases.\n');
    super.printOptions(padLeft, padRight);
  }
}

class ExecutionOptions {
  const ExecutionOptions(
    this.args, {
    this.help = false,
    this.showOutput = false,
    this.init = false,
    this.clean = false,
    this.pubGet = false,
    this.buildRunner = false,
    this.test = false,
  });

  ExecutionOptions.forInit(InitArguments args)
      : this(
          args,
          help: args.hasHelp,
          showOutput: args.hasShowOutput,
          init: true,
          pubGet: !args.hasNoBuild,
          buildRunner: !args.hasNoBuild,
        );

  ExecutionOptions.forClean(CleanArguments args)
      : this(
          args,
          help: args.hasHelp,
          showOutput: args.hasShowOutput,
          clean: true,
          pubGet: !args.hasNoBuild,
          buildRunner: !args.hasNoBuild,
        );

  ExecutionOptions.forBuild(BuildArguments args)
      : this(
          args,
          help: args.hasHelp,
          showOutput: args.hasShowOutput,
          pubGet: !args.hasNoPubGet,
          buildRunner: !args.hasNoBuildRunner,
        );

  ExecutionOptions.forTest(TestArguments args)
      : this(
          args,
          help: args.hasHelp,
          showOutput: args.hasShowOutput,
          test: true,
        );

  final Arguments args;
  final bool help;
  final bool showOutput;
  final bool init;
  final bool clean;
  final bool pubGet;
  final bool buildRunner;
  final bool test;
}

class Execution {
  const Execution({required this.project, required this.options});

  final LayersProject project;
  final ExecutionOptions options;

  Future<bool> execute() async {
    for (final layer in project.layers) {
      if (!await _executeActions(layer)) {
        return false;
      }
    }
    return await _executeActions(project);
  }

  Future<bool> _executeActions(Package layer) async {
    if (options.init) {
      if (!await _init(layer)) {
        return false;
      }
      _cleanAfterInit(layer);
    }
    if (options.clean) {
      if (!await _clean(layer)) {
        return false;
      }
    }
    if (options.pubGet) {
      if (!await _pubGet(layer)) {
        return false;
      }
    }
    if (options.buildRunner) {
      if (!await _buildRunnerIfHasDependency(layer)) {
        return false;
      }
    }
    if (options.test) {
      await _test(layer);
    }
    return true;
  }

  static final _pubGetOutputRX = RegExp(r'([\d,\.]*\d+m?s)');
  static final _buildRunnerOutputRX =
      RegExp(r'([\d,\.]*\d+m?s with \d+ outputs \(\d+ actions\))');

  static final _testOutputRX = RegExp(r': (.* test.* passed!)');

  Future<bool> _init(Package layer) => _runIn(
        runOnParent: true,
        layer: layer,
        title: 'initializing flutter package',
        command: 'flutter',
        args: [
          'create',
          '--template=${layer.isMainProject ? 'app' : 'package'}',
          '--no-pub',
          layer.name,
        ],
      );

  Future<bool> _clean(Package layer) => _runIn(
        layer: layer,
        title: 'running flutter clean',
        command: 'flutter',
        args: ['clean'],
      );

  Future<bool> _pubGet(Package layer) => _runIn(
        layer: layer,
        title: 'running pub get',
        command: 'flutter',
        args: ['pub', 'get'],
        outputRX: _pubGetOutputRX,
      );

  Future<bool> _buildRunnerIfHasDependency(Package layer) {
    if (!layer.hasDependency('build_runner')) {
      return Future.value(true);
    }

    return _runIn(
      layer: layer,
      title: 'running build_runner',
      command: 'flutter',
      args: [
        'pub',
        'run',
        'build_runner',
        'build',
        '--delete-conflicting-outputs'
      ],
      outputRX: _buildRunnerOutputRX,
    );
  }

  Future<bool> _test(Package layer) {
    if (!layer.hasTestCases()) {
      return Future.value(true);
    }
    return _runIn(
      layer: layer,
      title: 'testing',
      command: 'flutter',
      args: ['test'],
      outputRX: _testOutputRX,
    );
  }

  Future<bool> _runIn({
    bool runOnParent = false,
    required Package layer,
    required String title,
    required String command,
    required List<String> args,
    RegExp? outputRX,
    bool skip = false,
  }) async {
    if (skip) {
      return true;
    }
    _write('${layer.description.padRight(Package.maxDescLength)} - $title:');
    late final ProcessResult result;
    final dir = runOnParent ? layer.dir.parent : layer.dir;
    try {
      result = await Process.run(
        command,
        args,
        workingDirectory: dir.path,
        runInShell: true,
      );
    } on ProcessException catch (e) {
      _showError(exception: e);
      return false;
    }
    if (result.exitCode != 0) {
      _showError(result: result);
      return false;
    }
    _write(' [OK]  ');

    if (outputRX != null) {
      final match = outputRX.firstMatch(result.stdout.toString());
      if (match != null && match.groupCount == 1) {
        _write(match.group(1));
      }
    }
    _writeln();

    if (options.showOutput) {
      _writeln(result.stdout.toString());
    }
    return true;
  }

  void _showError({ProcessResult? result, ProcessException? exception}) {
    late final String message;
    if (exception != null) {
      message = exception.message;
    } else if (result != null) {
      message = result.stderr.toString();
    } else {
      message = 'error in execution.';
    }
    final err = message.split('\n]');
    _write(' [!!] ');
    if (err.isNotEmpty) {
      _write(err.first);
    }
    _writeln();
    if (result != null) {
      _writeln(result.stdout.toString());
    }
  }

  void _cleanAfterInit(Package layer) {
    final dirPath = layer.dir.path;
    if (layer.isNotMainProject) {
      _tryRemove(dirPath + '/.gitignore', '${layer.name}/.gitignore');
    }
    if (layer.isMainProject) {
      _tryRemove(dirPath + '/test/widget_test.dart', 'test/widget_test.dart');
    } else {
      _tryRemove(dirPath + '/lib/${layer.name}.dart', 'lib/${layer.name}.dart');
      _tryRemove(dirPath + '/test/${layer.name}_test.dart',
          'test/${layer.name}_test.dart');
    }
  }

  void _tryRemove(String path, String fileTitle) {
    final file = File(path);
    if (file.existsSync()) {
      try {
        file.deleteSync();
      } on Exception {
        stdout.writeln('Could not remove file $fileTitle');
      }
    }
  }
}

void _write([String? s = '']) => stdout.write(s);
void _writeln([String? s = '']) => stdout.writeln(s);
