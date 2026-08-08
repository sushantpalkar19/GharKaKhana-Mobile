import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/user_provider.dart';
import '../widgets/mess_card.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Messes')),
      body: Consumer<UserProvider>(
        builder: (ctx, userProv, _) {
          if (userProv.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userProv.bookmarks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bookmarks_outlined, size: 80, color: Colors.grey[200]),
                    const SizedBox(height: 16),
                    Text('No saved messes yet', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    const Text(
                      'Tap the ❤️ on mess cards to save your favorites',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: userProv.bookmarks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (ctx, i) => MessCard(mess: userProv.bookmarks[i]),
          );
        },
      ),
    );
  }
}
