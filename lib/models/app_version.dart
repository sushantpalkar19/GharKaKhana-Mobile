class AppVersion {
  final String latestVersion;
  final String minimumSupportedVersion;
  final int buildNumber;
  final bool forceUpdate;
  final bool maintenanceMode;
  final String maintenanceMessage;
  final String? downloadSize;
  final List<String> releaseNotes;
  final DateTime releaseDate;
  final DateTime publishedAt;

  AppVersion({
    required this.latestVersion,
    required this.minimumSupportedVersion,
    required this.buildNumber,
    required this.forceUpdate,
    required this.maintenanceMode,
    required this.maintenanceMessage,
    this.downloadSize,
    required this.releaseNotes,
    required this.releaseDate,
    required this.publishedAt,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      latestVersion: json['latestVersion'] as String? ?? '',
      minimumSupportedVersion: json['minimumSupportedVersion'] as String? ?? '',
      buildNumber: json['buildNumber'] as int? ?? 0,
      forceUpdate: json['forceUpdate'] as bool? ?? false,
      maintenanceMode: json['maintenanceMode'] as bool? ?? false,
      maintenanceMessage: json['maintenanceMessage'] as String? ?? 'We are currently performing maintenance. Please try again later.',
      downloadSize: json['downloadSize'] as String?,
      releaseNotes: (json['releaseNotes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      releaseDate: json['releaseDate'] != null
          ? DateTime.tryParse(json['releaseDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latestVersion': latestVersion,
      'minimumSupportedVersion': minimumSupportedVersion,
      'buildNumber': buildNumber,
      'forceUpdate': forceUpdate,
      'maintenanceMode': maintenanceMode,
      'maintenanceMessage': maintenanceMessage,
      if (downloadSize != null) 'downloadSize': downloadSize,
      'releaseNotes': releaseNotes,
      'releaseDate': releaseDate.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
    };
  }
}
