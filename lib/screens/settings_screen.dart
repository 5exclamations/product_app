import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final loc = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Тема
        Card(
          child: ListTile(
            leading: const Icon(Icons.palette),
            title: Text(loc.translate('theme')),
            subtitle: Text(_getThemeModeName(settingsProvider.themeMode, loc)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showThemeDialog(context, settingsProvider, loc),
          ),
        ),

        const SizedBox(height: 8),

        // Язык
        Card(
          child: ListTile(
            leading: const Icon(Icons.language),
            title: Text(loc.translate('language')),
            subtitle: Text(_getLanguageName(settingsProvider.locale)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showLanguageDialog(context, settingsProvider),
          ),
        ),

        const SizedBox(height: 24),

        // О приложении
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          subtitle: const Text('Market Price Tracker v1.0.0'),
        ),
      ],
    );
  }

  String _getThemeModeName(ThemeMode mode, AppLocalizations loc) {
    switch (mode) {
      case ThemeMode.light:
        return loc.translate('light');
      case ThemeMode.dark:
        return loc.translate('dark');
      case ThemeMode.system:
        return loc.translate('system');
    }
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      case 'az':
        return 'Azərbaycan';
      default:
        return locale.languageCode;
    }
  }

  void _showThemeDialog(
      BuildContext context,
      SettingsProvider provider,
      AppLocalizations loc,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.translate('theme')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: Text(loc.translate('light')),
                value: ThemeMode.light,
                groupValue: provider.themeMode,
                onChanged: (value) {
                  provider.setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text(loc.translate('dark')),
                value: ThemeMode.dark,
                groupValue: provider.themeMode,
                onChanged: (value) {
                  provider.setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text(loc.translate('system')),
                value: ThemeMode.system,
                groupValue: provider.themeMode,
                onChanged: (value) {
                  provider.setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Language / Язык / Dil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('English'),
                value: 'en',
                groupValue: provider.locale.languageCode,
                onChanged: (value) {
                  provider.setLocale(Locale(value!));
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('Русский'),
                value: 'ru',
                groupValue: provider.locale.languageCode,
                onChanged: (value) {
                  provider.setLocale(Locale(value!));
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('Azərbaycan'),
                value: 'az',
                groupValue: provider.locale.languageCode,
                onChanged: (value) {
                  provider.setLocale(Locale(value!));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
