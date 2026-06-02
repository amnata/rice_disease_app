class ResultModel {
  final bool success;
  final double severityPercent;
  final int severityLevel;
  final String severityLevelName;
  final String recommendation;
  final String colorCode;
  final String maskBase64;
  final String? overlayBase64;
  final double processingTime;

  ResultModel({
    this.success = true,
    required this.severityPercent,
    required this.severityLevel,
    required this.severityLevelName,
    required this.recommendation,
    required this.colorCode,
    required this.maskBase64,
    this.overlayBase64,
    required this.processingTime,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      success: json['success'] ?? true,
      severityPercent: (json['severity_percent'] ?? 0.0).toDouble(),
      severityLevel: json['severity_level'] ?? 0,
      severityLevelName: json['severity_level_name'] ?? "Inconnu",
      recommendation: json['recommendation'] ?? "Aucune recommandation",
      colorCode: json['color_code'] ?? "#9E9E9E",
      maskBase64: json['mask_base64'] ?? "",
      overlayBase64: json['overlay_base64'],
      processingTime: (json['processing_time'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'severity_percent': severityPercent,
      'severity_level': severityLevel,
      'severity_level_name': severityLevelName,
      'recommendation': recommendation,
      'color_code': colorCode,
      'mask_base64': maskBase64,
      'overlay_base64': overlayBase64,
      'processing_time': processingTime,
    };
  }
}
