class Report {
  final String? summary;
  final Map<String, dynamic>? details;

  Report({
    this.summary,
    this.details,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      summary: json['summary'] as String?,
      details: json['details'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'details': details,
    };
  }
}
