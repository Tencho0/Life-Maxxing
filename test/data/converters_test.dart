import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/data/converters.dart';

/// Every value maps to its code and back; unknown codes fall back.
void checkConverter<T extends Coded>(
  CodedConverter<T> c,
  List<T> values,
  T fallback,
) {
  for (final v in values) {
    expect(c.toSql(v), v.code);
    expect(c.fromSql(v.code), v);
  }
  expect(c.fromSql('__unknown__'), fallback, reason: 'fallback on bad code');
}

void main() {
  test('all coded converters round-trip and fall back', () {
    checkConverter(mealTypeConverter, MealType.values, MealType.other);
    checkConverter(activityTypeConverter, ActivityType.values, ActivityType.other);
    checkConverter(intensityConverter, Intensity.values, Intensity.medium);
    checkConverter(expenseCategoryConverter, ExpenseCategory.values, ExpenseCategory.other);
    checkConverter(incomeCategoryConverter, IncomeCategory.values, IncomeCategory.other);
    checkConverter(paymentMethodConverter, PaymentMethod.values, PaymentMethod.other);
    checkConverter(healthEventTypeConverter, HealthEventType.values, HealthEventType.other);
    checkConverter(dentalSubtypeConverter, DentalSubtype.values, DentalSubtype.other);
    checkConverter(medTypeConverter, MedType.values, MedType.other);
    checkConverter(medStatusConverter, MedStatus.values, MedStatus.taken);
    checkConverter(stepsSourceConverter, StepsSource.values, StepsSource.stepsModule);
    checkConverter(bucketPriorityConverter, BucketPriority.values, BucketPriority.medium);
    checkConverter(bucketStatusConverter, BucketStatus.values, BucketStatus.idea);
    checkConverter(attachmentEntityConverter, AttachmentEntity.values, AttachmentEntity.meal);
    checkConverter(attachmentRoleConverter, AttachmentRole.values, AttachmentRole.photo);
  });
}
