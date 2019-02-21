import 'package:codemetrics/codemetrics.dart';
import 'package:glob/glob.dart';
import 'dart:io';
import 'package:args/args.dart';

const List<String> IGNORED_PATH_PARTS = const ['.pub', 'packages'];

main(List<String> args) {
  var parser = new ArgParser();
  parser.addOption('report-format',
      allowed: ['html', 'js', 'printf'],
      defaultsTo: 'printf',
      help: 'The format of the output of the analysis');
  parser.addOption('analysis-root',
      defaultsTo: './',
      help: 'Root path from which all dart files will be analyzed');

  parser.addOption('begin-warning-complexity-number', defaultsTo: '0');
  parser.addOption('begin-error-complexity-number', defaultsTo: '0');
  parser.addOption('print-all', defaultsTo: 'false');

  var arguments = parser.parse(args);

  var dartFiles = new Glob('**.dart')
      .listSync(root: arguments['analysis-root'], followLinks: false);
  dartFiles.removeWhere((FileSystemEntity entity) {
    if (entity is! File) return true;
    if (entity is File) {
      for (String ignoredPathPart in IGNORED_PATH_PARTS) {
        if (entity.path.contains(ignoredPathPart)) return true;
      }
    }
    return false;
  });

  var dartFilePaths = dartFiles
      .map((FileSystemEntity entity) => entity.path)
      .toList(growable: false);
  var recorder = new CyclomaticAnalysisRecorder();
  var analyzer = new CyclomaticAnalyzer();

  CyclomaticAnalysisRunner runner =
      new CyclomaticAnalysisRunner(recorder, analyzer, dartFilePaths);
  runner.run();
  AnalysisReporter reporter;
  switch (arguments['report-format']) {
    case 'html':
      reporter = new HtmlReporter(runner);
      break;
    case 'js':
      reporter = new JsonReporter(runner);
      break;
    case 'printf':
      reporter = new PrintFReporter(
          runner,
          int.parse(arguments['begin-warning-complexity-number']),
          int.parse(arguments['begin-error-complexity-number']),
          arguments['print-all'] == 'true' ? true : false);
      break;
    default:
      throw new ArgumentError.value(
          arguments['report-format'], 'report-format');
  }
  reporter.getReport().then(stdout.write);
}
