import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/localization/gen/app_localizations.dart';
import '../../../core/theme/app_tokens.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.watch(settingsControllerProvider);
    final themeMode =
        ref.watch(themeModeProvider).valueOrNull ?? ThemeMode.system;
    final locale = ref.watch(localeProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppTokens.space4),
        children: [
          Text(l10n.settingsAppearance,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppTokens.space2),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.light,
                label: Text(l10n.settingsThemeLight),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text(l10n.settingsThemeDark),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                label: Text(l10n.settingsThemeSystem),
              ),
            ],
            selected: {themeMode},
            onSelectionChanged: (s) => controller.setThemeMode(s.first),
          ),
          const SizedBox(height: AppTokens.space5),
          Text(l10n.settingsLanguage,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppTokens.space2),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'hr', label: Text('Hrvatski')),
              ButtonSegment(value: 'en', label: Text('English')),
              ButtonSegment(value: 'system', label: Text('Auto')),
            ],
            selected: {locale?.languageCode ?? 'system'},
            onSelectionChanged: (s) => controller.setLocale(
              s.first == 'system' ? null : s.first,
            ),
          ),
          const SizedBox(height: AppTokens.space6),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.space4),
              child: Row(
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(width: AppTokens.space3),
                  Expanded(
                    child: Text(
                      l10n.medicalDisclaimer,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
