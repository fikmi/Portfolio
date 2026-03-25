import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/component_model.dart';
import '../models/incident.dart';
import '../models/requirement.dart';
import '../models/test_result.dart';
import 'parser_service.dart';
import 'risk_engine.dart';

class AppState extends ChangeNotifier {
  final ParserService _parser = ParserService();

  List<TestResult> _testResults = <TestResult>[];
  List<Incident> _incidents = <Incident>[];
  List<Requirement> _requirements = <Requirement>[];
  List<ComponentModel> _components = <ComponentModel>[];

  List<TestResult> get testResults => _testResults;
  List<Incident> get incidents => _incidents;
  List<Requirement> get requirements => _requirements;
  List<ComponentModel> get components => _components;

  final Map<String, int> _criticalityMap = <String, int>{
    'Payment': 5,
    'Login': 4,
    'Search': 3,
    'Profile': 2,
    'Checkout': 5,
  };

  Future<void> loadCsvFromBytes(Uint8List bytes) async {
    final csvText = String.fromCharCodes(bytes);
    _testResults = _parser.parseTestResultsCsv(csvText);
    _recalculate();
  }

  Future<void> loadJsonFromBytes(Uint8List bytes) async {
    final jsonText = String.fromCharCodes(bytes);
    _incidents = _parser.parseIncidentsJson(jsonText);
    _recalculate();
  }

  Future<void> loadXmlFromBytes(Uint8List bytes) async {
    final xmlText = String.fromCharCodes(bytes);
    _requirements = _parser.parseRequirementsXml(xmlText);
    notifyListeners();
  }

  void loadSampleData() {
    const sampleCsv = '''test_name,component,status
Pay-Card-Validation,Payment,pass
Pay-Wallet,Payment,fail
Login-OTP,Login,pass
Login-Password,Login,pass
Search-Filter,Search,pass
Search-Sort,Search,fail
''';

    const sampleJson = '''[
  {"id":"INC-1001","component":"Payment","severity":"High","summary":"Timeout during payment"},
  {"id":"INC-1002","component":"Payment","severity":"Medium","summary":"Incorrect currency mapping"},
  {"id":"INC-1003","component":"Login","severity":"High","summary":"OAuth token expired"},
  {"id":"INC-1004","component":"Search","severity":"Low","summary":"Slow search query"}
]''';

    const sampleXml = '''<requirements>
  <requirement id="REQ-1" component="Payment"><description>Support multiple cards</description></requirement>
  <requirement id="REQ-2" component="Login"><description>Enable SSO</description></requirement>
  <requirement id="REQ-3" component="Search"><description>Search by tags</description></requirement>
</requirements>''';

    _testResults = _parser.parseTestResultsCsv(sampleCsv);
    _incidents = _parser.parseIncidentsJson(sampleJson);
    _requirements = _parser.parseRequirementsXml(sampleXml);
    _recalculate();
  }

  void _recalculate() {
    final incidentCounts = <String, int>{};
    for (final incident in _incidents) {
      incidentCounts.update(
        incident.component,
        (existing) => existing + 1,
        ifAbsent: () => 1,
      );
    }

    final totalByComponent = <String, int>{};
    final passedByComponent = <String, int>{};

    for (final result in _testResults) {
      totalByComponent.update(result.component, (existing) => existing + 1,
          ifAbsent: () => 1);
      if (result.isPassed) {
        passedByComponent.update(result.component, (existing) => existing + 1,
            ifAbsent: () => 1);
      }
    }

    final coverageByComponent = <String, double>{};
    for (final entry in totalByComponent.entries) {
      final passed = passedByComponent[entry.key] ?? 0;
      final coveragePercent = entry.value == 0 ? 0 : (passed / entry.value) * 100;
      coverageByComponent[entry.key] = coveragePercent;
    }

    _components = RiskEngine.buildComponents(
      incidentCountByComponent: incidentCounts,
      testCoverageByComponent: coverageByComponent,
      criticalityByComponent: _criticalityMap,
    );

    notifyListeners();
  }
}
