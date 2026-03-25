import '../models/component_model.dart';

class RiskEngine {
  static double calculateRisk({
    required int incidentCount,
    required int businessCriticality,
    required double testCoverage,
  }) {
    return (incidentCount * businessCriticality) / (testCoverage <= 0 ? 1 : testCoverage);
  }

  static List<ComponentModel> buildComponents({
    required Map<String, int> incidentCountByComponent,
    required Map<String, double> testCoverageByComponent,
    required Map<String, int> criticalityByComponent,
  }) {
    final componentNames = <String>{
      ...incidentCountByComponent.keys,
      ...testCoverageByComponent.keys,
      ...criticalityByComponent.keys,
    };

    final components = componentNames.map((name) {
      final incidents = incidentCountByComponent[name] ?? 0;
      final coverage = testCoverageByComponent[name] ?? 0;
      final criticality = criticalityByComponent[name] ?? 3;

      return ComponentModel(
        name: name,
        incidentCount: incidents,
        testCoverage: coverage,
        businessCriticality: criticality,
        riskScore: calculateRisk(
          incidentCount: incidents,
          businessCriticality: criticality,
          testCoverage: coverage,
        ),
      );
    }).toList();

    components.sort((a, b) => b.riskScore.compareTo(a.riskScore));
    return components;
  }
}
