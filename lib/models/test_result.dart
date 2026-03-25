class TestResult {
  TestResult({
    required this.testName,
    required this.component,
    required this.status,
  });

  final String testName;
  final String component;
  final String status;

  bool get isPassed => status.toLowerCase() == 'pass';

  factory TestResult.fromCsvRow(List<dynamic> row) {
    return TestResult(
      testName: row.isNotEmpty ? row[0].toString() : '',
      component: row.length > 1 ? row[1].toString() : 'Unknown',
      status: row.length > 2 ? row[2].toString() : 'fail',
    );
  }
}
