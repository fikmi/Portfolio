class ComponentModel {
  ComponentModel({
    required this.name,
    required this.incidentCount,
    required this.testCoverage,
    required this.businessCriticality,
    required this.riskScore,
  });

  final String name;
  final int incidentCount;
  final double testCoverage;
  final int businessCriticality;
  final double riskScore;

  String get recommendation {
    if (riskScore > 50) {
      return 'High risk: Add E2E and performance tests';
    }
    if (riskScore >= 20) {
      return 'Medium risk: Improve integration tests';
    }
    return 'Low risk: Maintain current strategy';
  }
}
