import 'package:flutter/material.dart';

class KnowledgeHubScreen extends StatelessWidget {
  const KnowledgeHubScreen({super.key});

  static const concepts = <Map<String, String>>[
    {
      'title': 'Test Pyramid',
      'description':
          'A strategy that emphasizes many unit tests, fewer integration tests, and minimal UI tests for fast and reliable feedback.',
    },
    {
      'title': 'Functional vs Non-functional testing',
      'description':
          'Functional testing verifies features and expected behavior, while non-functional testing checks performance, security, and reliability.',
    },
    {
      'title': 'Risk-based testing',
      'description':
          'Prioritize testing based on areas that have higher business impact and failure probability to optimize quality effort.',
    },
    {
      'title': 'DORA metrics',
      'description':
          'A set of engineering metrics including deployment frequency, lead time for changes, change failure rate, and mean time to restore.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Knowledge Hub')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: concepts.length,
        itemBuilder: (context, index) {
          final concept = concepts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(concept['title']!),
              subtitle: Text(concept['description']!),
            ),
          );
        },
      ),
    );
  }
}
