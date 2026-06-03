import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/domain/enums.dart';

/// Codes are unique; every value round-trips through its parser; labels exist;
/// unknown codes parse to null.
void checkEnum<T extends Coded>(List<T> values, T? Function(String) parse) {
  final codes = values.map((e) => e.code).toList();
  expect(codes.toSet().length, codes.length, reason: 'codes must be unique');
  for (final v in values) {
    expect(parse(v.code), v, reason: 'round-trip ${v.code}');
    expect(v.label.trim(), isNotEmpty, reason: 'label for ${v.code}');
  }
  expect(parse('__unknown__'), isNull);
}

void main() {
  test('all stored enums round-trip codes and have labels', () {
    checkEnum(MealType.values, MealType.tryParse);
    checkEnum(ActivityType.values, ActivityType.tryParse);
    checkEnum(Intensity.values, Intensity.tryParse);
    checkEnum(ExpenseCategory.values, ExpenseCategory.tryParse);
    checkEnum(IncomeCategory.values, IncomeCategory.tryParse);
    checkEnum(PaymentMethod.values, PaymentMethod.tryParse);
    checkEnum(HealthEventType.values, HealthEventType.tryParse);
    checkEnum(DentalSubtype.values, DentalSubtype.tryParse);
    checkEnum(MedType.values, MedType.tryParse);
    checkEnum(MedStatus.values, MedStatus.tryParse);
    checkEnum(StepsSource.values, StepsSource.tryParse);
    checkEnum(BucketPriority.values, BucketPriority.tryParse);
    checkEnum(BucketStatus.values, BucketStatus.tryParse);
    checkEnum(Period.values, Period.tryParse);
    checkEnum(AttachmentEntity.values, AttachmentEntity.tryParse);
    checkEnum(AttachmentRole.values, AttachmentRole.tryParse);
  });

  test('income categories follow the functional spec (not the prototype)', () {
    expect(
      IncomeCategory.values.map((e) => e.code).toList(),
      ['salary', 'freelance', 'bonus', 'sale', 'gift', 'business', 'other'],
    );
  });

  test('ActivityType.group derivation (spec §7.6)', () {
    expect(ActivityType.gym.group, ActivityGroup.strength);
    expect(ActivityType.bjj.group, ActivityGroup.combat);
    expect(ActivityType.mma.group, ActivityGroup.combat);
    expect(ActivityType.cycling.group, ActivityGroup.cardio);
    expect(ActivityType.swimming.group, ActivityGroup.cardio);
    expect(ActivityType.tennis.group, ActivityGroup.cardio);
    expect(ActivityType.hiking.group, ActivityGroup.cardio);
    expect(ActivityType.ski.group, ActivityGroup.cardio);
    expect(ActivityType.folkDance.group, ActivityGroup.dance);
    expect(ActivityType.other.group, ActivityGroup.other);
  });

  test('AttachmentEntity folders are unique and non-empty', () {
    final folders = AttachmentEntity.values.map((e) => e.folder).toList();
    expect(folders.toSet().length, folders.length);
    for (final f in folders) {
      expect(f.trim(), isNotEmpty);
    }
  });

  test('Period exposes chip labels and includes previous month', () {
    expect(Period.values.contains(Period.prevMonth), isTrue);
    for (final p in Period.values) {
      expect(p.chipLabel.trim(), isNotEmpty);
    }
  });
}
