import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/component_model.dart';
import '../services/app_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool showStrategy = false;

  @override
  Widget build(BuildContext context) {
    final components = context.watch<AppState>().components;

    return Scaffold(
      appBar: AppBar(title: const Text('Risk Dashboard')),
      body: components.isEmpty
          ? const Center(
              child: Text('No data loaded. Go to Upload Data and add files.'),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () => setState(() => showStrategy = !showStrategy),
                    icon: const Icon(Icons.auto_graph),
                    label: Text(
                      showStrategy ? 'Hide Strategy' : 'Generate Strategy',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...components.map(
                  (component) => _ComponentCard(
                    component: component,
                    showRecommendation: showStrategy,
                  ),
                ),
              ],
            ),
    );
  }
}

class _ComponentCard extends StatelessWidget {
  const _ComponentCard({
    required this.component,
    required this.showRecommendation,
  });

  final ComponentModel component;
  final bool showRecommendation;

  @override
  Widget build(BuildContext context) {
    final coverage = component.testCoverage.clamp(0, 100).toDouble();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(component.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Risk Score: ${component.riskScore.toStringAsFixed(2)}'),
            Text('Incident Count: ${component.incidentCount}'),
            Text('Test Coverage: ${component.testCoverage.toStringAsFixed(1)}%'),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 110, child: Text('Coverage Chart')),
                Expanded(
                  child: LinearProgressIndicator(
                    value: coverage / 100,
                    minHeight: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 110, child: Text('Risk Chart')),
                Expanded(
                  child: LinearProgressIndicator(
                    value: (component.riskScore.clamp(0, 100)) / 100,
                    minHeight: 10,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            if (showRecommendation) ...[
              const Divider(height: 20),
              Text(
                component.recommendation,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
