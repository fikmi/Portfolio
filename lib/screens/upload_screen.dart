import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  Future<void> _pickAndLoadFile({
    required BuildContext context,
    required List<String> allowedExtensions,
    required Future<void> Function(Uint8List bytes) onLoad,
    required String successLabel,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      withData: true,
    );

    if (result == null || result.files.single.bytes == null) {
      return;
    }

    await onLoad(result.files.single.bytes!);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$successLabel loaded successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Data')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Upload CSV (test results)'),
              subtitle: const Text('Columns: test_name, component, status'),
              trailing: const Icon(Icons.upload_file),
              onTap: () => _pickAndLoadFile(
                context: context,
                allowedExtensions: const ['csv'],
                onLoad: (bytes) => context.read<AppState>().loadCsvFromBytes(bytes),
                successLabel: 'CSV file',
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Upload JSON (incidents)'),
              subtitle: const Text('Expected: list of incident objects'),
              trailing: const Icon(Icons.upload_file),
              onTap: () => _pickAndLoadFile(
                context: context,
                allowedExtensions: const ['json'],
                onLoad: (bytes) => context.read<AppState>().loadJsonFromBytes(bytes),
                successLabel: 'JSON file',
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Upload XML (requirements)'),
              subtitle: const Text('Expected: <requirements><requirement .../>'),
              trailing: const Icon(Icons.upload_file),
              onTap: () => _pickAndLoadFile(
                context: context,
                allowedExtensions: const ['xml'],
                onLoad: (bytes) => context.read<AppState>().loadXmlFromBytes(bytes),
                successLabel: 'XML file',
              ),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => context.read<AppState>().loadSampleData(),
            icon: const Icon(Icons.data_array),
            label: const Text('Load Sample Data'),
          ),
          const SizedBox(height: 20),
          Text('Loaded test results: ${state.testResults.length}'),
          Text('Loaded incidents: ${state.incidents.length}'),
          Text('Loaded requirements: ${state.requirements.length}'),
        ],
      ),
    );
  }
}
