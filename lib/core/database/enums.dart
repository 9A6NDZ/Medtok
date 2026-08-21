/// Status of a single planned dose. Stored as the enum name (String) in the DB
/// so values remain stable and readable across migrations.
enum DoseStatus {
  pending,
  taken,
  snoozed,
  skipped,
  paused,
  unsure,
}

/// Pharmaceutical form of a medication.
enum MedicationForm {
  tablet,
  capsule,
  syrup,
  drops,
  spray,
  inhaler,
  injection,
  cream,
  gel,
  patch,
  other,
}

/// How a schedule repeats. The scheduling engine (later phase) expands these
/// into concrete dose instances. Kept as an enum here so the DB schema is set.
enum ScheduleType {
  daily,
  intervalHours,
  specificWeekdays,
  specificDates,
  cycle,
  asNeeded,
}

/// Optional relation of a dose to meals. Informational only.
enum MealRelation {
  none,
  beforeMeal,
  withMeal,
  afterMeal,
  fasting,
  beforeSleep,
  afterWaking,
  other,
}
