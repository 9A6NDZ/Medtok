import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/gen/app_localizations.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import 'providers.dart';

class MedTokApp extends ConsumerStatefulWidget {
  const MedTokApp({super.key});

  @override
  ConsumerState<MedTokApp> createState() => _MedTokAppState();
}

class _MedTokAppState extends ConsumerState<MedTokApp> {
  late final _router = createRouter();

  @override
  Widget build(BuildContext context) {
    final themeMode =
        ref.watch(themeModeProvider).valueOrNull ?? ThemeMode.system;
    final locale = ref.watch(localeProvider).valueOrNull;

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
