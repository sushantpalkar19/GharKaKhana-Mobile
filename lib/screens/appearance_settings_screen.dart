import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/theme_settings.dart';
import '../providers/theme_provider.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Appearance'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Live Preview Section
              _buildPreviewSection(context, themeProvider),
              const SizedBox(height: 24),
              
              // Theme Mode Section
              _buildSectionTitle('Theme Mode'),
              const SizedBox(height: 12),
              _buildThemeModeSelector(context, themeProvider),
              const SizedBox(height: 24),
              
              // Theme Pack Section
              _buildSectionTitle('Theme Pack'),
              const SizedBox(height: 12),
              _buildThemePackSelector(context, themeProvider),
              const SizedBox(height: 24),
              
              // Gradient Toggle Section
              _buildSectionTitle('Gradient'),
              const SizedBox(height: 12),
              _buildGradientToggle(context, themeProvider),
              const SizedBox(height: 24),
              
              // Restore Default Button
              _buildRestoreDefaultButton(context, themeProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPreviewSection(BuildContext context, ThemeProvider themeProvider) {
    final themeExtension = AppThemeExtension.of(context);
    final gradient = themeExtension.gradient;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preview',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Preview AppBar
            Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: themeProvider.settings.gradientEnabled ? gradient : null,
                color: themeProvider.settings.gradientEnabled 
                    ? null 
                    : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'App Bar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Preview Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.settings.gradientEnabled 
                      ? null 
                      : Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Primary Button'),
              ),
            ),
            const SizedBox(height: 12),
            
            // Preview Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card Title',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Card content preview',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Preview Bottom Navigation
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, true, context),
                  _buildNavItem(Icons.search, false, context),
                  _buildNavItem(Icons.bookmark, false, context),
                  _buildNavItem(Icons.person, false, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isSelected, BuildContext context) {
    return Icon(
      icon,
      color: isSelected 
          ? Theme.of(context).colorScheme.primary 
          : Theme.of(context).colorScheme.onSurfaceVariant,
      size: 24,
    );
  }

  Widget _buildThemeModeSelector(BuildContext context, ThemeProvider themeProvider) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          _buildThemeModeOption(
            context,
            title: 'Light',
            icon: Icons.light_mode,
            value: ThemeModeEnum.light,
            groupValue: themeProvider.settings.themeMode,
            themeProvider: themeProvider,
          ),
          const Divider(height: 1),
          _buildThemeModeOption(
            context,
            title: 'Dark',
            icon: Icons.dark_mode,
            value: ThemeModeEnum.dark,
            groupValue: themeProvider.settings.themeMode,
            themeProvider: themeProvider,
          ),
          const Divider(height: 1),
          _buildThemeModeOption(
            context,
            title: 'AMOLED Black',
            icon: Icons.brightness_4,
            value: ThemeModeEnum.amoled,
            groupValue: themeProvider.settings.themeMode,
            themeProvider: themeProvider,
          ),
          const Divider(height: 1),
          _buildThemeModeOption(
            context,
            title: 'System',
            icon: Icons.brightness_auto,
            value: ThemeModeEnum.system,
            groupValue: themeProvider.settings.themeMode,
            themeProvider: themeProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeModeOption(
    BuildContext context,
    {required String title,
    required IconData icon,
    required ThemeModeEnum value,
    required ThemeModeEnum groupValue,
    required ThemeProvider themeProvider}
  ) {
    final isSelected = value == groupValue;
    
    return InkWell(
      onTap: () => themeProvider.setThemeMode(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary 
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemePackSelector(BuildContext context, ThemeProvider themeProvider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: ThemePack.packs.length,
      itemBuilder: (context, index) {
        final packEnum = ThemePack.packs.keys.elementAt(index);
        final pack = ThemePack.packs[packEnum]!;
        final isSelected = themeProvider.settings.themePack == packEnum;
        
        return _buildThemePackCard(
          context,
          pack,
          packEnum,
          isSelected,
          themeProvider,
        );
      },
    );
  }

  Widget _buildThemePackCard(
    BuildContext context,
    ThemePack pack,
    ThemePackEnum packEnum,
    bool isSelected,
    ThemeProvider themeProvider,
  ) {
    return InkWell(
      onTap: () => themeProvider.setThemePack(packEnum),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: pack.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? pack.primary 
                : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        pack.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          pack.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Color preview dots
                  Row(
                    children: [
                      _buildColorDot(pack.primary),
                      const SizedBox(width: 6),
                      _buildColorDot(pack.secondary),
                      const SizedBox(width: 6),
                      _buildColorDot(pack.button),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.check_circle,
                  color: pack.primary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorDot(Color color) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
    );
  }

  Widget _buildGradientToggle(BuildContext context, ThemeProvider themeProvider) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: SwitchListTile(
        title: const Text('Enable Gradients'),
        subtitle: const Text('Apply gradients to premium sections'),
        value: themeProvider.settings.gradientEnabled,
        onChanged: (value) => themeProvider.setGradientEnabled(value),
        activeThumbColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildRestoreDefaultButton(BuildContext context, ThemeProvider themeProvider) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Restore Default Theme'),
              content: const Text('This will reset all theme settings to default. Are you sure?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    themeProvider.restoreDefault();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Theme restored to default')),
                    );
                  },
                  child: const Text('Restore'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.restore),
        label: const Text('Restore Default Theme'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
