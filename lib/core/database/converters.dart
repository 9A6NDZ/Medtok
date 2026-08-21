import 'package:drift/drift.dart';

import 'enums.dart';

/// Generic converter that stores an enum by its [Enum.name] as text.
/// Stable across reorderings, unlike storing the index.
class EnumNameConverter<T extends Enum> extends TypeConverter<T, String> {
  const EnumNameConverter(this.values);
  final List<T> values;

  @override
  T fromSql(String fromDb) =>
      values.firstWhere((e) => e.name == fromDb, orElse: () => values.first);

  @override
  String toSql(T value) => value.name;
}

class DoseStatusConverter extends EnumNameConverter<DoseStatus> {
  const DoseStatusConverter() : super(DoseStatus.values);
}

class MedicationFormConverter extends EnumNameConverter<MedicationForm> {
  const MedicationFormConverter() : super(MedicationForm.values);
}

class ScheduleTypeConverter extends EnumNameConverter<ScheduleType> {
  const ScheduleTypeConverter() : super(ScheduleType.values);
}

class MealRelationConverter extends EnumNameConverter<MealRelation> {
  const MealRelationConverter() : super(MealRelation.values);
}
