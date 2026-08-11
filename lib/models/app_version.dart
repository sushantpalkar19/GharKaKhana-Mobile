class AppVersion {
  final String latestVersion;
  final String minimumSupportedVersion;
  final int latestVersionCode;
  final int minimumVersionCode;
  final int buildNumber;
  final bool forceUpdate;
  final bool maintenanceMode;
  final String maintenanceMessage;
  final String? downloadSize;
  final String downloadUrl;
  final List<String> releaseNotes;
  final DateTime? releaseDate;
  final DateTime publishedAt;

  AppVersion({
    required this.latestVersion,
    required this.minimumSupportedVersion,
    required this.latestVersionCode,
    required this.minimumVersionCode,
    required this.buildNumber,
    required this.forceUpdate,
    required this.maintenanceMode,
    required this.maintenanceMessage,
    this.downloadSize,
    required this.downloadUrl,
    required this.releaseNotes,
    this.releaseDate,
    required this.publishedAt,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      latestVersion: json['latestVersion'] as String? ?? '',
      minimumSupportedVersion: json['minimumSupportedVersion'] as String? ?? '',
      latestVersionCode: json['latestVersionCode'] as int? ?? 0,
      minimumVersionCode: json['minimumVersionCode'] as int? ?? 0,
      buildNumber: json['buildNumber'] as int? ?? 0,
      forceUpdate: json['forceUpdate'] as bool? ?? false,
      maintenanceMode: json['maintenanceMode'] as bool? ?? false,
      maintenanceMessage: json['maintenanceMessage'] as String? ?? 'We are currently performing maintenance. Please try again later.',
      downloadSize: json['downloadSize'] as String?,
      downloadUrl: json['downloadUrl'] as String? ?? '',
      releaseNotes: (json['releaseNotes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      releaseDate: json['releaseDate'] != null
          ? DateTime.tryParse(json['releaseDate'] as String)
          : null,
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latestVersion': latestVersion,
      'minimumSupportedVersion': minimumSupportedVersion,
      'latestVersionCode': latestVersionCode,
      'minimumVersionCode': minimumVersionCode,
      'buildNumber': buildNumber,
      'forceUpdate': forceUpdate,
      'maintenanceMode': maintenanceMode,
      'maintenanceMessage': maintenanceMessage,
      if (downloadSize != null) 'downloadSize': downloadSize,
      'downloadUrl': downloadUrl,
      'releaseNotes': releaseNotes,
      if (releaseDate != null) 'releaseDate': releaseDate!.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
    };
  }
}
