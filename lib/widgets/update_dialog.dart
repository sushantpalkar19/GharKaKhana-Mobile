import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../models/app_version.dart';

class UpdateDialog extends StatelessWidget {
  final AppVersion appVersion;
  final String currentVersion;
  final bool forceUpdate;
  final VoidCallback onUpdateNow;
  final VoidCallback onLater;

  const UpdateDialog({
    super.key,
    required this.appVersion,
    required this.currentVersion,
    required this.forceUpdate,
    required this.onUpdateNow,
    required this.onLater,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.system_update,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              forceUpdate ? 'Update Required' : 'Update Available',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Version',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  currentVersion,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Version',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  appVersion.latestVersion,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            if (appVersion.downloadSize != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Download Size',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    appVersion.downloadSize!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
            if (appVersion.releaseDate != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Released',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    _formatReleaseDate(appVersion.releaseDate!),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            // Only show "What's New" if there are release notes
            if (appVersion.releaseNotes.isNotEmpty) ...[
              const Text(
                'What\'s New',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              ...appVersion.releaseNotes.map((note) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    Expanded(
                      child: Text(
                        note,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
      actions: [
        if (!forceUpdate)
          TextButton(
            onPressed: onLater,
            child: const Text('Later'),
          ),
        ElevatedButton(
          onPressed: onUpdateNow,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Update Now'),
        ),
      ],
    );
  }

  String _formatReleaseDate(DateTime date) {
    try {
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return 'Unknown';
    }
  }
}
