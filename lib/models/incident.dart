class Incident {
  Incident({
    required this.id,
    required this.component,
    required this.severity,
    required this.summary,
  });

  final String id;
  final String component;
  final String severity;
  final String summary;

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id']?.toString() ?? '',
      component: json['component']?.toString() ?? 'Unknown',
      severity: json['severity']?.toString() ?? 'Medium',
      summary: json['summary']?.toString() ?? '',
    );
  }
}
