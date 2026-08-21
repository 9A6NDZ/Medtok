import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/localization/gen/app_localizations.dart';
import '../../../core/theme/app_tokens.dart';

/// Lists active medications from the DB. Add-medication flow arrives in a
/// later phase; the FAB is wired but currently a no-op placeholder.
class MedicationsScreen extends ConsumerWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final meds = ref.watch(_medicationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.medicationsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.addMedication)),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.addMedication),
      ),
      body: meds.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Icon(Icons.error_outline)),
        data: (list) => list.isEmpty
            ? Center(child: Text(l10n.medicationsEmpty))
            : ListView.builder(
                padding: const EdgeInsets.all(AppTokens.space4),
                itemCount: list.length,
                itemBuilder: (context, i) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.medication),
                    title: Text(list[i].name),
                    subtitle: list[i].strength != null
                        ? Text('${list[i].strength} '
                            '${list[i].strengthUnit ?? ''}')
                        : null,
                  ),
                ),
              ),
      ),
    );
  }
}

final _medicationsProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(medicationDaoProvider).watchActiveMedications(),
);
