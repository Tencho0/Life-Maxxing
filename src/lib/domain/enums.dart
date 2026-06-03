// Domain enumerations — stored as stable lowercase text `code`s; Bulgarian
// display `label`s live here (decoupled from storage so labels can change
// without a migration). See docs/technical-spec.md §3.2.
//
// Pure Dart — no Flutter imports.

/// Anything persisted by its stable [code] with a display [label].
abstract interface class Coded {
  String get code;
  String get label;
}

/// Finds the enum value whose code matches [code], or null if none.
T? parseCode<T extends Coded>(List<T> values, String code) {
  for (final v in values) {
    if (v.code == code) return v;
  }
  return null;
}

// ── Food ────────────────────────────────────────────────────────────
enum MealType implements Coded {
  breakfast('breakfast', 'Закуска'),
  lunch('lunch', 'Обяд'),
  dinner('dinner', 'Вечеря'),
  snack('snack', 'Snack'),
  other('other', 'Друго');

  const MealType(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
  static MealType? tryParse(String code) => parseCode(values, code);
}

// ── Activities ──────────────────────────────────────────────────────
enum ActivityType implements Coded {
  gym('gym', 'Фитнес'),
  bjj('bjj', 'BJJ'),
  boxing('boxing', 'Бокс'),
  kickboxing('kickboxing', 'Кикбокс'),
  mma('mma', 'ММА'),
  tennis('tennis', 'Тенис'),
  hiking('hiking', 'Разходка в планината'),
  folkDance('folk_dance', 'Народни танци'),
  cycling('cycling', 'Колоездене'),
  swimming('swimming', 'Плуване'),
  ski('ski', 'Ски'),
  other('other', 'Друго');

  const ActivityType(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
  static ActivityType? tryParse(String code) => parseCode(values, code);

  /// Coarser grouping for summaries (spec §7.6).
  ActivityGroup get group => switch (this) {
        ActivityType.gym => ActivityGroup.strength,
        ActivityType.bjj ||
        ActivityType.boxing ||
        ActivityType.kickboxing ||
        ActivityType.mma =>
          ActivityGroup.combat,
        ActivityType.cycling ||
        ActivityType.swimming ||
        ActivityType.tennis ||
        ActivityType.hiking ||
        ActivityType.ski =>
          ActivityGroup.cardio,
        ActivityType.folkDance => ActivityGroup.dance,
        ActivityType.other => ActivityGroup.other,
      };
}

/// Derived activity grouping (not stored).
enum ActivityGroup implements Coded {
  strength('strength', 'Силови тренировки'),
  combat('combat', 'Бойни спортове'),
  cardio('cardio', 'Кардио / движение'),
  dance('dance', 'Танци'),
  other('other', 'Друго');

  const ActivityGroup(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
}

enum Intensity implements Coded {
  low('low', 'Ниска'),
  medium('medium', 'Средна'),
  high('high', 'Висока');

  const Intensity(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
  static Intensity? tryParse(String code) => parseCode(values, code);
}

// ── Money ───────────────────────────────────────────────────────────
enum ExpenseCategory implements Coded {
  food('food', 'Храна'),
  entertainment('entertainment', 'Забавления'),
  social('social', 'Социални'),
  transport('transport', 'Транспорт'),
  education('education', 'Образование'),
  subscriptions('subscriptions', 'Абонаменти'),
  car('car', 'Автомобил'),
  clothing('clothing', 'Дрехи и обувки'),
  healthSupplements('health_supplements', 'Здраве и добавки'),
  sport('sport', 'Спорт'),
  appearance('appearance', 'Външен вид'),
  vape('vape', 'Вейп'),
  other('other', 'Друго');

  const ExpenseCategory(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
  static ExpenseCategory? tryParse(String code) => parseCode(values, code);
}

enum IncomeCategory implements Coded {
  salary('salary', 'Заплата'),
  freelance('freelance', 'Freelance'),
  bonus('bonus', 'Бонус'),
  sale('sale', 'Продажба'),
  gift('gift', 'Подарък'),
  business('business', 'Бизнес'),
  other('other', 'Друго');

  const IncomeCategory(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
  static IncomeCategory? tryParse(String code) => parseCode(values, code);
}

enum PaymentMethod implements Coded {
  card('card', 'Карта'),
  cash('cash', 'В брой'),
  other('other', 'Друго');

  const PaymentMethod(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
  static PaymentMethod? tryParse(String code) => parseCode(values, code);
}

// ── Health ──────────────────────────────────────────────────────────
enum HealthEventType implements Coded {
  dentist('dentist', 'Зъболекар'),
  doctor('doctor', 'Лекар'),
  procedure('procedure', 'Процедура'),
  checkup('checkup', 'Профилактичен преглед'),
  physiotherapy('physiotherapy', 'Физиотерапия'),
  other('other', 'Друго');

  const HealthEventType(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
  static HealthEventType? tryParse(String code) => parseCode(values, code);
}

enum DentalSubtype implements Coded {
  prophylaxis('prophylaxis', 'Профилактика'),
  cleaning('cleaning', 'Почистване'),
  filling('filling', 'Пломба'),
  rootCanal('root_canal', 'Кореново лечение'),
  whitening('whitening', 'Избелване'),
  bonding('bonding', 'Бондинг/фасети'),
  orthodontics('orthodontics', 'Ортодонт'),
  extraction('extraction', 'Вадене'),
  other('other', 'Друго');

  const DentalSubtype(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
  static DentalSubtype? tryParse(String code) => parseCode(values, code);
}

enum MedType implements Coded {
  medication('medication', 'Медикамент'),
  supplement('supplement', 'Добавка'),
  vitamin('vitamin', 'Витамин'),
  mineral('mineral', 'Минерал'),
  sportsSupplement('sports_supplement', 'Спортна добавка'),
  other('other', 'Друго');

  const MedType(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
  static MedType? tryParse(String code) => parseCode(values, code);
}

enum MedStatus implements Coded {
  taken('taken', 'Прието'),
  missed('missed', 'Пропуснато');

  const MedStatus(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
  static MedStatus? tryParse(String code) => parseCode(values, code);
}

// ── Steps ───────────────────────────────────────────────────────────
enum StepsSource implements Coded {
  dailyQuickLog('daily_quick_log', 'Дневен отчет'),
  stepsModule('steps_module', 'Крачки');

  const StepsSource(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
  static StepsSource? tryParse(String code) => parseCode(values, code);
}

// ── Bucket list ─────────────────────────────────────────────────────
enum BucketPriority implements Coded {
  low('low', 'Low'),
  medium('medium', 'Medium'),
  high('high', 'High');

  const BucketPriority(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
  static BucketPriority? tryParse(String code) => parseCode(values, code);
}

enum BucketStatus implements Coded {
  idea('idea', 'Идея'),
  planned('planned', 'Планирано'),
  completed('completed', 'Завършено'),
  abandoned('abandoned', 'Изоставено');

  const BucketStatus(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
  static BucketStatus? tryParse(String code) => parseCode(values, code);
}

// ── Period (UI/query window; not persisted) ─────────────────────────
enum Period implements Coded {
  today('today', 'Днес', 'Днес'),
  last7('last7', 'Последните 7 дни', '7 дни'),
  last30('last30', 'Последните 30 дни', '30 дни'),
  thisMonth('this_month', 'Текущ месец', 'Месец'),
  prevMonth('prev_month', 'Предишен месец', 'Предишен'),
  custom('custom', 'Custom период', 'Custom');

  const Period(this.code, this.label, this.chipLabel);
  @override
  final String code;
  @override
  final String label;

  /// Short label for the [PeriodChips] selector.
  final String chipLabel;
  static Period? tryParse(String code) => parseCode(values, code);
}

// ── Attachments ─────────────────────────────────────────────────────
/// Which entity an attachment belongs to. [folder] is the subdirectory used
/// under `attachments/` on disk and in the backup ZIP (spec §26.3).
enum AttachmentEntity implements Coded {
  meal('meal', 'Хранене', 'meals'),
  activity('activity', 'Активност', 'activities'),
  healthEvent('health_event', 'Здравно събитие', 'health-events'),
  labTest('lab_test', 'Изследване', 'lab-results'),
  dailyLog('daily_log', 'Дневен отчет', 'daily-photos'),
  bucketItem('bucket_item', 'Bucket List', 'bucket-list'),
  bucketExperience('bucket_experience', 'Преживяване', 'bucket-list-experiences'),
  trip('trip', 'Пътуване', 'trips');

  const AttachmentEntity(this.code, this.label, this.folder);
  @override
  final String code;
  @override
  final String label;
  final String folder;
  static AttachmentEntity? tryParse(String code) => parseCode(values, code);
}

/// The role an attachment plays for its entity (cardinality discriminator).
enum AttachmentRole implements Coded {
  photo('photo', 'снимка'),
  main('main', 'основна'),
  cover('cover', 'корица'),
  gallery('gallery', 'галерия');

  const AttachmentRole(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
  static AttachmentRole? tryParse(String code) => parseCode(values, code);
}
