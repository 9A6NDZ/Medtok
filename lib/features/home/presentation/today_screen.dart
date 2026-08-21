import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/database/enums.dart';
import '../../../core/localization/gen/app_localizations.dart';
import '../../../core/theme/app_tokens.dart';

/// Streams today's doses (local day boundaries) from the database.
final _todayDosesProvider = StreamProvider.autoDispose((ref) {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start.add(const Duration(days: 1));
  return ref.watch(medicationDaoProvider).watchDosesBetween(start, end);
});

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final doses = ref.watch(_todayDosesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.todayTitle)),
      body: doses.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const _ErrorView(),
        data: (list) {
          if (list.isEmpty) {
            return Center(child: Text(l10n.todayEmpty));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppTokens.space4),
            itemCount: list.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppTokens.space3),
            itemBuilder: (context, i) {
              final dose = list[i];
              return _DoseCard(
                doseId: dose.id,
                plannedTime: dose.plannedTime,
                amount: dose.amount,
                status: dose.status,
                onTaken: () => ref.read(medicationDaoProvider).setDoseStatus(
                      dose.id,
                      DoseStatus.taken,
                      actualTime: DateTime.now(),
                    ),
                onSnooze: () => ref
                    .read(medicationDaoProvider)
                    .setDoseStatus(dose.id, DoseStatus.snoozed),
                onSkip: () => ref
                    .read(medicationDaoProvider)
                    .setDoseStatus(dose.id, DoseStatus.skipped),
              );
            },
          );
        },
      ),
    );
  }
}

class _DoseCard extends StatelessWidget {
  const _DoseCard({
    required this.doseId,
    required this.plannedTime,
    required this.amount,
    required this.status,
    required this.onTaken,
    required this.onSnooze,
    required this.onSkip,
  });

  final String doseId;
  final DateTime plannedTime;
  final double amount;
  final DoseStatus status;
  final VoidCallback onTaken;
  final VoidCallback onSnooze;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final time = TimeOfDay.fromDateTime(plannedTime.toLocal());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  time.format(context),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                _StatusChip(status: status),
              ],
            ),
            const SizedBox(height: AppTokens.space2),
            Text('${amount.toStringAsFixed(amount % 1 == 0 ? 0 : 1)} '
                '${l10n.unitTablet}'),
            if (status == DoseStatus.pending) ...[
              const SizedBox(height: AppTokens.space3),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: onTaken,
                      child: Text(l10n.doseTaken),
                    ),
                  ),
                  const SizedBox(width: AppTokens.space2),
                  OutlinedButton(
                    onPressed: onSnooze,
                    child: Text(l10n.doseSnooze),
                  ),
                  const SizedBox(width: AppTokens.space2),
                  OutlinedButton(
                    onPressed: onSkip,
                    child: Text(l10n.doseSkip),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final DoseStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (color, label) = switch (status) {
      DoseStatus.taken => (AppTokens.statusTaken, l10n.statusTaken),
      DoseStatus.pending => (AppTokens.statusPending, l10n.statusPending),
      DoseStatus.snoozed => (AppTokens.statusSnoozed, l10n.statusSnoozed),
      DoseStatus.skipped => (AppTokens.statusSkipped, l10n.statusSkipped),
      DoseStatus.paused => (AppTokens.statusPaused, l10n.statusPaused),
      DoseStatus.unsure => (AppTokens.statusUnsure, l10n.statusUnsure),
    };
    return Chip(
      label: Text(label),
      side: BorderSide(color: color),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      backgroundColor: color.withOpacity(0.08),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView();
  @override
  Widget build(BuildContext context) =>
      const Center(child: Icon(Icons.error_outline, size: 48));
}
