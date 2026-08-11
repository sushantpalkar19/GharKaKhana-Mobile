import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../providers/update_provider.dart';

class MandatoryUpdateScreen extends StatefulWidget {
  const MandatoryUpdateScreen({super.key});

  @override
  State<MandatoryUpdateScreen> createState() => _MandatoryUpdateScreenState();
}

class _MandatoryUpdateScreenState extends State<MandatoryUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Block back button
      child: Scaffold(
        body: SafeArea(
          child: Consumer<UpdateProvider>(
            builder: (context, updateProvider, _) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo/Icon
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.restaurant_menu,
                          size: 50,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // App Name
                      Text(
                        'GharKaKhana',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Update Icon
                      Icon(
                        Icons.system_update_alt,
                        size: 64,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        'New Update Available',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      // Message
                      Text(
                        'A new version of GharKaKhana is available. Please update the app to continue using GharKaKhana.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Version Info
                      if (updateProvider.appVersion != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            children: [
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
                                    updateProvider.currentVersionName ?? 'Unknown',
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
                                    updateProvider.appVersion!.latestVersion,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              // Release Date – only show if available
                              if (updateProvider.appVersion!.releaseDate != null) ...[
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
                                      _formatReleaseDate(updateProvider.appVersion!.releaseDate!),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Release Notes – only show if available and not empty
                        if (updateProvider.appVersion!.releaseNotes.isNotEmpty) ...[
                          _buildReleaseNotes(updateProvider.appVersion!.releaseNotes),
                          const SizedBox(height: 24),
                        ],
                      ],

                      // Download Progress or Update Button
                      if (updateProvider.isDownloading)
                        _buildDownloadProgress(updateProvider)
                      else if (updateProvider.isInstalling)
                        _buildInstallingState()
                      else if (updateProvider.hasError)
                        _buildErrorState(updateProvider)
                      else
                        _buildUpdateButton(updateProvider),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadProgress(UpdateProvider updateProvider) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'Downloading update...',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: updateProvider.downloadProgress,
          backgroundColor: AppColors.border,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(
          '${(updateProvider.downloadProgress * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInstallingState() {
    return Column(
      children: [
        const SizedBox(height: 16),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
        const SizedBox(height: 16),
        Text(
          'Installing update...',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(UpdateProvider updateProvider) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Icon(
          Icons.error_outline,
          size: 48,
          color: AppColors.error,
        ),
        const SizedBox(height: 16),
        Text(
          'Unable to download update.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Please check your internet connection and try again.',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (updateProvider.appVersion != null) {
                updateProvider.downloadUpdate(updateProvider.appVersion!.downloadUrl);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton(UpdateProvider updateProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (updateProvider.appVersion != null) {
            updateProvider.downloadUpdate(updateProvider.appVersion!.downloadUrl);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'UPDATE NOW',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  String _formatReleaseDate(DateTime date) {
    try {
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return 'Unknown';
    }
  }

  Widget _buildReleaseNotes(List<String> releaseNotes) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What\'s New',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          ...releaseNotes.map((note) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '✓ ',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  child: Text(
                    note,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
