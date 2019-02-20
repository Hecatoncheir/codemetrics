part of codemetrics.reporter;

class PrintFReporter implements AnalysisReporter {
  PrintFReporter(this.analysisRunner);

  Future<StringBuffer> getReport() async {
    return new StringBuffer(json.encode(analysisRunner.getResults()));
  }

  final AnalysisRunner analysisRunner;
}
