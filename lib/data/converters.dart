// drift TypeConverters mapping each stored enum to/from its stable text `code`.
// One generic converter ([CodedConverter]) backs them all. Unknown codes fall
// back to a designated value (defensive against corrupt/legacy data — valid
// app-written data always round-trips). See docs/technical-spec.md §3.1–3.2.

import 'package:drift/drift.dart';
import '../domain/enums.dart';

/// Maps a [Coded] enum to its `code` string for storage.
class CodedConverter<T extends Coded> extends TypeConverter<T, String> {
  const CodedConverter(this.values, this.fallback);

  final List<T> values;
  final T fallback;

  @override
  T fromSql(String fromDb) {
    for (final v in values) {
      if (v.code == fromDb) return v;
    }
    return fallback;
  }

  @override
  String toSql(T value) => value.code;
}

// One const converter per stored enum (used in table column definitions).
const mealTypeConverter =
    CodedConverter<MealType>(MealType.values, MealType.other);
const activityTypeConverter =
    CodedConverter<ActivityType>(ActivityType.values, ActivityType.other);
const intensityConverter =
    CodedConverter<Intensity>(Intensity.values, Intensity.medium);
const expenseCategoryConverter = CodedConverter<ExpenseCategory>(
    ExpenseCategory.values, ExpenseCategory.other);
const incomeCategoryConverter =
    CodedConverter<IncomeCategory>(IncomeCategory.values, IncomeCategory.other);
const paymentMethodConverter =
    CodedConverter<PaymentMethod>(PaymentMethod.values, PaymentMethod.other);
const healthEventTypeConverter = CodedConverter<HealthEventType>(
    HealthEventType.values, HealthEventType.other);
const dentalSubtypeConverter =
    CodedConverter<DentalSubtype>(DentalSubtype.values, DentalSubtype.other);
const medTypeConverter =
    CodedConverter<MedType>(MedType.values, MedType.other);
const medStatusConverter =
    CodedConverter<MedStatus>(MedStatus.values, MedStatus.taken);
const stepsSourceConverter = CodedConverter<StepsSource>(
    StepsSource.values, StepsSource.stepsModule);
const bucketPriorityConverter = CodedConverter<BucketPriority>(
    BucketPriority.values, BucketPriority.medium);
const bucketStatusConverter =
    CodedConverter<BucketStatus>(BucketStatus.values, BucketStatus.idea);
const attachmentEntityConverter = CodedConverter<AttachmentEntity>(
    AttachmentEntity.values, AttachmentEntity.meal);
const attachmentRoleConverter = CodedConverter<AttachmentRole>(
    AttachmentRole.values, AttachmentRole.photo);
