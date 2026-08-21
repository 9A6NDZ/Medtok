import 'package:flutter/material.dart';

import '../../../core/localization/gen/app_localizations.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.calendarTitle)),
      body: Center(child: Text(l10n.calendarTitle)),
    );
  }
}
