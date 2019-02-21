part of codemetrics.reporter;

class PrintFReporter implements AnalysisReporter {
  final AnalysisRunner analysisRunner;
  final int beginWarningComplexityNumber;
  final int beginErrorComplexityNumber;

  bool isPrintAll;

  PrintFReporter(this.analysisRunner, this.beginWarningComplexityNumber,
      this.beginErrorComplexityNumber, this.isPrintAll);

  bool _isErrorMustBePrint(int complexity, int warningBegin, int errorBegin) {
    if (complexity >= errorBegin) return true;
    return false;
  }

  bool _isWarningMustBePrint(int complexity, int warningBegin, int errorBegin) {
    if (complexity >= warningBegin && complexity <= errorBegin) return true;
    return false;
  }

  Future<StringBuffer> getReport() async {
    final filesWithCallbalesMethods = analysisRunner.getResults();

    final buf = StringBuffer();

    for (Map fileData in filesWithCallbalesMethods) {
      final filePath = fileData.keys.first;
      final List<String> callables = fileData[filePath]['callables'];

      final lines = <String>[];

      for (String callable in callables) {
        final int complexity = fileData[filePath][callable];

        bool isError = _isErrorMustBePrint(complexity,
            beginWarningComplexityNumber, beginErrorComplexityNumber);

        bool isWarning = _isWarningMustBePrint(complexity,
            beginWarningComplexityNumber, beginErrorComplexityNumber);

        if (isError != isWarning) {
          if (isError) {
            lines.add('    $callable - $complexity - ERROR');
          }

          if (isWarning) {
            lines.add('    $callable - $complexity - WARNING');
          }
        } else {
          if (isPrintAll) lines.add('    $callable - $complexity');
        }
      }

      if (isPrintAll) {
        buf.writeln(filePath);
        for (String line in lines) {
          buf.writeln(line);
        }

        buf.writeln();
      } else {
        if (lines.isNotEmpty) {
          buf.writeln(filePath);
          for (String line in lines) {
            buf.writeln(line);
          }

          buf.writeln();
        }
      }
    }

    return buf;
  }
}
