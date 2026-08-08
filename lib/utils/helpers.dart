import 'package:flutter/material.dart';
import '../core/theme.dart';

String formatRupee(dynamic amount) {
  final a = amount is num ? amount : num.tryParse(amount.toString()) ?? 0;
  return '₹${a.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
}

String formatDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return 'N/A';
  return dateStr;
}

String truncate(String text, int maxLength) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength)}...';
}

Color statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'active':
      return AppColors.success;
    case 'paused':
      return AppColors.warning;
    case 'expired':
      return AppColors.error;
    case 'delivered':
      return AppColors.secondary;
    case 'upcoming':
      return AppColors.primary;
    default:
      return AppColors.textSecondary;
  }
}
