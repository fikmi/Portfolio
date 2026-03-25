import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:xml/xml.dart';

import '../models/incident.dart';
import '../models/requirement.dart';
import '../models/test_result.dart';

class ParserService {
  List<TestResult> parseTestResultsCsv(String csvText) {
    final rows = const CsvToListConverter(eol: '\n').convert(csvText);
    if (rows.isEmpty) return <TestResult>[];

    final dataRows = rows.skip(1);
    return dataRows
        .where((row) => row.isNotEmpty)
        .map(TestResult.fromCsvRow)
        .toList();
  }

  List<Incident> parseIncidentsJson(String jsonText) {
    final decoded = json.decode(jsonText);
    if (decoded is List) {
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Incident.fromJson)
          .toList();
    }

    if (decoded is Map<String, dynamic> && decoded['incidents'] is List) {
      return (decoded['incidents'] as List)
          .whereType<Map<String, dynamic>>()
          .map(Incident.fromJson)
          .toList();
    }

    return <Incident>[];
  }

  List<Requirement> parseRequirementsXml(String xmlText) {
    final document = XmlDocument.parse(xmlText);
    final requirementNodes = document.findAllElements('requirement');

    return requirementNodes.map((node) {
      return Requirement(
        id: node.getAttribute('id') ?? '',
        component: node.getAttribute('component') ?? 'Unknown',
        description: node.getElement('description')?.innerText ?? '',
      );
    }).toList();
  }
}
