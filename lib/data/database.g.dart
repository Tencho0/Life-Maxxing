// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MealsTable extends Meals with TableInfo<$MealsTable, Meal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameLowerMeta = const VerificationMeta(
    'nameLower',
  );
  @override
  late final GeneratedColumn<String> nameLower = GeneratedColumn<String>(
    'name_lower',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MealType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MealType>($MealsTable.$convertertype);
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<String> quantity = GeneratedColumn<String>(
    'quantity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
    'carbs',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
    'fat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteLowerMeta = const VerificationMeta(
    'noteLower',
  );
  @override
  late final GeneratedColumn<String> noteLower = GeneratedColumn<String>(
    'note_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    time,
    name,
    nameLower,
    type,
    quantity,
    calories,
    protein,
    carbs,
    fat,
    note,
    noteLower,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Meal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_lower')) {
      context.handle(
        _nameLowerMeta,
        nameLower.isAcceptableOrUnknown(data['name_lower']!, _nameLowerMeta),
      );
    } else if (isInserting) {
      context.missing(_nameLowerMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    }
    if (data.containsKey('carbs')) {
      context.handle(
        _carbsMeta,
        carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta),
      );
    }
    if (data.containsKey('fat')) {
      context.handle(
        _fatMeta,
        fat.isAcceptableOrUnknown(data['fat']!, _fatMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('note_lower')) {
      context.handle(
        _noteLowerMeta,
        noteLower.isAcceptableOrUnknown(data['note_lower']!, _noteLowerMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Meal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Meal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_lower'],
      )!,
      type: $MealsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quantity'],
      ),
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      ),
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein'],
      ),
      carbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs'],
      ),
      fat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      noteLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_lower'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }

  static TypeConverter<MealType, String> $convertertype = mealTypeConverter;
}

class Meal extends DataClass implements Insertable<Meal> {
  final String id;
  final String date;
  final String? time;
  final String name;
  final String nameLower;
  final MealType type;
  final String? quantity;
  final int? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final String? note;
  final String? noteLower;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Meal({
    required this.id,
    required this.date,
    this.time,
    required this.name,
    required this.nameLower,
    required this.type,
    this.quantity,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.note,
    this.noteLower,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<String>(time);
    }
    map['name'] = Variable<String>(name);
    map['name_lower'] = Variable<String>(nameLower);
    {
      map['type'] = Variable<String>($MealsTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<String>(quantity);
    }
    if (!nullToAbsent || calories != null) {
      map['calories'] = Variable<int>(calories);
    }
    if (!nullToAbsent || protein != null) {
      map['protein'] = Variable<double>(protein);
    }
    if (!nullToAbsent || carbs != null) {
      map['carbs'] = Variable<double>(carbs);
    }
    if (!nullToAbsent || fat != null) {
      map['fat'] = Variable<double>(fat);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || noteLower != null) {
      map['note_lower'] = Variable<String>(noteLower);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      date: Value(date),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      name: Value(name),
      nameLower: Value(nameLower),
      type: Value(type),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      calories: calories == null && nullToAbsent
          ? const Value.absent()
          : Value(calories),
      protein: protein == null && nullToAbsent
          ? const Value.absent()
          : Value(protein),
      carbs: carbs == null && nullToAbsent
          ? const Value.absent()
          : Value(carbs),
      fat: fat == null && nullToAbsent ? const Value.absent() : Value(fat),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      noteLower: noteLower == null && nullToAbsent
          ? const Value.absent()
          : Value(noteLower),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Meal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Meal(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      time: serializer.fromJson<String?>(json['time']),
      name: serializer.fromJson<String>(json['name']),
      nameLower: serializer.fromJson<String>(json['nameLower']),
      type: serializer.fromJson<MealType>(json['type']),
      quantity: serializer.fromJson<String?>(json['quantity']),
      calories: serializer.fromJson<int?>(json['calories']),
      protein: serializer.fromJson<double?>(json['protein']),
      carbs: serializer.fromJson<double?>(json['carbs']),
      fat: serializer.fromJson<double?>(json['fat']),
      note: serializer.fromJson<String?>(json['note']),
      noteLower: serializer.fromJson<String?>(json['noteLower']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'time': serializer.toJson<String?>(time),
      'name': serializer.toJson<String>(name),
      'nameLower': serializer.toJson<String>(nameLower),
      'type': serializer.toJson<MealType>(type),
      'quantity': serializer.toJson<String?>(quantity),
      'calories': serializer.toJson<int?>(calories),
      'protein': serializer.toJson<double?>(protein),
      'carbs': serializer.toJson<double?>(carbs),
      'fat': serializer.toJson<double?>(fat),
      'note': serializer.toJson<String?>(note),
      'noteLower': serializer.toJson<String?>(noteLower),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Meal copyWith({
    String? id,
    String? date,
    Value<String?> time = const Value.absent(),
    String? name,
    String? nameLower,
    MealType? type,
    Value<String?> quantity = const Value.absent(),
    Value<int?> calories = const Value.absent(),
    Value<double?> protein = const Value.absent(),
    Value<double?> carbs = const Value.absent(),
    Value<double?> fat = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> noteLower = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Meal(
    id: id ?? this.id,
    date: date ?? this.date,
    time: time.present ? time.value : this.time,
    name: name ?? this.name,
    nameLower: nameLower ?? this.nameLower,
    type: type ?? this.type,
    quantity: quantity.present ? quantity.value : this.quantity,
    calories: calories.present ? calories.value : this.calories,
    protein: protein.present ? protein.value : this.protein,
    carbs: carbs.present ? carbs.value : this.carbs,
    fat: fat.present ? fat.value : this.fat,
    note: note.present ? note.value : this.note,
    noteLower: noteLower.present ? noteLower.value : this.noteLower,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Meal copyWithCompanion(MealsCompanion data) {
    return Meal(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      time: data.time.present ? data.time.value : this.time,
      name: data.name.present ? data.name.value : this.name,
      nameLower: data.nameLower.present ? data.nameLower.value : this.nameLower,
      type: data.type.present ? data.type.value : this.type,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      calories: data.calories.present ? data.calories.value : this.calories,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      fat: data.fat.present ? data.fat.value : this.fat,
      note: data.note.present ? data.note.value : this.note,
      noteLower: data.noteLower.present ? data.noteLower.value : this.noteLower,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Meal(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('name: $name, ')
          ..write('nameLower: $nameLower, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    time,
    name,
    nameLower,
    type,
    quantity,
    calories,
    protein,
    carbs,
    fat,
    note,
    noteLower,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meal &&
          other.id == this.id &&
          other.date == this.date &&
          other.time == this.time &&
          other.name == this.name &&
          other.nameLower == this.nameLower &&
          other.type == this.type &&
          other.quantity == this.quantity &&
          other.calories == this.calories &&
          other.protein == this.protein &&
          other.carbs == this.carbs &&
          other.fat == this.fat &&
          other.note == this.note &&
          other.noteLower == this.noteLower &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MealsCompanion extends UpdateCompanion<Meal> {
  final Value<String> id;
  final Value<String> date;
  final Value<String?> time;
  final Value<String> name;
  final Value<String> nameLower;
  final Value<MealType> type;
  final Value<String?> quantity;
  final Value<int?> calories;
  final Value<double?> protein;
  final Value<double?> carbs;
  final Value<double?> fat;
  final Value<String?> note;
  final Value<String?> noteLower;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.name = const Value.absent(),
    this.nameLower = const Value.absent(),
    this.type = const Value.absent(),
    this.quantity = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealsCompanion.insert({
    required String id,
    required String date,
    this.time = const Value.absent(),
    required String name,
    required String nameLower,
    required MealType type,
    this.quantity = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       name = Value(name),
       nameLower = Value(nameLower),
       type = Value(type),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Meal> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<String>? time,
    Expression<String>? name,
    Expression<String>? nameLower,
    Expression<String>? type,
    Expression<String>? quantity,
    Expression<int>? calories,
    Expression<double>? protein,
    Expression<double>? carbs,
    Expression<double>? fat,
    Expression<String>? note,
    Expression<String>? noteLower,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (name != null) 'name': name,
      if (nameLower != null) 'name_lower': nameLower,
      if (type != null) 'type': type,
      if (quantity != null) 'quantity': quantity,
      if (calories != null) 'calories': calories,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (fat != null) 'fat': fat,
      if (note != null) 'note': note,
      if (noteLower != null) 'note_lower': noteLower,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealsCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<String?>? time,
    Value<String>? name,
    Value<String>? nameLower,
    Value<MealType>? type,
    Value<String?>? quantity,
    Value<int?>? calories,
    Value<double?>? protein,
    Value<double?>? carbs,
    Value<double?>? fat,
    Value<String?>? note,
    Value<String?>? noteLower,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MealsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      name: name ?? this.name,
      nameLower: nameLower ?? this.nameLower,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      note: note ?? this.note,
      noteLower: noteLower ?? this.noteLower,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameLower.present) {
      map['name_lower'] = Variable<String>(nameLower.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $MealsTable.$convertertype.toSql(type.value),
      );
    }
    if (quantity.present) {
      map['quantity'] = Variable<String>(quantity.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (noteLower.present) {
      map['note_lower'] = Variable<String>(noteLower.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('name: $name, ')
          ..write('nameLower: $nameLower, ')
          ..write('type: $type, ')
          ..write('quantity: $quantity, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, Activity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMinMeta = const VerificationMeta(
    'durationMin',
  );
  @override
  late final GeneratedColumn<int> durationMin = GeneratedColumn<int>(
    'duration_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ActivityType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ActivityType>($ActivitiesTable.$convertertype);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameLowerMeta = const VerificationMeta(
    'nameLower',
  );
  @override
  late final GeneratedColumn<String> nameLower = GeneratedColumn<String>(
    'name_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Intensity?, String> intensity =
      GeneratedColumn<String>(
        'intensity',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Intensity?>($ActivitiesTable.$converterintensityn);
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<int> quality = GeneratedColumn<int>(
    'quality',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moodAfterMeta = const VerificationMeta(
    'moodAfter',
  );
  @override
  late final GeneratedColumn<int> moodAfter = GeneratedColumn<int>(
    'mood_after',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteLowerMeta = const VerificationMeta(
    'noteLower',
  );
  @override
  late final GeneratedColumn<String> noteLower = GeneratedColumn<String>(
    'note_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    startTime,
    endTime,
    durationMin,
    type,
    name,
    nameLower,
    intensity,
    quality,
    moodAfter,
    note,
    noteLower,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Activity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('duration_min')) {
      context.handle(
        _durationMinMeta,
        durationMin.isAcceptableOrUnknown(
          data['duration_min']!,
          _durationMinMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('name_lower')) {
      context.handle(
        _nameLowerMeta,
        nameLower.isAcceptableOrUnknown(data['name_lower']!, _nameLowerMeta),
      );
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    }
    if (data.containsKey('mood_after')) {
      context.handle(
        _moodAfterMeta,
        moodAfter.isAcceptableOrUnknown(data['mood_after']!, _moodAfterMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('note_lower')) {
      context.handle(
        _noteLowerMeta,
        noteLower.isAcceptableOrUnknown(data['note_lower']!, _noteLowerMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Activity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Activity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      ),
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      ),
      durationMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_min'],
      ),
      type: $ActivitiesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      nameLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_lower'],
      ),
      intensity: $ActivitiesTable.$converterintensityn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}intensity'],
        ),
      ),
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quality'],
      ),
      moodAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_after'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      noteLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_lower'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }

  static TypeConverter<ActivityType, String> $convertertype =
      activityTypeConverter;
  static TypeConverter<Intensity, String> $converterintensity =
      intensityConverter;
  static TypeConverter<Intensity?, String?> $converterintensityn =
      NullAwareTypeConverter.wrap($converterintensity);
}

class Activity extends DataClass implements Insertable<Activity> {
  final String id;
  final String date;
  final String? startTime;
  final String? endTime;
  final int? durationMin;
  final ActivityType type;
  final String? name;
  final String? nameLower;
  final Intensity? intensity;
  final int? quality;
  final int? moodAfter;
  final String? note;
  final String? noteLower;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Activity({
    required this.id,
    required this.date,
    this.startTime,
    this.endTime,
    this.durationMin,
    required this.type,
    this.name,
    this.nameLower,
    this.intensity,
    this.quality,
    this.moodAfter,
    this.note,
    this.noteLower,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<String>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<String>(endTime);
    }
    if (!nullToAbsent || durationMin != null) {
      map['duration_min'] = Variable<int>(durationMin);
    }
    {
      map['type'] = Variable<String>(
        $ActivitiesTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || nameLower != null) {
      map['name_lower'] = Variable<String>(nameLower);
    }
    if (!nullToAbsent || intensity != null) {
      map['intensity'] = Variable<String>(
        $ActivitiesTable.$converterintensityn.toSql(intensity),
      );
    }
    if (!nullToAbsent || quality != null) {
      map['quality'] = Variable<int>(quality);
    }
    if (!nullToAbsent || moodAfter != null) {
      map['mood_after'] = Variable<int>(moodAfter);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || noteLower != null) {
      map['note_lower'] = Variable<String>(noteLower);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      id: Value(id),
      date: Value(date),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      durationMin: durationMin == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMin),
      type: Value(type),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      nameLower: nameLower == null && nullToAbsent
          ? const Value.absent()
          : Value(nameLower),
      intensity: intensity == null && nullToAbsent
          ? const Value.absent()
          : Value(intensity),
      quality: quality == null && nullToAbsent
          ? const Value.absent()
          : Value(quality),
      moodAfter: moodAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(moodAfter),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      noteLower: noteLower == null && nullToAbsent
          ? const Value.absent()
          : Value(noteLower),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Activity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Activity(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      startTime: serializer.fromJson<String?>(json['startTime']),
      endTime: serializer.fromJson<String?>(json['endTime']),
      durationMin: serializer.fromJson<int?>(json['durationMin']),
      type: serializer.fromJson<ActivityType>(json['type']),
      name: serializer.fromJson<String?>(json['name']),
      nameLower: serializer.fromJson<String?>(json['nameLower']),
      intensity: serializer.fromJson<Intensity?>(json['intensity']),
      quality: serializer.fromJson<int?>(json['quality']),
      moodAfter: serializer.fromJson<int?>(json['moodAfter']),
      note: serializer.fromJson<String?>(json['note']),
      noteLower: serializer.fromJson<String?>(json['noteLower']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'startTime': serializer.toJson<String?>(startTime),
      'endTime': serializer.toJson<String?>(endTime),
      'durationMin': serializer.toJson<int?>(durationMin),
      'type': serializer.toJson<ActivityType>(type),
      'name': serializer.toJson<String?>(name),
      'nameLower': serializer.toJson<String?>(nameLower),
      'intensity': serializer.toJson<Intensity?>(intensity),
      'quality': serializer.toJson<int?>(quality),
      'moodAfter': serializer.toJson<int?>(moodAfter),
      'note': serializer.toJson<String?>(note),
      'noteLower': serializer.toJson<String?>(noteLower),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Activity copyWith({
    String? id,
    String? date,
    Value<String?> startTime = const Value.absent(),
    Value<String?> endTime = const Value.absent(),
    Value<int?> durationMin = const Value.absent(),
    ActivityType? type,
    Value<String?> name = const Value.absent(),
    Value<String?> nameLower = const Value.absent(),
    Value<Intensity?> intensity = const Value.absent(),
    Value<int?> quality = const Value.absent(),
    Value<int?> moodAfter = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> noteLower = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Activity(
    id: id ?? this.id,
    date: date ?? this.date,
    startTime: startTime.present ? startTime.value : this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    durationMin: durationMin.present ? durationMin.value : this.durationMin,
    type: type ?? this.type,
    name: name.present ? name.value : this.name,
    nameLower: nameLower.present ? nameLower.value : this.nameLower,
    intensity: intensity.present ? intensity.value : this.intensity,
    quality: quality.present ? quality.value : this.quality,
    moodAfter: moodAfter.present ? moodAfter.value : this.moodAfter,
    note: note.present ? note.value : this.note,
    noteLower: noteLower.present ? noteLower.value : this.noteLower,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Activity copyWithCompanion(ActivitiesCompanion data) {
    return Activity(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      durationMin: data.durationMin.present
          ? data.durationMin.value
          : this.durationMin,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      nameLower: data.nameLower.present ? data.nameLower.value : this.nameLower,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      quality: data.quality.present ? data.quality.value : this.quality,
      moodAfter: data.moodAfter.present ? data.moodAfter.value : this.moodAfter,
      note: data.note.present ? data.note.value : this.note,
      noteLower: data.noteLower.present ? data.noteLower.value : this.noteLower,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Activity(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationMin: $durationMin, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('nameLower: $nameLower, ')
          ..write('intensity: $intensity, ')
          ..write('quality: $quality, ')
          ..write('moodAfter: $moodAfter, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    startTime,
    endTime,
    durationMin,
    type,
    name,
    nameLower,
    intensity,
    quality,
    moodAfter,
    note,
    noteLower,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          other.id == this.id &&
          other.date == this.date &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.durationMin == this.durationMin &&
          other.type == this.type &&
          other.name == this.name &&
          other.nameLower == this.nameLower &&
          other.intensity == this.intensity &&
          other.quality == this.quality &&
          other.moodAfter == this.moodAfter &&
          other.note == this.note &&
          other.noteLower == this.noteLower &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<String> id;
  final Value<String> date;
  final Value<String?> startTime;
  final Value<String?> endTime;
  final Value<int?> durationMin;
  final Value<ActivityType> type;
  final Value<String?> name;
  final Value<String?> nameLower;
  final Value<Intensity?> intensity;
  final Value<int?> quality;
  final Value<int?> moodAfter;
  final Value<String?> note;
  final Value<String?> noteLower;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.durationMin = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.nameLower = const Value.absent(),
    this.intensity = const Value.absent(),
    this.quality = const Value.absent(),
    this.moodAfter = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    required String id,
    required String date,
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.durationMin = const Value.absent(),
    required ActivityType type,
    this.name = const Value.absent(),
    this.nameLower = const Value.absent(),
    this.intensity = const Value.absent(),
    this.quality = const Value.absent(),
    this.moodAfter = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       type = Value(type),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Activity> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<int>? durationMin,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? nameLower,
    Expression<String>? intensity,
    Expression<int>? quality,
    Expression<int>? moodAfter,
    Expression<String>? note,
    Expression<String>? noteLower,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (durationMin != null) 'duration_min': durationMin,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (nameLower != null) 'name_lower': nameLower,
      if (intensity != null) 'intensity': intensity,
      if (quality != null) 'quality': quality,
      if (moodAfter != null) 'mood_after': moodAfter,
      if (note != null) 'note': note,
      if (noteLower != null) 'note_lower': noteLower,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<String?>? startTime,
    Value<String?>? endTime,
    Value<int?>? durationMin,
    Value<ActivityType>? type,
    Value<String?>? name,
    Value<String?>? nameLower,
    Value<Intensity?>? intensity,
    Value<int?>? quality,
    Value<int?>? moodAfter,
    Value<String?>? note,
    Value<String?>? noteLower,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ActivitiesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMin: durationMin ?? this.durationMin,
      type: type ?? this.type,
      name: name ?? this.name,
      nameLower: nameLower ?? this.nameLower,
      intensity: intensity ?? this.intensity,
      quality: quality ?? this.quality,
      moodAfter: moodAfter ?? this.moodAfter,
      note: note ?? this.note,
      noteLower: noteLower ?? this.noteLower,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (durationMin.present) {
      map['duration_min'] = Variable<int>(durationMin.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $ActivitiesTable.$convertertype.toSql(type.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameLower.present) {
      map['name_lower'] = Variable<String>(nameLower.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<String>(
        $ActivitiesTable.$converterintensityn.toSql(intensity.value),
      );
    }
    if (quality.present) {
      map['quality'] = Variable<int>(quality.value);
    }
    if (moodAfter.present) {
      map['mood_after'] = Variable<int>(moodAfter.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (noteLower.present) {
      map['note_lower'] = Variable<String>(noteLower.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationMin: $durationMin, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('nameLower: $nameLower, ')
          ..write('intensity: $intensity, ')
          ..write('quality: $quality, ')
          ..write('moodAfter: $moodAfter, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExpenseCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ExpenseCategory>($ExpensesTable.$convertercategory);
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionLowerMeta = const VerificationMeta(
    'descriptionLower',
  );
  @override
  late final GeneratedColumn<String> descriptionLower = GeneratedColumn<String>(
    'description_lower',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMethod?, String>
  paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<PaymentMethod?>($ExpensesTable.$converterpaymentMethodn);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteLowerMeta = const VerificationMeta(
    'noteLower',
  );
  @override
  late final GeneratedColumn<String> noteLower = GeneratedColumn<String>(
    'note_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    time,
    amountCents,
    category,
    description,
    descriptionLower,
    paymentMethod,
    note,
    noteLower,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('description_lower')) {
      context.handle(
        _descriptionLowerMeta,
        descriptionLower.isAcceptableOrUnknown(
          data['description_lower']!,
          _descriptionLowerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionLowerMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('note_lower')) {
      context.handle(
        _noteLowerMeta,
        noteLower.isAcceptableOrUnknown(data['note_lower']!, _noteLowerMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      ),
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      category: $ExpensesTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      descriptionLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_lower'],
      )!,
      paymentMethod: $ExpensesTable.$converterpaymentMethodn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payment_method'],
        ),
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      noteLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_lower'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }

  static TypeConverter<ExpenseCategory, String> $convertercategory =
      expenseCategoryConverter;
  static TypeConverter<PaymentMethod, String> $converterpaymentMethod =
      paymentMethodConverter;
  static TypeConverter<PaymentMethod?, String?> $converterpaymentMethodn =
      NullAwareTypeConverter.wrap($converterpaymentMethod);
}

class Expense extends DataClass implements Insertable<Expense> {
  final String id;
  final String date;
  final String? time;
  final int amountCents;
  final ExpenseCategory category;
  final String description;
  final String descriptionLower;
  final PaymentMethod? paymentMethod;
  final String? note;
  final String? noteLower;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Expense({
    required this.id,
    required this.date,
    this.time,
    required this.amountCents,
    required this.category,
    required this.description,
    required this.descriptionLower,
    this.paymentMethod,
    this.note,
    this.noteLower,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || time != null) {
      map['time'] = Variable<String>(time);
    }
    map['amount_cents'] = Variable<int>(amountCents);
    {
      map['category'] = Variable<String>(
        $ExpensesTable.$convertercategory.toSql(category),
      );
    }
    map['description'] = Variable<String>(description);
    map['description_lower'] = Variable<String>(descriptionLower);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(
        $ExpensesTable.$converterpaymentMethodn.toSql(paymentMethod),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || noteLower != null) {
      map['note_lower'] = Variable<String>(noteLower);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      date: Value(date),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
      amountCents: Value(amountCents),
      category: Value(category),
      description: Value(description),
      descriptionLower: Value(descriptionLower),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      noteLower: noteLower == null && nullToAbsent
          ? const Value.absent()
          : Value(noteLower),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      time: serializer.fromJson<String?>(json['time']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      category: serializer.fromJson<ExpenseCategory>(json['category']),
      description: serializer.fromJson<String>(json['description']),
      descriptionLower: serializer.fromJson<String>(json['descriptionLower']),
      paymentMethod: serializer.fromJson<PaymentMethod?>(json['paymentMethod']),
      note: serializer.fromJson<String?>(json['note']),
      noteLower: serializer.fromJson<String?>(json['noteLower']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'time': serializer.toJson<String?>(time),
      'amountCents': serializer.toJson<int>(amountCents),
      'category': serializer.toJson<ExpenseCategory>(category),
      'description': serializer.toJson<String>(description),
      'descriptionLower': serializer.toJson<String>(descriptionLower),
      'paymentMethod': serializer.toJson<PaymentMethod?>(paymentMethod),
      'note': serializer.toJson<String?>(note),
      'noteLower': serializer.toJson<String?>(noteLower),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Expense copyWith({
    String? id,
    String? date,
    Value<String?> time = const Value.absent(),
    int? amountCents,
    ExpenseCategory? category,
    String? description,
    String? descriptionLower,
    Value<PaymentMethod?> paymentMethod = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> noteLower = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Expense(
    id: id ?? this.id,
    date: date ?? this.date,
    time: time.present ? time.value : this.time,
    amountCents: amountCents ?? this.amountCents,
    category: category ?? this.category,
    description: description ?? this.description,
    descriptionLower: descriptionLower ?? this.descriptionLower,
    paymentMethod: paymentMethod.present
        ? paymentMethod.value
        : this.paymentMethod,
    note: note.present ? note.value : this.note,
    noteLower: noteLower.present ? noteLower.value : this.noteLower,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      time: data.time.present ? data.time.value : this.time,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      descriptionLower: data.descriptionLower.present
          ? data.descriptionLower.value
          : this.descriptionLower,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      note: data.note.present ? data.note.value : this.note,
      noteLower: data.noteLower.present ? data.noteLower.value : this.noteLower,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('amountCents: $amountCents, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('descriptionLower: $descriptionLower, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    time,
    amountCents,
    category,
    description,
    descriptionLower,
    paymentMethod,
    note,
    noteLower,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.date == this.date &&
          other.time == this.time &&
          other.amountCents == this.amountCents &&
          other.category == this.category &&
          other.description == this.description &&
          other.descriptionLower == this.descriptionLower &&
          other.paymentMethod == this.paymentMethod &&
          other.note == this.note &&
          other.noteLower == this.noteLower &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<String> id;
  final Value<String> date;
  final Value<String?> time;
  final Value<int> amountCents;
  final Value<ExpenseCategory> category;
  final Value<String> description;
  final Value<String> descriptionLower;
  final Value<PaymentMethod?> paymentMethod;
  final Value<String?> note;
  final Value<String?> noteLower;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.descriptionLower = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesCompanion.insert({
    required String id,
    required String date,
    this.time = const Value.absent(),
    required int amountCents,
    required ExpenseCategory category,
    required String description,
    required String descriptionLower,
    this.paymentMethod = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       amountCents = Value(amountCents),
       category = Value(category),
       description = Value(description),
       descriptionLower = Value(descriptionLower),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Expense> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<String>? time,
    Expression<int>? amountCents,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? descriptionLower,
    Expression<String>? paymentMethod,
    Expression<String>? note,
    Expression<String>? noteLower,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (amountCents != null) 'amount_cents': amountCents,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (descriptionLower != null) 'description_lower': descriptionLower,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (note != null) 'note': note,
      if (noteLower != null) 'note_lower': noteLower,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<String?>? time,
    Value<int>? amountCents,
    Value<ExpenseCategory>? category,
    Value<String>? description,
    Value<String>? descriptionLower,
    Value<PaymentMethod?>? paymentMethod,
    Value<String?>? note,
    Value<String?>? noteLower,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      amountCents: amountCents ?? this.amountCents,
      category: category ?? this.category,
      description: description ?? this.description,
      descriptionLower: descriptionLower ?? this.descriptionLower,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
      noteLower: noteLower ?? this.noteLower,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $ExpensesTable.$convertercategory.toSql(category.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (descriptionLower.present) {
      map['description_lower'] = Variable<String>(descriptionLower.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(
        $ExpensesTable.$converterpaymentMethodn.toSql(paymentMethod.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (noteLower.present) {
      map['note_lower'] = Variable<String>(noteLower.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('amountCents: $amountCents, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('descriptionLower: $descriptionLower, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IncomeTable extends Income with TableInfo<$IncomeTable, IncomeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceLowerMeta = const VerificationMeta(
    'sourceLower',
  );
  @override
  late final GeneratedColumn<String> sourceLower = GeneratedColumn<String>(
    'source_lower',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<IncomeCategory, String> category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<IncomeCategory>($IncomeTable.$convertercategory);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteLowerMeta = const VerificationMeta(
    'noteLower',
  );
  @override
  late final GeneratedColumn<String> noteLower = GeneratedColumn<String>(
    'note_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    amountCents,
    source,
    sourceLower,
    category,
    note,
    noteLower,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('source_lower')) {
      context.handle(
        _sourceLowerMeta,
        sourceLower.isAcceptableOrUnknown(
          data['source_lower']!,
          _sourceLowerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceLowerMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('note_lower')) {
      context.handle(
        _noteLowerMeta,
        noteLower.isAcceptableOrUnknown(data['note_lower']!, _noteLowerMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncomeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      sourceLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_lower'],
      )!,
      category: $IncomeTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      noteLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_lower'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $IncomeTable createAlias(String alias) {
    return $IncomeTable(attachedDatabase, alias);
  }

  static TypeConverter<IncomeCategory, String> $convertercategory =
      incomeCategoryConverter;
}

class IncomeEntry extends DataClass implements Insertable<IncomeEntry> {
  final String id;
  final String date;
  final int amountCents;
  final String source;
  final String sourceLower;
  final IncomeCategory category;
  final String? note;
  final String? noteLower;
  final DateTime createdAt;
  final DateTime updatedAt;
  const IncomeEntry({
    required this.id,
    required this.date,
    required this.amountCents,
    required this.source,
    required this.sourceLower,
    required this.category,
    this.note,
    this.noteLower,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['amount_cents'] = Variable<int>(amountCents);
    map['source'] = Variable<String>(source);
    map['source_lower'] = Variable<String>(sourceLower);
    {
      map['category'] = Variable<String>(
        $IncomeTable.$convertercategory.toSql(category),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || noteLower != null) {
      map['note_lower'] = Variable<String>(noteLower);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  IncomeCompanion toCompanion(bool nullToAbsent) {
    return IncomeCompanion(
      id: Value(id),
      date: Value(date),
      amountCents: Value(amountCents),
      source: Value(source),
      sourceLower: Value(sourceLower),
      category: Value(category),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      noteLower: noteLower == null && nullToAbsent
          ? const Value.absent()
          : Value(noteLower),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory IncomeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeEntry(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      source: serializer.fromJson<String>(json['source']),
      sourceLower: serializer.fromJson<String>(json['sourceLower']),
      category: serializer.fromJson<IncomeCategory>(json['category']),
      note: serializer.fromJson<String?>(json['note']),
      noteLower: serializer.fromJson<String?>(json['noteLower']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'amountCents': serializer.toJson<int>(amountCents),
      'source': serializer.toJson<String>(source),
      'sourceLower': serializer.toJson<String>(sourceLower),
      'category': serializer.toJson<IncomeCategory>(category),
      'note': serializer.toJson<String?>(note),
      'noteLower': serializer.toJson<String?>(noteLower),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  IncomeEntry copyWith({
    String? id,
    String? date,
    int? amountCents,
    String? source,
    String? sourceLower,
    IncomeCategory? category,
    Value<String?> note = const Value.absent(),
    Value<String?> noteLower = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => IncomeEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    amountCents: amountCents ?? this.amountCents,
    source: source ?? this.source,
    sourceLower: sourceLower ?? this.sourceLower,
    category: category ?? this.category,
    note: note.present ? note.value : this.note,
    noteLower: noteLower.present ? noteLower.value : this.noteLower,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  IncomeEntry copyWithCompanion(IncomeCompanion data) {
    return IncomeEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      source: data.source.present ? data.source.value : this.source,
      sourceLower: data.sourceLower.present
          ? data.sourceLower.value
          : this.sourceLower,
      category: data.category.present ? data.category.value : this.category,
      note: data.note.present ? data.note.value : this.note,
      noteLower: data.noteLower.present ? data.noteLower.value : this.noteLower,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('amountCents: $amountCents, ')
          ..write('source: $source, ')
          ..write('sourceLower: $sourceLower, ')
          ..write('category: $category, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    amountCents,
    source,
    sourceLower,
    category,
    note,
    noteLower,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.amountCents == this.amountCents &&
          other.source == this.source &&
          other.sourceLower == this.sourceLower &&
          other.category == this.category &&
          other.note == this.note &&
          other.noteLower == this.noteLower &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class IncomeCompanion extends UpdateCompanion<IncomeEntry> {
  final Value<String> id;
  final Value<String> date;
  final Value<int> amountCents;
  final Value<String> source;
  final Value<String> sourceLower;
  final Value<IncomeCategory> category;
  final Value<String?> note;
  final Value<String?> noteLower;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const IncomeCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceLower = const Value.absent(),
    this.category = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeCompanion.insert({
    required String id,
    required String date,
    required int amountCents,
    required String source,
    required String sourceLower,
    required IncomeCategory category,
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       amountCents = Value(amountCents),
       source = Value(source),
       sourceLower = Value(sourceLower),
       category = Value(category),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<IncomeEntry> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<int>? amountCents,
    Expression<String>? source,
    Expression<String>? sourceLower,
    Expression<String>? category,
    Expression<String>? note,
    Expression<String>? noteLower,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (amountCents != null) 'amount_cents': amountCents,
      if (source != null) 'source': source,
      if (sourceLower != null) 'source_lower': sourceLower,
      if (category != null) 'category': category,
      if (note != null) 'note': note,
      if (noteLower != null) 'note_lower': noteLower,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<int>? amountCents,
    Value<String>? source,
    Value<String>? sourceLower,
    Value<IncomeCategory>? category,
    Value<String?>? note,
    Value<String?>? noteLower,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return IncomeCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      amountCents: amountCents ?? this.amountCents,
      source: source ?? this.source,
      sourceLower: sourceLower ?? this.sourceLower,
      category: category ?? this.category,
      note: note ?? this.note,
      noteLower: noteLower ?? this.noteLower,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceLower.present) {
      map['source_lower'] = Variable<String>(sourceLower.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $IncomeTable.$convertercategory.toSql(category.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (noteLower.present) {
      map['note_lower'] = Variable<String>(noteLower.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('amountCents: $amountCents, ')
          ..write('source: $source, ')
          ..write('sourceLower: $sourceLower, ')
          ..write('category: $category, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HealthEventsTable extends HealthEvents
    with TableInfo<$HealthEventsTable, HealthEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<HealthEventType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<HealthEventType>($HealthEventsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<DentalSubtype?, String> subtype =
      GeneratedColumn<String>(
        'subtype',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DentalSubtype?>($HealthEventsTable.$convertersubtypen);
  static const VerificationMeta _clinicMeta = const VerificationMeta('clinic');
  @override
  late final GeneratedColumn<String> clinic = GeneratedColumn<String>(
    'clinic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clinicLowerMeta = const VerificationMeta(
    'clinicLower',
  );
  @override
  late final GeneratedColumn<String> clinicLower = GeneratedColumn<String>(
    'clinic_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonLowerMeta = const VerificationMeta(
    'reasonLower',
  );
  @override
  late final GeneratedColumn<String> reasonLower = GeneratedColumn<String>(
    'reason_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _whatWasDoneMeta = const VerificationMeta(
    'whatWasDone',
  );
  @override
  late final GeneratedColumn<String> whatWasDone = GeneratedColumn<String>(
    'what_was_done',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _whatWasDoneLowerMeta = const VerificationMeta(
    'whatWasDoneLower',
  );
  @override
  late final GeneratedColumn<String> whatWasDoneLower = GeneratedColumn<String>(
    'what_was_done_lower',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceCentsMeta = const VerificationMeta(
    'priceCents',
  );
  @override
  late final GeneratedColumn<int> priceCents = GeneratedColumn<int>(
    'price_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextRecommendedDateMeta =
      const VerificationMeta('nextRecommendedDate');
  @override
  late final GeneratedColumn<String> nextRecommendedDate =
      GeneratedColumn<String>(
        'next_recommended_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteLowerMeta = const VerificationMeta(
    'noteLower',
  );
  @override
  late final GeneratedColumn<String> noteLower = GeneratedColumn<String>(
    'note_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    type,
    subtype,
    clinic,
    clinicLower,
    reason,
    reasonLower,
    whatWasDone,
    whatWasDoneLower,
    priceCents,
    nextRecommendedDate,
    note,
    noteLower,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<HealthEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('clinic')) {
      context.handle(
        _clinicMeta,
        clinic.isAcceptableOrUnknown(data['clinic']!, _clinicMeta),
      );
    }
    if (data.containsKey('clinic_lower')) {
      context.handle(
        _clinicLowerMeta,
        clinicLower.isAcceptableOrUnknown(
          data['clinic_lower']!,
          _clinicLowerMeta,
        ),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('reason_lower')) {
      context.handle(
        _reasonLowerMeta,
        reasonLower.isAcceptableOrUnknown(
          data['reason_lower']!,
          _reasonLowerMeta,
        ),
      );
    }
    if (data.containsKey('what_was_done')) {
      context.handle(
        _whatWasDoneMeta,
        whatWasDone.isAcceptableOrUnknown(
          data['what_was_done']!,
          _whatWasDoneMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_whatWasDoneMeta);
    }
    if (data.containsKey('what_was_done_lower')) {
      context.handle(
        _whatWasDoneLowerMeta,
        whatWasDoneLower.isAcceptableOrUnknown(
          data['what_was_done_lower']!,
          _whatWasDoneLowerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_whatWasDoneLowerMeta);
    }
    if (data.containsKey('price_cents')) {
      context.handle(
        _priceCentsMeta,
        priceCents.isAcceptableOrUnknown(data['price_cents']!, _priceCentsMeta),
      );
    }
    if (data.containsKey('next_recommended_date')) {
      context.handle(
        _nextRecommendedDateMeta,
        nextRecommendedDate.isAcceptableOrUnknown(
          data['next_recommended_date']!,
          _nextRecommendedDateMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('note_lower')) {
      context.handle(
        _noteLowerMeta,
        noteLower.isAcceptableOrUnknown(data['note_lower']!, _noteLowerMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HealthEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      type: $HealthEventsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      subtype: $HealthEventsTable.$convertersubtypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}subtype'],
        ),
      ),
      clinic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clinic'],
      ),
      clinicLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clinic_lower'],
      ),
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      reasonLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_lower'],
      ),
      whatWasDone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}what_was_done'],
      )!,
      whatWasDoneLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}what_was_done_lower'],
      )!,
      priceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_cents'],
      ),
      nextRecommendedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_recommended_date'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      noteLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_lower'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HealthEventsTable createAlias(String alias) {
    return $HealthEventsTable(attachedDatabase, alias);
  }

  static TypeConverter<HealthEventType, String> $convertertype =
      healthEventTypeConverter;
  static TypeConverter<DentalSubtype, String> $convertersubtype =
      dentalSubtypeConverter;
  static TypeConverter<DentalSubtype?, String?> $convertersubtypen =
      NullAwareTypeConverter.wrap($convertersubtype);
}

class HealthEvent extends DataClass implements Insertable<HealthEvent> {
  final String id;
  final String date;
  final HealthEventType type;
  final DentalSubtype? subtype;
  final String? clinic;
  final String? clinicLower;
  final String? reason;
  final String? reasonLower;
  final String whatWasDone;
  final String whatWasDoneLower;
  final int? priceCents;
  final String? nextRecommendedDate;
  final String? note;
  final String? noteLower;
  final DateTime createdAt;
  final DateTime updatedAt;
  const HealthEvent({
    required this.id,
    required this.date,
    required this.type,
    this.subtype,
    this.clinic,
    this.clinicLower,
    this.reason,
    this.reasonLower,
    required this.whatWasDone,
    required this.whatWasDoneLower,
    this.priceCents,
    this.nextRecommendedDate,
    this.note,
    this.noteLower,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    {
      map['type'] = Variable<String>(
        $HealthEventsTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || subtype != null) {
      map['subtype'] = Variable<String>(
        $HealthEventsTable.$convertersubtypen.toSql(subtype),
      );
    }
    if (!nullToAbsent || clinic != null) {
      map['clinic'] = Variable<String>(clinic);
    }
    if (!nullToAbsent || clinicLower != null) {
      map['clinic_lower'] = Variable<String>(clinicLower);
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || reasonLower != null) {
      map['reason_lower'] = Variable<String>(reasonLower);
    }
    map['what_was_done'] = Variable<String>(whatWasDone);
    map['what_was_done_lower'] = Variable<String>(whatWasDoneLower);
    if (!nullToAbsent || priceCents != null) {
      map['price_cents'] = Variable<int>(priceCents);
    }
    if (!nullToAbsent || nextRecommendedDate != null) {
      map['next_recommended_date'] = Variable<String>(nextRecommendedDate);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || noteLower != null) {
      map['note_lower'] = Variable<String>(noteLower);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HealthEventsCompanion toCompanion(bool nullToAbsent) {
    return HealthEventsCompanion(
      id: Value(id),
      date: Value(date),
      type: Value(type),
      subtype: subtype == null && nullToAbsent
          ? const Value.absent()
          : Value(subtype),
      clinic: clinic == null && nullToAbsent
          ? const Value.absent()
          : Value(clinic),
      clinicLower: clinicLower == null && nullToAbsent
          ? const Value.absent()
          : Value(clinicLower),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      reasonLower: reasonLower == null && nullToAbsent
          ? const Value.absent()
          : Value(reasonLower),
      whatWasDone: Value(whatWasDone),
      whatWasDoneLower: Value(whatWasDoneLower),
      priceCents: priceCents == null && nullToAbsent
          ? const Value.absent()
          : Value(priceCents),
      nextRecommendedDate: nextRecommendedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRecommendedDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      noteLower: noteLower == null && nullToAbsent
          ? const Value.absent()
          : Value(noteLower),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HealthEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthEvent(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      type: serializer.fromJson<HealthEventType>(json['type']),
      subtype: serializer.fromJson<DentalSubtype?>(json['subtype']),
      clinic: serializer.fromJson<String?>(json['clinic']),
      clinicLower: serializer.fromJson<String?>(json['clinicLower']),
      reason: serializer.fromJson<String?>(json['reason']),
      reasonLower: serializer.fromJson<String?>(json['reasonLower']),
      whatWasDone: serializer.fromJson<String>(json['whatWasDone']),
      whatWasDoneLower: serializer.fromJson<String>(json['whatWasDoneLower']),
      priceCents: serializer.fromJson<int?>(json['priceCents']),
      nextRecommendedDate: serializer.fromJson<String?>(
        json['nextRecommendedDate'],
      ),
      note: serializer.fromJson<String?>(json['note']),
      noteLower: serializer.fromJson<String?>(json['noteLower']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'type': serializer.toJson<HealthEventType>(type),
      'subtype': serializer.toJson<DentalSubtype?>(subtype),
      'clinic': serializer.toJson<String?>(clinic),
      'clinicLower': serializer.toJson<String?>(clinicLower),
      'reason': serializer.toJson<String?>(reason),
      'reasonLower': serializer.toJson<String?>(reasonLower),
      'whatWasDone': serializer.toJson<String>(whatWasDone),
      'whatWasDoneLower': serializer.toJson<String>(whatWasDoneLower),
      'priceCents': serializer.toJson<int?>(priceCents),
      'nextRecommendedDate': serializer.toJson<String?>(nextRecommendedDate),
      'note': serializer.toJson<String?>(note),
      'noteLower': serializer.toJson<String?>(noteLower),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HealthEvent copyWith({
    String? id,
    String? date,
    HealthEventType? type,
    Value<DentalSubtype?> subtype = const Value.absent(),
    Value<String?> clinic = const Value.absent(),
    Value<String?> clinicLower = const Value.absent(),
    Value<String?> reason = const Value.absent(),
    Value<String?> reasonLower = const Value.absent(),
    String? whatWasDone,
    String? whatWasDoneLower,
    Value<int?> priceCents = const Value.absent(),
    Value<String?> nextRecommendedDate = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> noteLower = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => HealthEvent(
    id: id ?? this.id,
    date: date ?? this.date,
    type: type ?? this.type,
    subtype: subtype.present ? subtype.value : this.subtype,
    clinic: clinic.present ? clinic.value : this.clinic,
    clinicLower: clinicLower.present ? clinicLower.value : this.clinicLower,
    reason: reason.present ? reason.value : this.reason,
    reasonLower: reasonLower.present ? reasonLower.value : this.reasonLower,
    whatWasDone: whatWasDone ?? this.whatWasDone,
    whatWasDoneLower: whatWasDoneLower ?? this.whatWasDoneLower,
    priceCents: priceCents.present ? priceCents.value : this.priceCents,
    nextRecommendedDate: nextRecommendedDate.present
        ? nextRecommendedDate.value
        : this.nextRecommendedDate,
    note: note.present ? note.value : this.note,
    noteLower: noteLower.present ? noteLower.value : this.noteLower,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HealthEvent copyWithCompanion(HealthEventsCompanion data) {
    return HealthEvent(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      subtype: data.subtype.present ? data.subtype.value : this.subtype,
      clinic: data.clinic.present ? data.clinic.value : this.clinic,
      clinicLower: data.clinicLower.present
          ? data.clinicLower.value
          : this.clinicLower,
      reason: data.reason.present ? data.reason.value : this.reason,
      reasonLower: data.reasonLower.present
          ? data.reasonLower.value
          : this.reasonLower,
      whatWasDone: data.whatWasDone.present
          ? data.whatWasDone.value
          : this.whatWasDone,
      whatWasDoneLower: data.whatWasDoneLower.present
          ? data.whatWasDoneLower.value
          : this.whatWasDoneLower,
      priceCents: data.priceCents.present
          ? data.priceCents.value
          : this.priceCents,
      nextRecommendedDate: data.nextRecommendedDate.present
          ? data.nextRecommendedDate.value
          : this.nextRecommendedDate,
      note: data.note.present ? data.note.value : this.note,
      noteLower: data.noteLower.present ? data.noteLower.value : this.noteLower,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthEvent(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('subtype: $subtype, ')
          ..write('clinic: $clinic, ')
          ..write('clinicLower: $clinicLower, ')
          ..write('reason: $reason, ')
          ..write('reasonLower: $reasonLower, ')
          ..write('whatWasDone: $whatWasDone, ')
          ..write('whatWasDoneLower: $whatWasDoneLower, ')
          ..write('priceCents: $priceCents, ')
          ..write('nextRecommendedDate: $nextRecommendedDate, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    type,
    subtype,
    clinic,
    clinicLower,
    reason,
    reasonLower,
    whatWasDone,
    whatWasDoneLower,
    priceCents,
    nextRecommendedDate,
    note,
    noteLower,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthEvent &&
          other.id == this.id &&
          other.date == this.date &&
          other.type == this.type &&
          other.subtype == this.subtype &&
          other.clinic == this.clinic &&
          other.clinicLower == this.clinicLower &&
          other.reason == this.reason &&
          other.reasonLower == this.reasonLower &&
          other.whatWasDone == this.whatWasDone &&
          other.whatWasDoneLower == this.whatWasDoneLower &&
          other.priceCents == this.priceCents &&
          other.nextRecommendedDate == this.nextRecommendedDate &&
          other.note == this.note &&
          other.noteLower == this.noteLower &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HealthEventsCompanion extends UpdateCompanion<HealthEvent> {
  final Value<String> id;
  final Value<String> date;
  final Value<HealthEventType> type;
  final Value<DentalSubtype?> subtype;
  final Value<String?> clinic;
  final Value<String?> clinicLower;
  final Value<String?> reason;
  final Value<String?> reasonLower;
  final Value<String> whatWasDone;
  final Value<String> whatWasDoneLower;
  final Value<int?> priceCents;
  final Value<String?> nextRecommendedDate;
  final Value<String?> note;
  final Value<String?> noteLower;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HealthEventsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.subtype = const Value.absent(),
    this.clinic = const Value.absent(),
    this.clinicLower = const Value.absent(),
    this.reason = const Value.absent(),
    this.reasonLower = const Value.absent(),
    this.whatWasDone = const Value.absent(),
    this.whatWasDoneLower = const Value.absent(),
    this.priceCents = const Value.absent(),
    this.nextRecommendedDate = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HealthEventsCompanion.insert({
    required String id,
    required String date,
    required HealthEventType type,
    this.subtype = const Value.absent(),
    this.clinic = const Value.absent(),
    this.clinicLower = const Value.absent(),
    this.reason = const Value.absent(),
    this.reasonLower = const Value.absent(),
    required String whatWasDone,
    required String whatWasDoneLower,
    this.priceCents = const Value.absent(),
    this.nextRecommendedDate = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       type = Value(type),
       whatWasDone = Value(whatWasDone),
       whatWasDoneLower = Value(whatWasDoneLower),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<HealthEvent> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<String>? type,
    Expression<String>? subtype,
    Expression<String>? clinic,
    Expression<String>? clinicLower,
    Expression<String>? reason,
    Expression<String>? reasonLower,
    Expression<String>? whatWasDone,
    Expression<String>? whatWasDoneLower,
    Expression<int>? priceCents,
    Expression<String>? nextRecommendedDate,
    Expression<String>? note,
    Expression<String>? noteLower,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (subtype != null) 'subtype': subtype,
      if (clinic != null) 'clinic': clinic,
      if (clinicLower != null) 'clinic_lower': clinicLower,
      if (reason != null) 'reason': reason,
      if (reasonLower != null) 'reason_lower': reasonLower,
      if (whatWasDone != null) 'what_was_done': whatWasDone,
      if (whatWasDoneLower != null) 'what_was_done_lower': whatWasDoneLower,
      if (priceCents != null) 'price_cents': priceCents,
      if (nextRecommendedDate != null)
        'next_recommended_date': nextRecommendedDate,
      if (note != null) 'note': note,
      if (noteLower != null) 'note_lower': noteLower,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HealthEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<HealthEventType>? type,
    Value<DentalSubtype?>? subtype,
    Value<String?>? clinic,
    Value<String?>? clinicLower,
    Value<String?>? reason,
    Value<String?>? reasonLower,
    Value<String>? whatWasDone,
    Value<String>? whatWasDoneLower,
    Value<int?>? priceCents,
    Value<String?>? nextRecommendedDate,
    Value<String?>? note,
    Value<String?>? noteLower,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return HealthEventsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      subtype: subtype ?? this.subtype,
      clinic: clinic ?? this.clinic,
      clinicLower: clinicLower ?? this.clinicLower,
      reason: reason ?? this.reason,
      reasonLower: reasonLower ?? this.reasonLower,
      whatWasDone: whatWasDone ?? this.whatWasDone,
      whatWasDoneLower: whatWasDoneLower ?? this.whatWasDoneLower,
      priceCents: priceCents ?? this.priceCents,
      nextRecommendedDate: nextRecommendedDate ?? this.nextRecommendedDate,
      note: note ?? this.note,
      noteLower: noteLower ?? this.noteLower,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $HealthEventsTable.$convertertype.toSql(type.value),
      );
    }
    if (subtype.present) {
      map['subtype'] = Variable<String>(
        $HealthEventsTable.$convertersubtypen.toSql(subtype.value),
      );
    }
    if (clinic.present) {
      map['clinic'] = Variable<String>(clinic.value);
    }
    if (clinicLower.present) {
      map['clinic_lower'] = Variable<String>(clinicLower.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (reasonLower.present) {
      map['reason_lower'] = Variable<String>(reasonLower.value);
    }
    if (whatWasDone.present) {
      map['what_was_done'] = Variable<String>(whatWasDone.value);
    }
    if (whatWasDoneLower.present) {
      map['what_was_done_lower'] = Variable<String>(whatWasDoneLower.value);
    }
    if (priceCents.present) {
      map['price_cents'] = Variable<int>(priceCents.value);
    }
    if (nextRecommendedDate.present) {
      map['next_recommended_date'] = Variable<String>(
        nextRecommendedDate.value,
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (noteLower.present) {
      map['note_lower'] = Variable<String>(noteLower.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthEventsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('subtype: $subtype, ')
          ..write('clinic: $clinic, ')
          ..write('clinicLower: $clinicLower, ')
          ..write('reason: $reason, ')
          ..write('reasonLower: $reasonLower, ')
          ..write('whatWasDone: $whatWasDone, ')
          ..write('whatWasDoneLower: $whatWasDoneLower, ')
          ..write('priceCents: $priceCents, ')
          ..write('nextRecommendedDate: $nextRecommendedDate, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LabTestsTable extends LabTests with TableInfo<$LabTestsTable, LabTest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabTestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labMeta = const VerificationMeta('lab');
  @override
  late final GeneratedColumn<String> lab = GeneratedColumn<String>(
    'lab',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labLowerMeta = const VerificationMeta(
    'labLower',
  );
  @override
  late final GeneratedColumn<String> labLower = GeneratedColumn<String>(
    'lab_lower',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonLowerMeta = const VerificationMeta(
    'reasonLower',
  );
  @override
  late final GeneratedColumn<String> reasonLower = GeneratedColumn<String>(
    'reason_lower',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resultsTextMeta = const VerificationMeta(
    'resultsText',
  );
  @override
  late final GeneratedColumn<String> resultsText = GeneratedColumn<String>(
    'results_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resultsTextLowerMeta = const VerificationMeta(
    'resultsTextLower',
  );
  @override
  late final GeneratedColumn<String> resultsTextLower = GeneratedColumn<String>(
    'results_text_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteLowerMeta = const VerificationMeta(
    'noteLower',
  );
  @override
  late final GeneratedColumn<String> noteLower = GeneratedColumn<String>(
    'note_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    lab,
    labLower,
    reason,
    reasonLower,
    resultsText,
    resultsTextLower,
    note,
    noteLower,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lab_tests';
  @override
  VerificationContext validateIntegrity(
    Insertable<LabTest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('lab')) {
      context.handle(
        _labMeta,
        lab.isAcceptableOrUnknown(data['lab']!, _labMeta),
      );
    } else if (isInserting) {
      context.missing(_labMeta);
    }
    if (data.containsKey('lab_lower')) {
      context.handle(
        _labLowerMeta,
        labLower.isAcceptableOrUnknown(data['lab_lower']!, _labLowerMeta),
      );
    } else if (isInserting) {
      context.missing(_labLowerMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('reason_lower')) {
      context.handle(
        _reasonLowerMeta,
        reasonLower.isAcceptableOrUnknown(
          data['reason_lower']!,
          _reasonLowerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reasonLowerMeta);
    }
    if (data.containsKey('results_text')) {
      context.handle(
        _resultsTextMeta,
        resultsText.isAcceptableOrUnknown(
          data['results_text']!,
          _resultsTextMeta,
        ),
      );
    }
    if (data.containsKey('results_text_lower')) {
      context.handle(
        _resultsTextLowerMeta,
        resultsTextLower.isAcceptableOrUnknown(
          data['results_text_lower']!,
          _resultsTextLowerMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('note_lower')) {
      context.handle(
        _noteLowerMeta,
        noteLower.isAcceptableOrUnknown(data['note_lower']!, _noteLowerMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LabTest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LabTest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      lab: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lab'],
      )!,
      labLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lab_lower'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      reasonLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_lower'],
      )!,
      resultsText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}results_text'],
      ),
      resultsTextLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}results_text_lower'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      noteLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_lower'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LabTestsTable createAlias(String alias) {
    return $LabTestsTable(attachedDatabase, alias);
  }
}

class LabTest extends DataClass implements Insertable<LabTest> {
  final String id;
  final String date;
  final String lab;
  final String labLower;
  final String reason;
  final String reasonLower;
  final String? resultsText;
  final String? resultsTextLower;
  final String? note;
  final String? noteLower;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LabTest({
    required this.id,
    required this.date,
    required this.lab,
    required this.labLower,
    required this.reason,
    required this.reasonLower,
    this.resultsText,
    this.resultsTextLower,
    this.note,
    this.noteLower,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['lab'] = Variable<String>(lab);
    map['lab_lower'] = Variable<String>(labLower);
    map['reason'] = Variable<String>(reason);
    map['reason_lower'] = Variable<String>(reasonLower);
    if (!nullToAbsent || resultsText != null) {
      map['results_text'] = Variable<String>(resultsText);
    }
    if (!nullToAbsent || resultsTextLower != null) {
      map['results_text_lower'] = Variable<String>(resultsTextLower);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || noteLower != null) {
      map['note_lower'] = Variable<String>(noteLower);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LabTestsCompanion toCompanion(bool nullToAbsent) {
    return LabTestsCompanion(
      id: Value(id),
      date: Value(date),
      lab: Value(lab),
      labLower: Value(labLower),
      reason: Value(reason),
      reasonLower: Value(reasonLower),
      resultsText: resultsText == null && nullToAbsent
          ? const Value.absent()
          : Value(resultsText),
      resultsTextLower: resultsTextLower == null && nullToAbsent
          ? const Value.absent()
          : Value(resultsTextLower),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      noteLower: noteLower == null && nullToAbsent
          ? const Value.absent()
          : Value(noteLower),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LabTest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LabTest(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      lab: serializer.fromJson<String>(json['lab']),
      labLower: serializer.fromJson<String>(json['labLower']),
      reason: serializer.fromJson<String>(json['reason']),
      reasonLower: serializer.fromJson<String>(json['reasonLower']),
      resultsText: serializer.fromJson<String?>(json['resultsText']),
      resultsTextLower: serializer.fromJson<String?>(json['resultsTextLower']),
      note: serializer.fromJson<String?>(json['note']),
      noteLower: serializer.fromJson<String?>(json['noteLower']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'lab': serializer.toJson<String>(lab),
      'labLower': serializer.toJson<String>(labLower),
      'reason': serializer.toJson<String>(reason),
      'reasonLower': serializer.toJson<String>(reasonLower),
      'resultsText': serializer.toJson<String?>(resultsText),
      'resultsTextLower': serializer.toJson<String?>(resultsTextLower),
      'note': serializer.toJson<String?>(note),
      'noteLower': serializer.toJson<String?>(noteLower),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LabTest copyWith({
    String? id,
    String? date,
    String? lab,
    String? labLower,
    String? reason,
    String? reasonLower,
    Value<String?> resultsText = const Value.absent(),
    Value<String?> resultsTextLower = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> noteLower = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LabTest(
    id: id ?? this.id,
    date: date ?? this.date,
    lab: lab ?? this.lab,
    labLower: labLower ?? this.labLower,
    reason: reason ?? this.reason,
    reasonLower: reasonLower ?? this.reasonLower,
    resultsText: resultsText.present ? resultsText.value : this.resultsText,
    resultsTextLower: resultsTextLower.present
        ? resultsTextLower.value
        : this.resultsTextLower,
    note: note.present ? note.value : this.note,
    noteLower: noteLower.present ? noteLower.value : this.noteLower,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LabTest copyWithCompanion(LabTestsCompanion data) {
    return LabTest(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      lab: data.lab.present ? data.lab.value : this.lab,
      labLower: data.labLower.present ? data.labLower.value : this.labLower,
      reason: data.reason.present ? data.reason.value : this.reason,
      reasonLower: data.reasonLower.present
          ? data.reasonLower.value
          : this.reasonLower,
      resultsText: data.resultsText.present
          ? data.resultsText.value
          : this.resultsText,
      resultsTextLower: data.resultsTextLower.present
          ? data.resultsTextLower.value
          : this.resultsTextLower,
      note: data.note.present ? data.note.value : this.note,
      noteLower: data.noteLower.present ? data.noteLower.value : this.noteLower,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LabTest(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('lab: $lab, ')
          ..write('labLower: $labLower, ')
          ..write('reason: $reason, ')
          ..write('reasonLower: $reasonLower, ')
          ..write('resultsText: $resultsText, ')
          ..write('resultsTextLower: $resultsTextLower, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    lab,
    labLower,
    reason,
    reasonLower,
    resultsText,
    resultsTextLower,
    note,
    noteLower,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LabTest &&
          other.id == this.id &&
          other.date == this.date &&
          other.lab == this.lab &&
          other.labLower == this.labLower &&
          other.reason == this.reason &&
          other.reasonLower == this.reasonLower &&
          other.resultsText == this.resultsText &&
          other.resultsTextLower == this.resultsTextLower &&
          other.note == this.note &&
          other.noteLower == this.noteLower &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LabTestsCompanion extends UpdateCompanion<LabTest> {
  final Value<String> id;
  final Value<String> date;
  final Value<String> lab;
  final Value<String> labLower;
  final Value<String> reason;
  final Value<String> reasonLower;
  final Value<String?> resultsText;
  final Value<String?> resultsTextLower;
  final Value<String?> note;
  final Value<String?> noteLower;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LabTestsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.lab = const Value.absent(),
    this.labLower = const Value.absent(),
    this.reason = const Value.absent(),
    this.reasonLower = const Value.absent(),
    this.resultsText = const Value.absent(),
    this.resultsTextLower = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LabTestsCompanion.insert({
    required String id,
    required String date,
    required String lab,
    required String labLower,
    required String reason,
    required String reasonLower,
    this.resultsText = const Value.absent(),
    this.resultsTextLower = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       lab = Value(lab),
       labLower = Value(labLower),
       reason = Value(reason),
       reasonLower = Value(reasonLower),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LabTest> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<String>? lab,
    Expression<String>? labLower,
    Expression<String>? reason,
    Expression<String>? reasonLower,
    Expression<String>? resultsText,
    Expression<String>? resultsTextLower,
    Expression<String>? note,
    Expression<String>? noteLower,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (lab != null) 'lab': lab,
      if (labLower != null) 'lab_lower': labLower,
      if (reason != null) 'reason': reason,
      if (reasonLower != null) 'reason_lower': reasonLower,
      if (resultsText != null) 'results_text': resultsText,
      if (resultsTextLower != null) 'results_text_lower': resultsTextLower,
      if (note != null) 'note': note,
      if (noteLower != null) 'note_lower': noteLower,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LabTestsCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<String>? lab,
    Value<String>? labLower,
    Value<String>? reason,
    Value<String>? reasonLower,
    Value<String?>? resultsText,
    Value<String?>? resultsTextLower,
    Value<String?>? note,
    Value<String?>? noteLower,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LabTestsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      lab: lab ?? this.lab,
      labLower: labLower ?? this.labLower,
      reason: reason ?? this.reason,
      reasonLower: reasonLower ?? this.reasonLower,
      resultsText: resultsText ?? this.resultsText,
      resultsTextLower: resultsTextLower ?? this.resultsTextLower,
      note: note ?? this.note,
      noteLower: noteLower ?? this.noteLower,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (lab.present) {
      map['lab'] = Variable<String>(lab.value);
    }
    if (labLower.present) {
      map['lab_lower'] = Variable<String>(labLower.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (reasonLower.present) {
      map['reason_lower'] = Variable<String>(reasonLower.value);
    }
    if (resultsText.present) {
      map['results_text'] = Variable<String>(resultsText.value);
    }
    if (resultsTextLower.present) {
      map['results_text_lower'] = Variable<String>(resultsTextLower.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (noteLower.present) {
      map['note_lower'] = Variable<String>(noteLower.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabTestsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('lab: $lab, ')
          ..write('labLower: $labLower, ')
          ..write('reason: $reason, ')
          ..write('reasonLower: $reasonLower, ')
          ..write('resultsText: $resultsText, ')
          ..write('resultsTextLower: $resultsTextLower, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BloodPressureLogsTable extends BloodPressureLogs
    with TableInfo<$BloodPressureLogsTable, BloodPressureLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BloodPressureLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _systolicMeta = const VerificationMeta(
    'systolic',
  );
  @override
  late final GeneratedColumn<int> systolic = GeneratedColumn<int>(
    'systolic',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diastolicMeta = const VerificationMeta(
    'diastolic',
  );
  @override
  late final GeneratedColumn<int> diastolic = GeneratedColumn<int>(
    'diastolic',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pulseMeta = const VerificationMeta('pulse');
  @override
  late final GeneratedColumn<int> pulse = GeneratedColumn<int>(
    'pulse',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteLowerMeta = const VerificationMeta(
    'noteLower',
  );
  @override
  late final GeneratedColumn<String> noteLower = GeneratedColumn<String>(
    'note_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    time,
    systolic,
    diastolic,
    pulse,
    note,
    noteLower,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blood_pressure_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<BloodPressureLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('systolic')) {
      context.handle(
        _systolicMeta,
        systolic.isAcceptableOrUnknown(data['systolic']!, _systolicMeta),
      );
    } else if (isInserting) {
      context.missing(_systolicMeta);
    }
    if (data.containsKey('diastolic')) {
      context.handle(
        _diastolicMeta,
        diastolic.isAcceptableOrUnknown(data['diastolic']!, _diastolicMeta),
      );
    } else if (isInserting) {
      context.missing(_diastolicMeta);
    }
    if (data.containsKey('pulse')) {
      context.handle(
        _pulseMeta,
        pulse.isAcceptableOrUnknown(data['pulse']!, _pulseMeta),
      );
    } else if (isInserting) {
      context.missing(_pulseMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('note_lower')) {
      context.handle(
        _noteLowerMeta,
        noteLower.isAcceptableOrUnknown(data['note_lower']!, _noteLowerMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BloodPressureLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BloodPressureLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      )!,
      systolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}systolic'],
      )!,
      diastolic: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diastolic'],
      )!,
      pulse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pulse'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      noteLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_lower'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BloodPressureLogsTable createAlias(String alias) {
    return $BloodPressureLogsTable(attachedDatabase, alias);
  }
}

class BloodPressureLog extends DataClass
    implements Insertable<BloodPressureLog> {
  final String id;
  final String date;
  final String time;
  final int systolic;
  final int diastolic;
  final int pulse;
  final String? note;
  final String? noteLower;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BloodPressureLog({
    required this.id,
    required this.date,
    required this.time,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    this.note,
    this.noteLower,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['time'] = Variable<String>(time);
    map['systolic'] = Variable<int>(systolic);
    map['diastolic'] = Variable<int>(diastolic);
    map['pulse'] = Variable<int>(pulse);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || noteLower != null) {
      map['note_lower'] = Variable<String>(noteLower);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BloodPressureLogsCompanion toCompanion(bool nullToAbsent) {
    return BloodPressureLogsCompanion(
      id: Value(id),
      date: Value(date),
      time: Value(time),
      systolic: Value(systolic),
      diastolic: Value(diastolic),
      pulse: Value(pulse),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      noteLower: noteLower == null && nullToAbsent
          ? const Value.absent()
          : Value(noteLower),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BloodPressureLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BloodPressureLog(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      time: serializer.fromJson<String>(json['time']),
      systolic: serializer.fromJson<int>(json['systolic']),
      diastolic: serializer.fromJson<int>(json['diastolic']),
      pulse: serializer.fromJson<int>(json['pulse']),
      note: serializer.fromJson<String?>(json['note']),
      noteLower: serializer.fromJson<String?>(json['noteLower']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'time': serializer.toJson<String>(time),
      'systolic': serializer.toJson<int>(systolic),
      'diastolic': serializer.toJson<int>(diastolic),
      'pulse': serializer.toJson<int>(pulse),
      'note': serializer.toJson<String?>(note),
      'noteLower': serializer.toJson<String?>(noteLower),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BloodPressureLog copyWith({
    String? id,
    String? date,
    String? time,
    int? systolic,
    int? diastolic,
    int? pulse,
    Value<String?> note = const Value.absent(),
    Value<String?> noteLower = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BloodPressureLog(
    id: id ?? this.id,
    date: date ?? this.date,
    time: time ?? this.time,
    systolic: systolic ?? this.systolic,
    diastolic: diastolic ?? this.diastolic,
    pulse: pulse ?? this.pulse,
    note: note.present ? note.value : this.note,
    noteLower: noteLower.present ? noteLower.value : this.noteLower,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BloodPressureLog copyWithCompanion(BloodPressureLogsCompanion data) {
    return BloodPressureLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      time: data.time.present ? data.time.value : this.time,
      systolic: data.systolic.present ? data.systolic.value : this.systolic,
      diastolic: data.diastolic.present ? data.diastolic.value : this.diastolic,
      pulse: data.pulse.present ? data.pulse.value : this.pulse,
      note: data.note.present ? data.note.value : this.note,
      noteLower: data.noteLower.present ? data.noteLower.value : this.noteLower,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BloodPressureLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('systolic: $systolic, ')
          ..write('diastolic: $diastolic, ')
          ..write('pulse: $pulse, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    time,
    systolic,
    diastolic,
    pulse,
    note,
    noteLower,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BloodPressureLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.time == this.time &&
          other.systolic == this.systolic &&
          other.diastolic == this.diastolic &&
          other.pulse == this.pulse &&
          other.note == this.note &&
          other.noteLower == this.noteLower &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BloodPressureLogsCompanion extends UpdateCompanion<BloodPressureLog> {
  final Value<String> id;
  final Value<String> date;
  final Value<String> time;
  final Value<int> systolic;
  final Value<int> diastolic;
  final Value<int> pulse;
  final Value<String?> note;
  final Value<String?> noteLower;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BloodPressureLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.systolic = const Value.absent(),
    this.diastolic = const Value.absent(),
    this.pulse = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BloodPressureLogsCompanion.insert({
    required String id,
    required String date,
    required String time,
    required int systolic,
    required int diastolic,
    required int pulse,
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       time = Value(time),
       systolic = Value(systolic),
       diastolic = Value(diastolic),
       pulse = Value(pulse),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BloodPressureLog> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<String>? time,
    Expression<int>? systolic,
    Expression<int>? diastolic,
    Expression<int>? pulse,
    Expression<String>? note,
    Expression<String>? noteLower,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (systolic != null) 'systolic': systolic,
      if (diastolic != null) 'diastolic': diastolic,
      if (pulse != null) 'pulse': pulse,
      if (note != null) 'note': note,
      if (noteLower != null) 'note_lower': noteLower,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BloodPressureLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<String>? time,
    Value<int>? systolic,
    Value<int>? diastolic,
    Value<int>? pulse,
    Value<String?>? note,
    Value<String?>? noteLower,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BloodPressureLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      pulse: pulse ?? this.pulse,
      note: note ?? this.note,
      noteLower: noteLower ?? this.noteLower,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (systolic.present) {
      map['systolic'] = Variable<int>(systolic.value);
    }
    if (diastolic.present) {
      map['diastolic'] = Variable<int>(diastolic.value);
    }
    if (pulse.present) {
      map['pulse'] = Variable<int>(pulse.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (noteLower.present) {
      map['note_lower'] = Variable<String>(noteLower.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BloodPressureLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('systolic: $systolic, ')
          ..write('diastolic: $diastolic, ')
          ..write('pulse: $pulse, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationLogsTable extends MedicationLogs
    with TableInfo<$MedicationLogsTable, MedicationLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameLowerMeta = const VerificationMeta(
    'nameLower',
  );
  @override
  late final GeneratedColumn<String> nameLower = GeneratedColumn<String>(
    'name_lower',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MedType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MedType>($MedicationLogsTable.$convertertype);
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<String> dose = GeneratedColumn<String>(
    'dose',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MedStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MedStatus>($MedicationLogsTable.$converterstatus);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonLowerMeta = const VerificationMeta(
    'reasonLower',
  );
  @override
  late final GeneratedColumn<String> reasonLower = GeneratedColumn<String>(
    'reason_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteLowerMeta = const VerificationMeta(
    'noteLower',
  );
  @override
  late final GeneratedColumn<String> noteLower = GeneratedColumn<String>(
    'note_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    time,
    name,
    nameLower,
    type,
    dose,
    status,
    reason,
    reasonLower,
    note,
    noteLower,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_lower')) {
      context.handle(
        _nameLowerMeta,
        nameLower.isAcceptableOrUnknown(data['name_lower']!, _nameLowerMeta),
      );
    } else if (isInserting) {
      context.missing(_nameLowerMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
        _doseMeta,
        dose.isAcceptableOrUnknown(data['dose']!, _doseMeta),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('reason_lower')) {
      context.handle(
        _reasonLowerMeta,
        reasonLower.isAcceptableOrUnknown(
          data['reason_lower']!,
          _reasonLowerMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('note_lower')) {
      context.handle(
        _noteLowerMeta,
        noteLower.isAcceptableOrUnknown(data['note_lower']!, _noteLowerMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_lower'],
      )!,
      type: $MedicationLogsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      dose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dose'],
      ),
      status: $MedicationLogsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      reasonLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_lower'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      noteLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_lower'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MedicationLogsTable createAlias(String alias) {
    return $MedicationLogsTable(attachedDatabase, alias);
  }

  static TypeConverter<MedType, String> $convertertype = medTypeConverter;
  static TypeConverter<MedStatus, String> $converterstatus = medStatusConverter;
}

class MedicationLog extends DataClass implements Insertable<MedicationLog> {
  final String id;
  final String date;
  final String time;
  final String name;
  final String nameLower;
  final MedType type;
  final String? dose;
  final MedStatus status;
  final String? reason;
  final String? reasonLower;
  final String? note;
  final String? noteLower;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MedicationLog({
    required this.id,
    required this.date,
    required this.time,
    required this.name,
    required this.nameLower,
    required this.type,
    this.dose,
    required this.status,
    this.reason,
    this.reasonLower,
    this.note,
    this.noteLower,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['time'] = Variable<String>(time);
    map['name'] = Variable<String>(name);
    map['name_lower'] = Variable<String>(nameLower);
    {
      map['type'] = Variable<String>(
        $MedicationLogsTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || dose != null) {
      map['dose'] = Variable<String>(dose);
    }
    {
      map['status'] = Variable<String>(
        $MedicationLogsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || reasonLower != null) {
      map['reason_lower'] = Variable<String>(reasonLower);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || noteLower != null) {
      map['note_lower'] = Variable<String>(noteLower);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MedicationLogsCompanion toCompanion(bool nullToAbsent) {
    return MedicationLogsCompanion(
      id: Value(id),
      date: Value(date),
      time: Value(time),
      name: Value(name),
      nameLower: Value(nameLower),
      type: Value(type),
      dose: dose == null && nullToAbsent ? const Value.absent() : Value(dose),
      status: Value(status),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      reasonLower: reasonLower == null && nullToAbsent
          ? const Value.absent()
          : Value(reasonLower),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      noteLower: noteLower == null && nullToAbsent
          ? const Value.absent()
          : Value(noteLower),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MedicationLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationLog(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      time: serializer.fromJson<String>(json['time']),
      name: serializer.fromJson<String>(json['name']),
      nameLower: serializer.fromJson<String>(json['nameLower']),
      type: serializer.fromJson<MedType>(json['type']),
      dose: serializer.fromJson<String?>(json['dose']),
      status: serializer.fromJson<MedStatus>(json['status']),
      reason: serializer.fromJson<String?>(json['reason']),
      reasonLower: serializer.fromJson<String?>(json['reasonLower']),
      note: serializer.fromJson<String?>(json['note']),
      noteLower: serializer.fromJson<String?>(json['noteLower']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'time': serializer.toJson<String>(time),
      'name': serializer.toJson<String>(name),
      'nameLower': serializer.toJson<String>(nameLower),
      'type': serializer.toJson<MedType>(type),
      'dose': serializer.toJson<String?>(dose),
      'status': serializer.toJson<MedStatus>(status),
      'reason': serializer.toJson<String?>(reason),
      'reasonLower': serializer.toJson<String?>(reasonLower),
      'note': serializer.toJson<String?>(note),
      'noteLower': serializer.toJson<String?>(noteLower),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MedicationLog copyWith({
    String? id,
    String? date,
    String? time,
    String? name,
    String? nameLower,
    MedType? type,
    Value<String?> dose = const Value.absent(),
    MedStatus? status,
    Value<String?> reason = const Value.absent(),
    Value<String?> reasonLower = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> noteLower = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MedicationLog(
    id: id ?? this.id,
    date: date ?? this.date,
    time: time ?? this.time,
    name: name ?? this.name,
    nameLower: nameLower ?? this.nameLower,
    type: type ?? this.type,
    dose: dose.present ? dose.value : this.dose,
    status: status ?? this.status,
    reason: reason.present ? reason.value : this.reason,
    reasonLower: reasonLower.present ? reasonLower.value : this.reasonLower,
    note: note.present ? note.value : this.note,
    noteLower: noteLower.present ? noteLower.value : this.noteLower,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MedicationLog copyWithCompanion(MedicationLogsCompanion data) {
    return MedicationLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      time: data.time.present ? data.time.value : this.time,
      name: data.name.present ? data.name.value : this.name,
      nameLower: data.nameLower.present ? data.nameLower.value : this.nameLower,
      type: data.type.present ? data.type.value : this.type,
      dose: data.dose.present ? data.dose.value : this.dose,
      status: data.status.present ? data.status.value : this.status,
      reason: data.reason.present ? data.reason.value : this.reason,
      reasonLower: data.reasonLower.present
          ? data.reasonLower.value
          : this.reasonLower,
      note: data.note.present ? data.note.value : this.note,
      noteLower: data.noteLower.present ? data.noteLower.value : this.noteLower,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('name: $name, ')
          ..write('nameLower: $nameLower, ')
          ..write('type: $type, ')
          ..write('dose: $dose, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('reasonLower: $reasonLower, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    time,
    name,
    nameLower,
    type,
    dose,
    status,
    reason,
    reasonLower,
    note,
    noteLower,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.time == this.time &&
          other.name == this.name &&
          other.nameLower == this.nameLower &&
          other.type == this.type &&
          other.dose == this.dose &&
          other.status == this.status &&
          other.reason == this.reason &&
          other.reasonLower == this.reasonLower &&
          other.note == this.note &&
          other.noteLower == this.noteLower &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MedicationLogsCompanion extends UpdateCompanion<MedicationLog> {
  final Value<String> id;
  final Value<String> date;
  final Value<String> time;
  final Value<String> name;
  final Value<String> nameLower;
  final Value<MedType> type;
  final Value<String?> dose;
  final Value<MedStatus> status;
  final Value<String?> reason;
  final Value<String?> reasonLower;
  final Value<String?> note;
  final Value<String?> noteLower;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MedicationLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.name = const Value.absent(),
    this.nameLower = const Value.absent(),
    this.type = const Value.absent(),
    this.dose = const Value.absent(),
    this.status = const Value.absent(),
    this.reason = const Value.absent(),
    this.reasonLower = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationLogsCompanion.insert({
    required String id,
    required String date,
    required String time,
    required String name,
    required String nameLower,
    required MedType type,
    this.dose = const Value.absent(),
    required MedStatus status,
    this.reason = const Value.absent(),
    this.reasonLower = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       time = Value(time),
       name = Value(name),
       nameLower = Value(nameLower),
       type = Value(type),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MedicationLog> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<String>? time,
    Expression<String>? name,
    Expression<String>? nameLower,
    Expression<String>? type,
    Expression<String>? dose,
    Expression<String>? status,
    Expression<String>? reason,
    Expression<String>? reasonLower,
    Expression<String>? note,
    Expression<String>? noteLower,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (name != null) 'name': name,
      if (nameLower != null) 'name_lower': nameLower,
      if (type != null) 'type': type,
      if (dose != null) 'dose': dose,
      if (status != null) 'status': status,
      if (reason != null) 'reason': reason,
      if (reasonLower != null) 'reason_lower': reasonLower,
      if (note != null) 'note': note,
      if (noteLower != null) 'note_lower': noteLower,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<String>? time,
    Value<String>? name,
    Value<String>? nameLower,
    Value<MedType>? type,
    Value<String?>? dose,
    Value<MedStatus>? status,
    Value<String?>? reason,
    Value<String?>? reasonLower,
    Value<String?>? note,
    Value<String?>? noteLower,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MedicationLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      name: name ?? this.name,
      nameLower: nameLower ?? this.nameLower,
      type: type ?? this.type,
      dose: dose ?? this.dose,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      reasonLower: reasonLower ?? this.reasonLower,
      note: note ?? this.note,
      noteLower: noteLower ?? this.noteLower,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameLower.present) {
      map['name_lower'] = Variable<String>(nameLower.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $MedicationLogsTable.$convertertype.toSql(type.value),
      );
    }
    if (dose.present) {
      map['dose'] = Variable<String>(dose.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $MedicationLogsTable.$converterstatus.toSql(status.value),
      );
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (reasonLower.present) {
      map['reason_lower'] = Variable<String>(reasonLower.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (noteLower.present) {
      map['note_lower'] = Variable<String>(noteLower.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('name: $name, ')
          ..write('nameLower: $nameLower, ')
          ..write('type: $type, ')
          ..write('dose: $dose, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('reasonLower: $reasonLower, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyLogsTable extends DailyLogs
    with TableInfo<$DailyLogsTable, DailyLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proudMeta = const VerificationMeta('proud');
  @override
  late final GeneratedColumn<bool> proud = GeneratedColumn<bool>(
    'proud',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("proud" IN (0, 1))',
    ),
  );
  static const VerificationMeta _didUncomfortableMeta = const VerificationMeta(
    'didUncomfortable',
  );
  @override
  late final GeneratedColumn<bool> didUncomfortable = GeneratedColumn<bool>(
    'did_uncomfortable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("did_uncomfortable" IN (0, 1))',
    ),
  );
  static const VerificationMeta _uncomfortableWhatMeta = const VerificationMeta(
    'uncomfortableWhat',
  );
  @override
  late final GeneratedColumn<String> uncomfortableWhat =
      GeneratedColumn<String>(
        'uncomfortable_what',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _workoutMeta = const VerificationMeta(
    'workout',
  );
  @override
  late final GeneratedColumn<bool> workout = GeneratedColumn<bool>(
    'workout',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("workout" IN (0, 1))',
    ),
  );
  static const VerificationMeta _drankAlcoholMeta = const VerificationMeta(
    'drankAlcohol',
  );
  @override
  late final GeneratedColumn<bool> drankAlcohol = GeneratedColumn<bool>(
    'drank_alcohol',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("drank_alcohol" IN (0, 1))',
    ),
  );
  static const VerificationMeta _alcoholWhatMeta = const VerificationMeta(
    'alcoholWhat',
  );
  @override
  late final GeneratedColumn<String> alcoholWhat = GeneratedColumn<String>(
    'alcohol_what',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _screenTimeMinMeta = const VerificationMeta(
    'screenTimeMin',
  );
  @override
  late final GeneratedColumn<int> screenTimeMin = GeneratedColumn<int>(
    'screen_time_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteLowerMeta = const VerificationMeta(
    'noteLower',
  );
  @override
  late final GeneratedColumn<String> noteLower = GeneratedColumn<String>(
    'note_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    mood,
    proud,
    didUncomfortable,
    uncomfortableWhat,
    workout,
    drankAlcohol,
    alcoholWhat,
    screenTimeMin,
    note,
    noteLower,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('proud')) {
      context.handle(
        _proudMeta,
        proud.isAcceptableOrUnknown(data['proud']!, _proudMeta),
      );
    } else if (isInserting) {
      context.missing(_proudMeta);
    }
    if (data.containsKey('did_uncomfortable')) {
      context.handle(
        _didUncomfortableMeta,
        didUncomfortable.isAcceptableOrUnknown(
          data['did_uncomfortable']!,
          _didUncomfortableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_didUncomfortableMeta);
    }
    if (data.containsKey('uncomfortable_what')) {
      context.handle(
        _uncomfortableWhatMeta,
        uncomfortableWhat.isAcceptableOrUnknown(
          data['uncomfortable_what']!,
          _uncomfortableWhatMeta,
        ),
      );
    }
    if (data.containsKey('workout')) {
      context.handle(
        _workoutMeta,
        workout.isAcceptableOrUnknown(data['workout']!, _workoutMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutMeta);
    }
    if (data.containsKey('drank_alcohol')) {
      context.handle(
        _drankAlcoholMeta,
        drankAlcohol.isAcceptableOrUnknown(
          data['drank_alcohol']!,
          _drankAlcoholMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_drankAlcoholMeta);
    }
    if (data.containsKey('alcohol_what')) {
      context.handle(
        _alcoholWhatMeta,
        alcoholWhat.isAcceptableOrUnknown(
          data['alcohol_what']!,
          _alcoholWhatMeta,
        ),
      );
    }
    if (data.containsKey('screen_time_min')) {
      context.handle(
        _screenTimeMinMeta,
        screenTimeMin.isAcceptableOrUnknown(
          data['screen_time_min']!,
          _screenTimeMinMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('note_lower')) {
      context.handle(
        _noteLowerMeta,
        noteLower.isAcceptableOrUnknown(data['note_lower']!, _noteLowerMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      )!,
      proud: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}proud'],
      )!,
      didUncomfortable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}did_uncomfortable'],
      )!,
      uncomfortableWhat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uncomfortable_what'],
      ),
      workout: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}workout'],
      )!,
      drankAlcohol: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}drank_alcohol'],
      )!,
      alcoholWhat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alcohol_what'],
      ),
      screenTimeMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}screen_time_min'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      noteLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_lower'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyLogsTable createAlias(String alias) {
    return $DailyLogsTable(attachedDatabase, alias);
  }
}

class DailyLog extends DataClass implements Insertable<DailyLog> {
  final String id;
  final String date;
  final int mood;
  final bool proud;
  final bool didUncomfortable;
  final String? uncomfortableWhat;
  final bool workout;
  final bool drankAlcohol;
  final String? alcoholWhat;
  final int? screenTimeMin;
  final String? note;
  final String? noteLower;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyLog({
    required this.id,
    required this.date,
    required this.mood,
    required this.proud,
    required this.didUncomfortable,
    this.uncomfortableWhat,
    required this.workout,
    required this.drankAlcohol,
    this.alcoholWhat,
    this.screenTimeMin,
    this.note,
    this.noteLower,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['mood'] = Variable<int>(mood);
    map['proud'] = Variable<bool>(proud);
    map['did_uncomfortable'] = Variable<bool>(didUncomfortable);
    if (!nullToAbsent || uncomfortableWhat != null) {
      map['uncomfortable_what'] = Variable<String>(uncomfortableWhat);
    }
    map['workout'] = Variable<bool>(workout);
    map['drank_alcohol'] = Variable<bool>(drankAlcohol);
    if (!nullToAbsent || alcoholWhat != null) {
      map['alcohol_what'] = Variable<String>(alcoholWhat);
    }
    if (!nullToAbsent || screenTimeMin != null) {
      map['screen_time_min'] = Variable<int>(screenTimeMin);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || noteLower != null) {
      map['note_lower'] = Variable<String>(noteLower);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyLogsCompanion toCompanion(bool nullToAbsent) {
    return DailyLogsCompanion(
      id: Value(id),
      date: Value(date),
      mood: Value(mood),
      proud: Value(proud),
      didUncomfortable: Value(didUncomfortable),
      uncomfortableWhat: uncomfortableWhat == null && nullToAbsent
          ? const Value.absent()
          : Value(uncomfortableWhat),
      workout: Value(workout),
      drankAlcohol: Value(drankAlcohol),
      alcoholWhat: alcoholWhat == null && nullToAbsent
          ? const Value.absent()
          : Value(alcoholWhat),
      screenTimeMin: screenTimeMin == null && nullToAbsent
          ? const Value.absent()
          : Value(screenTimeMin),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      noteLower: noteLower == null && nullToAbsent
          ? const Value.absent()
          : Value(noteLower),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyLog(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      mood: serializer.fromJson<int>(json['mood']),
      proud: serializer.fromJson<bool>(json['proud']),
      didUncomfortable: serializer.fromJson<bool>(json['didUncomfortable']),
      uncomfortableWhat: serializer.fromJson<String?>(
        json['uncomfortableWhat'],
      ),
      workout: serializer.fromJson<bool>(json['workout']),
      drankAlcohol: serializer.fromJson<bool>(json['drankAlcohol']),
      alcoholWhat: serializer.fromJson<String?>(json['alcoholWhat']),
      screenTimeMin: serializer.fromJson<int?>(json['screenTimeMin']),
      note: serializer.fromJson<String?>(json['note']),
      noteLower: serializer.fromJson<String?>(json['noteLower']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'mood': serializer.toJson<int>(mood),
      'proud': serializer.toJson<bool>(proud),
      'didUncomfortable': serializer.toJson<bool>(didUncomfortable),
      'uncomfortableWhat': serializer.toJson<String?>(uncomfortableWhat),
      'workout': serializer.toJson<bool>(workout),
      'drankAlcohol': serializer.toJson<bool>(drankAlcohol),
      'alcoholWhat': serializer.toJson<String?>(alcoholWhat),
      'screenTimeMin': serializer.toJson<int?>(screenTimeMin),
      'note': serializer.toJson<String?>(note),
      'noteLower': serializer.toJson<String?>(noteLower),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyLog copyWith({
    String? id,
    String? date,
    int? mood,
    bool? proud,
    bool? didUncomfortable,
    Value<String?> uncomfortableWhat = const Value.absent(),
    bool? workout,
    bool? drankAlcohol,
    Value<String?> alcoholWhat = const Value.absent(),
    Value<int?> screenTimeMin = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> noteLower = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DailyLog(
    id: id ?? this.id,
    date: date ?? this.date,
    mood: mood ?? this.mood,
    proud: proud ?? this.proud,
    didUncomfortable: didUncomfortable ?? this.didUncomfortable,
    uncomfortableWhat: uncomfortableWhat.present
        ? uncomfortableWhat.value
        : this.uncomfortableWhat,
    workout: workout ?? this.workout,
    drankAlcohol: drankAlcohol ?? this.drankAlcohol,
    alcoholWhat: alcoholWhat.present ? alcoholWhat.value : this.alcoholWhat,
    screenTimeMin: screenTimeMin.present
        ? screenTimeMin.value
        : this.screenTimeMin,
    note: note.present ? note.value : this.note,
    noteLower: noteLower.present ? noteLower.value : this.noteLower,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyLog copyWithCompanion(DailyLogsCompanion data) {
    return DailyLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      mood: data.mood.present ? data.mood.value : this.mood,
      proud: data.proud.present ? data.proud.value : this.proud,
      didUncomfortable: data.didUncomfortable.present
          ? data.didUncomfortable.value
          : this.didUncomfortable,
      uncomfortableWhat: data.uncomfortableWhat.present
          ? data.uncomfortableWhat.value
          : this.uncomfortableWhat,
      workout: data.workout.present ? data.workout.value : this.workout,
      drankAlcohol: data.drankAlcohol.present
          ? data.drankAlcohol.value
          : this.drankAlcohol,
      alcoholWhat: data.alcoholWhat.present
          ? data.alcoholWhat.value
          : this.alcoholWhat,
      screenTimeMin: data.screenTimeMin.present
          ? data.screenTimeMin.value
          : this.screenTimeMin,
      note: data.note.present ? data.note.value : this.note,
      noteLower: data.noteLower.present ? data.noteLower.value : this.noteLower,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('mood: $mood, ')
          ..write('proud: $proud, ')
          ..write('didUncomfortable: $didUncomfortable, ')
          ..write('uncomfortableWhat: $uncomfortableWhat, ')
          ..write('workout: $workout, ')
          ..write('drankAlcohol: $drankAlcohol, ')
          ..write('alcoholWhat: $alcoholWhat, ')
          ..write('screenTimeMin: $screenTimeMin, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    mood,
    proud,
    didUncomfortable,
    uncomfortableWhat,
    workout,
    drankAlcohol,
    alcoholWhat,
    screenTimeMin,
    note,
    noteLower,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.mood == this.mood &&
          other.proud == this.proud &&
          other.didUncomfortable == this.didUncomfortable &&
          other.uncomfortableWhat == this.uncomfortableWhat &&
          other.workout == this.workout &&
          other.drankAlcohol == this.drankAlcohol &&
          other.alcoholWhat == this.alcoholWhat &&
          other.screenTimeMin == this.screenTimeMin &&
          other.note == this.note &&
          other.noteLower == this.noteLower &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyLogsCompanion extends UpdateCompanion<DailyLog> {
  final Value<String> id;
  final Value<String> date;
  final Value<int> mood;
  final Value<bool> proud;
  final Value<bool> didUncomfortable;
  final Value<String?> uncomfortableWhat;
  final Value<bool> workout;
  final Value<bool> drankAlcohol;
  final Value<String?> alcoholWhat;
  final Value<int?> screenTimeMin;
  final Value<String?> note;
  final Value<String?> noteLower;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DailyLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.mood = const Value.absent(),
    this.proud = const Value.absent(),
    this.didUncomfortable = const Value.absent(),
    this.uncomfortableWhat = const Value.absent(),
    this.workout = const Value.absent(),
    this.drankAlcohol = const Value.absent(),
    this.alcoholWhat = const Value.absent(),
    this.screenTimeMin = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyLogsCompanion.insert({
    required String id,
    required String date,
    required int mood,
    required bool proud,
    required bool didUncomfortable,
    this.uncomfortableWhat = const Value.absent(),
    required bool workout,
    required bool drankAlcohol,
    this.alcoholWhat = const Value.absent(),
    this.screenTimeMin = const Value.absent(),
    this.note = const Value.absent(),
    this.noteLower = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       mood = Value(mood),
       proud = Value(proud),
       didUncomfortable = Value(didUncomfortable),
       workout = Value(workout),
       drankAlcohol = Value(drankAlcohol),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DailyLog> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<int>? mood,
    Expression<bool>? proud,
    Expression<bool>? didUncomfortable,
    Expression<String>? uncomfortableWhat,
    Expression<bool>? workout,
    Expression<bool>? drankAlcohol,
    Expression<String>? alcoholWhat,
    Expression<int>? screenTimeMin,
    Expression<String>? note,
    Expression<String>? noteLower,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (mood != null) 'mood': mood,
      if (proud != null) 'proud': proud,
      if (didUncomfortable != null) 'did_uncomfortable': didUncomfortable,
      if (uncomfortableWhat != null) 'uncomfortable_what': uncomfortableWhat,
      if (workout != null) 'workout': workout,
      if (drankAlcohol != null) 'drank_alcohol': drankAlcohol,
      if (alcoholWhat != null) 'alcohol_what': alcoholWhat,
      if (screenTimeMin != null) 'screen_time_min': screenTimeMin,
      if (note != null) 'note': note,
      if (noteLower != null) 'note_lower': noteLower,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<int>? mood,
    Value<bool>? proud,
    Value<bool>? didUncomfortable,
    Value<String?>? uncomfortableWhat,
    Value<bool>? workout,
    Value<bool>? drankAlcohol,
    Value<String?>? alcoholWhat,
    Value<int?>? screenTimeMin,
    Value<String?>? note,
    Value<String?>? noteLower,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DailyLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      proud: proud ?? this.proud,
      didUncomfortable: didUncomfortable ?? this.didUncomfortable,
      uncomfortableWhat: uncomfortableWhat ?? this.uncomfortableWhat,
      workout: workout ?? this.workout,
      drankAlcohol: drankAlcohol ?? this.drankAlcohol,
      alcoholWhat: alcoholWhat ?? this.alcoholWhat,
      screenTimeMin: screenTimeMin ?? this.screenTimeMin,
      note: note ?? this.note,
      noteLower: noteLower ?? this.noteLower,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (proud.present) {
      map['proud'] = Variable<bool>(proud.value);
    }
    if (didUncomfortable.present) {
      map['did_uncomfortable'] = Variable<bool>(didUncomfortable.value);
    }
    if (uncomfortableWhat.present) {
      map['uncomfortable_what'] = Variable<String>(uncomfortableWhat.value);
    }
    if (workout.present) {
      map['workout'] = Variable<bool>(workout.value);
    }
    if (drankAlcohol.present) {
      map['drank_alcohol'] = Variable<bool>(drankAlcohol.value);
    }
    if (alcoholWhat.present) {
      map['alcohol_what'] = Variable<String>(alcoholWhat.value);
    }
    if (screenTimeMin.present) {
      map['screen_time_min'] = Variable<int>(screenTimeMin.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (noteLower.present) {
      map['note_lower'] = Variable<String>(noteLower.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('mood: $mood, ')
          ..write('proud: $proud, ')
          ..write('didUncomfortable: $didUncomfortable, ')
          ..write('uncomfortableWhat: $uncomfortableWhat, ')
          ..write('workout: $workout, ')
          ..write('drankAlcohol: $drankAlcohol, ')
          ..write('alcoholWhat: $alcoholWhat, ')
          ..write('screenTimeMin: $screenTimeMin, ')
          ..write('note: $note, ')
          ..write('noteLower: $noteLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StepsTable extends Steps with TableInfo<$StepsTable, StepEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StepsSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<StepsSource>($StepsTable.$convertersource);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    count,
    note,
    source,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<StepEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StepEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StepEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      source: $StepsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StepsTable createAlias(String alias) {
    return $StepsTable(attachedDatabase, alias);
  }

  static TypeConverter<StepsSource, String> $convertersource =
      stepsSourceConverter;
}

class StepEntry extends DataClass implements Insertable<StepEntry> {
  final String id;
  final String date;
  final int count;
  final String? note;
  final StepsSource source;
  final DateTime createdAt;
  final DateTime updatedAt;
  const StepEntry({
    required this.id,
    required this.date,
    required this.count,
    this.note,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['count'] = Variable<int>(count);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    {
      map['source'] = Variable<String>(
        $StepsTable.$convertersource.toSql(source),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StepsCompanion toCompanion(bool nullToAbsent) {
    return StepsCompanion(
      id: Value(id),
      date: Value(date),
      count: Value(count),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      source: Value(source),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory StepEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StepEntry(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      count: serializer.fromJson<int>(json['count']),
      note: serializer.fromJson<String?>(json['note']),
      source: serializer.fromJson<StepsSource>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'count': serializer.toJson<int>(count),
      'note': serializer.toJson<String?>(note),
      'source': serializer.toJson<StepsSource>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StepEntry copyWith({
    String? id,
    String? date,
    int? count,
    Value<String?> note = const Value.absent(),
    StepsSource? source,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => StepEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    count: count ?? this.count,
    note: note.present ? note.value : this.note,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StepEntry copyWithCompanion(StepsCompanion data) {
    return StepEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      count: data.count.present ? data.count.value : this.count,
      note: data.note.present ? data.note.value : this.note,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StepEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, count, note, source, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StepEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.count == this.count &&
          other.note == this.note &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StepsCompanion extends UpdateCompanion<StepEntry> {
  final Value<String> id;
  final Value<String> date;
  final Value<int> count;
  final Value<String?> note;
  final Value<StepsSource> source;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StepsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.count = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StepsCompanion.insert({
    required String id,
    required String date,
    required int count,
    this.note = const Value.absent(),
    required StepsSource source,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       count = Value(count),
       source = Value(source),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<StepEntry> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<int>? count,
    Expression<String>? note,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (count != null) 'count': count,
      if (note != null) 'note': note,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StepsCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<int>? count,
    Value<String?>? note,
    Value<StepsSource>? source,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StepsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      count: count ?? this.count,
      note: note ?? this.note,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $StepsTable.$convertersource.toSql(source.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StepsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BucketItemsTable extends BucketItems
    with TableInfo<$BucketItemsTable, BucketItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BucketItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleLowerMeta = const VerificationMeta(
    'titleLower',
  );
  @override
  late final GeneratedColumn<String> titleLower = GeneratedColumn<String>(
    'title_lower',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionLowerMeta = const VerificationMeta(
    'descriptionLower',
  );
  @override
  late final GeneratedColumn<String> descriptionLower = GeneratedColumn<String>(
    'description_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _whyWantItMeta = const VerificationMeta(
    'whyWantIt',
  );
  @override
  late final GeneratedColumn<String> whyWantIt = GeneratedColumn<String>(
    'why_want_it',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _whyWantItLowerMeta = const VerificationMeta(
    'whyWantItLower',
  );
  @override
  late final GeneratedColumn<String> whyWantItLower = GeneratedColumn<String>(
    'why_want_it_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BucketPriority, String> priority =
      GeneratedColumn<String>(
        'priority',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BucketPriority>($BucketItemsTable.$converterpriority);
  @override
  late final GeneratedColumnWithTypeConverter<BucketStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BucketStatus>($BucketItemsTable.$converterstatus);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    titleLower,
    description,
    descriptionLower,
    whyWantIt,
    whyWantItLower,
    priority,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bucket_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<BucketItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('title_lower')) {
      context.handle(
        _titleLowerMeta,
        titleLower.isAcceptableOrUnknown(data['title_lower']!, _titleLowerMeta),
      );
    } else if (isInserting) {
      context.missing(_titleLowerMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('description_lower')) {
      context.handle(
        _descriptionLowerMeta,
        descriptionLower.isAcceptableOrUnknown(
          data['description_lower']!,
          _descriptionLowerMeta,
        ),
      );
    }
    if (data.containsKey('why_want_it')) {
      context.handle(
        _whyWantItMeta,
        whyWantIt.isAcceptableOrUnknown(data['why_want_it']!, _whyWantItMeta),
      );
    }
    if (data.containsKey('why_want_it_lower')) {
      context.handle(
        _whyWantItLowerMeta,
        whyWantItLower.isAcceptableOrUnknown(
          data['why_want_it_lower']!,
          _whyWantItLowerMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BucketItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BucketItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      titleLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_lower'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      descriptionLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_lower'],
      ),
      whyWantIt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}why_want_it'],
      ),
      whyWantItLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}why_want_it_lower'],
      ),
      priority: $BucketItemsTable.$converterpriority.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}priority'],
        )!,
      ),
      status: $BucketItemsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BucketItemsTable createAlias(String alias) {
    return $BucketItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<BucketPriority, String> $converterpriority =
      bucketPriorityConverter;
  static TypeConverter<BucketStatus, String> $converterstatus =
      bucketStatusConverter;
}

class BucketItem extends DataClass implements Insertable<BucketItem> {
  final String id;
  final String title;
  final String titleLower;
  final String? description;
  final String? descriptionLower;
  final String? whyWantIt;
  final String? whyWantItLower;
  final BucketPriority priority;
  final BucketStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BucketItem({
    required this.id,
    required this.title,
    required this.titleLower,
    this.description,
    this.descriptionLower,
    this.whyWantIt,
    this.whyWantItLower,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['title_lower'] = Variable<String>(titleLower);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || descriptionLower != null) {
      map['description_lower'] = Variable<String>(descriptionLower);
    }
    if (!nullToAbsent || whyWantIt != null) {
      map['why_want_it'] = Variable<String>(whyWantIt);
    }
    if (!nullToAbsent || whyWantItLower != null) {
      map['why_want_it_lower'] = Variable<String>(whyWantItLower);
    }
    {
      map['priority'] = Variable<String>(
        $BucketItemsTable.$converterpriority.toSql(priority),
      );
    }
    {
      map['status'] = Variable<String>(
        $BucketItemsTable.$converterstatus.toSql(status),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BucketItemsCompanion toCompanion(bool nullToAbsent) {
    return BucketItemsCompanion(
      id: Value(id),
      title: Value(title),
      titleLower: Value(titleLower),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      descriptionLower: descriptionLower == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionLower),
      whyWantIt: whyWantIt == null && nullToAbsent
          ? const Value.absent()
          : Value(whyWantIt),
      whyWantItLower: whyWantItLower == null && nullToAbsent
          ? const Value.absent()
          : Value(whyWantItLower),
      priority: Value(priority),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BucketItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BucketItem(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      titleLower: serializer.fromJson<String>(json['titleLower']),
      description: serializer.fromJson<String?>(json['description']),
      descriptionLower: serializer.fromJson<String?>(json['descriptionLower']),
      whyWantIt: serializer.fromJson<String?>(json['whyWantIt']),
      whyWantItLower: serializer.fromJson<String?>(json['whyWantItLower']),
      priority: serializer.fromJson<BucketPriority>(json['priority']),
      status: serializer.fromJson<BucketStatus>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'titleLower': serializer.toJson<String>(titleLower),
      'description': serializer.toJson<String?>(description),
      'descriptionLower': serializer.toJson<String?>(descriptionLower),
      'whyWantIt': serializer.toJson<String?>(whyWantIt),
      'whyWantItLower': serializer.toJson<String?>(whyWantItLower),
      'priority': serializer.toJson<BucketPriority>(priority),
      'status': serializer.toJson<BucketStatus>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BucketItem copyWith({
    String? id,
    String? title,
    String? titleLower,
    Value<String?> description = const Value.absent(),
    Value<String?> descriptionLower = const Value.absent(),
    Value<String?> whyWantIt = const Value.absent(),
    Value<String?> whyWantItLower = const Value.absent(),
    BucketPriority? priority,
    BucketStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BucketItem(
    id: id ?? this.id,
    title: title ?? this.title,
    titleLower: titleLower ?? this.titleLower,
    description: description.present ? description.value : this.description,
    descriptionLower: descriptionLower.present
        ? descriptionLower.value
        : this.descriptionLower,
    whyWantIt: whyWantIt.present ? whyWantIt.value : this.whyWantIt,
    whyWantItLower: whyWantItLower.present
        ? whyWantItLower.value
        : this.whyWantItLower,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BucketItem copyWithCompanion(BucketItemsCompanion data) {
    return BucketItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      titleLower: data.titleLower.present
          ? data.titleLower.value
          : this.titleLower,
      description: data.description.present
          ? data.description.value
          : this.description,
      descriptionLower: data.descriptionLower.present
          ? data.descriptionLower.value
          : this.descriptionLower,
      whyWantIt: data.whyWantIt.present ? data.whyWantIt.value : this.whyWantIt,
      whyWantItLower: data.whyWantItLower.present
          ? data.whyWantItLower.value
          : this.whyWantItLower,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BucketItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleLower: $titleLower, ')
          ..write('description: $description, ')
          ..write('descriptionLower: $descriptionLower, ')
          ..write('whyWantIt: $whyWantIt, ')
          ..write('whyWantItLower: $whyWantItLower, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    titleLower,
    description,
    descriptionLower,
    whyWantIt,
    whyWantItLower,
    priority,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BucketItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.titleLower == this.titleLower &&
          other.description == this.description &&
          other.descriptionLower == this.descriptionLower &&
          other.whyWantIt == this.whyWantIt &&
          other.whyWantItLower == this.whyWantItLower &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BucketItemsCompanion extends UpdateCompanion<BucketItem> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> titleLower;
  final Value<String?> description;
  final Value<String?> descriptionLower;
  final Value<String?> whyWantIt;
  final Value<String?> whyWantItLower;
  final Value<BucketPriority> priority;
  final Value<BucketStatus> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BucketItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.titleLower = const Value.absent(),
    this.description = const Value.absent(),
    this.descriptionLower = const Value.absent(),
    this.whyWantIt = const Value.absent(),
    this.whyWantItLower = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BucketItemsCompanion.insert({
    required String id,
    required String title,
    required String titleLower,
    this.description = const Value.absent(),
    this.descriptionLower = const Value.absent(),
    this.whyWantIt = const Value.absent(),
    this.whyWantItLower = const Value.absent(),
    required BucketPriority priority,
    required BucketStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       titleLower = Value(titleLower),
       priority = Value(priority),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BucketItem> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? titleLower,
    Expression<String>? description,
    Expression<String>? descriptionLower,
    Expression<String>? whyWantIt,
    Expression<String>? whyWantItLower,
    Expression<String>? priority,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (titleLower != null) 'title_lower': titleLower,
      if (description != null) 'description': description,
      if (descriptionLower != null) 'description_lower': descriptionLower,
      if (whyWantIt != null) 'why_want_it': whyWantIt,
      if (whyWantItLower != null) 'why_want_it_lower': whyWantItLower,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BucketItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? titleLower,
    Value<String?>? description,
    Value<String?>? descriptionLower,
    Value<String?>? whyWantIt,
    Value<String?>? whyWantItLower,
    Value<BucketPriority>? priority,
    Value<BucketStatus>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BucketItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      titleLower: titleLower ?? this.titleLower,
      description: description ?? this.description,
      descriptionLower: descriptionLower ?? this.descriptionLower,
      whyWantIt: whyWantIt ?? this.whyWantIt,
      whyWantItLower: whyWantItLower ?? this.whyWantItLower,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleLower.present) {
      map['title_lower'] = Variable<String>(titleLower.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (descriptionLower.present) {
      map['description_lower'] = Variable<String>(descriptionLower.value);
    }
    if (whyWantIt.present) {
      map['why_want_it'] = Variable<String>(whyWantIt.value);
    }
    if (whyWantItLower.present) {
      map['why_want_it_lower'] = Variable<String>(whyWantItLower.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(
        $BucketItemsTable.$converterpriority.toSql(priority.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $BucketItemsTable.$converterstatus.toSql(status.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BucketItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleLower: $titleLower, ')
          ..write('description: $description, ')
          ..write('descriptionLower: $descriptionLower, ')
          ..write('whyWantIt: $whyWantIt, ')
          ..write('whyWantItLower: $whyWantItLower, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BucketExperiencesTable extends BucketExperiences
    with TableInfo<$BucketExperiencesTable, BucketExperience> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BucketExperiencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bucketItemIdMeta = const VerificationMeta(
    'bucketItemId',
  );
  @override
  late final GeneratedColumn<String> bucketItemId = GeneratedColumn<String>(
    'bucket_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES bucket_items (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _completedDateMeta = const VerificationMeta(
    'completedDate',
  );
  @override
  late final GeneratedColumn<String> completedDate = GeneratedColumn<String>(
    'completed_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _feelingRatingMeta = const VerificationMeta(
    'feelingRating',
  );
  @override
  late final GeneratedColumn<int> feelingRating = GeneratedColumn<int>(
    'feeling_rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _worthItMeta = const VerificationMeta(
    'worthIt',
  );
  @override
  late final GeneratedColumn<bool> worthIt = GeneratedColumn<bool>(
    'worth_it',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("worth_it" IN (0, 1))',
    ),
  );
  static const VerificationMeta _reflectionMeta = const VerificationMeta(
    'reflection',
  );
  @override
  late final GeneratedColumn<String> reflection = GeneratedColumn<String>(
    'reflection',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reflectionLowerMeta = const VerificationMeta(
    'reflectionLower',
  );
  @override
  late final GeneratedColumn<String> reflectionLower = GeneratedColumn<String>(
    'reflection_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bucketItemId,
    completedDate,
    feelingRating,
    worthIt,
    reflection,
    reflectionLower,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bucket_experiences';
  @override
  VerificationContext validateIntegrity(
    Insertable<BucketExperience> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bucket_item_id')) {
      context.handle(
        _bucketItemIdMeta,
        bucketItemId.isAcceptableOrUnknown(
          data['bucket_item_id']!,
          _bucketItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bucketItemIdMeta);
    }
    if (data.containsKey('completed_date')) {
      context.handle(
        _completedDateMeta,
        completedDate.isAcceptableOrUnknown(
          data['completed_date']!,
          _completedDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedDateMeta);
    }
    if (data.containsKey('feeling_rating')) {
      context.handle(
        _feelingRatingMeta,
        feelingRating.isAcceptableOrUnknown(
          data['feeling_rating']!,
          _feelingRatingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_feelingRatingMeta);
    }
    if (data.containsKey('worth_it')) {
      context.handle(
        _worthItMeta,
        worthIt.isAcceptableOrUnknown(data['worth_it']!, _worthItMeta),
      );
    } else if (isInserting) {
      context.missing(_worthItMeta);
    }
    if (data.containsKey('reflection')) {
      context.handle(
        _reflectionMeta,
        reflection.isAcceptableOrUnknown(data['reflection']!, _reflectionMeta),
      );
    }
    if (data.containsKey('reflection_lower')) {
      context.handle(
        _reflectionLowerMeta,
        reflectionLower.isAcceptableOrUnknown(
          data['reflection_lower']!,
          _reflectionLowerMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BucketExperience map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BucketExperience(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bucketItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bucket_item_id'],
      )!,
      completedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_date'],
      )!,
      feelingRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}feeling_rating'],
      )!,
      worthIt: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}worth_it'],
      )!,
      reflection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reflection'],
      ),
      reflectionLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reflection_lower'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BucketExperiencesTable createAlias(String alias) {
    return $BucketExperiencesTable(attachedDatabase, alias);
  }
}

class BucketExperience extends DataClass
    implements Insertable<BucketExperience> {
  final String id;
  final String bucketItemId;
  final String completedDate;
  final int feelingRating;
  final bool worthIt;
  final String? reflection;
  final String? reflectionLower;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BucketExperience({
    required this.id,
    required this.bucketItemId,
    required this.completedDate,
    required this.feelingRating,
    required this.worthIt,
    this.reflection,
    this.reflectionLower,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bucket_item_id'] = Variable<String>(bucketItemId);
    map['completed_date'] = Variable<String>(completedDate);
    map['feeling_rating'] = Variable<int>(feelingRating);
    map['worth_it'] = Variable<bool>(worthIt);
    if (!nullToAbsent || reflection != null) {
      map['reflection'] = Variable<String>(reflection);
    }
    if (!nullToAbsent || reflectionLower != null) {
      map['reflection_lower'] = Variable<String>(reflectionLower);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BucketExperiencesCompanion toCompanion(bool nullToAbsent) {
    return BucketExperiencesCompanion(
      id: Value(id),
      bucketItemId: Value(bucketItemId),
      completedDate: Value(completedDate),
      feelingRating: Value(feelingRating),
      worthIt: Value(worthIt),
      reflection: reflection == null && nullToAbsent
          ? const Value.absent()
          : Value(reflection),
      reflectionLower: reflectionLower == null && nullToAbsent
          ? const Value.absent()
          : Value(reflectionLower),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BucketExperience.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BucketExperience(
      id: serializer.fromJson<String>(json['id']),
      bucketItemId: serializer.fromJson<String>(json['bucketItemId']),
      completedDate: serializer.fromJson<String>(json['completedDate']),
      feelingRating: serializer.fromJson<int>(json['feelingRating']),
      worthIt: serializer.fromJson<bool>(json['worthIt']),
      reflection: serializer.fromJson<String?>(json['reflection']),
      reflectionLower: serializer.fromJson<String?>(json['reflectionLower']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bucketItemId': serializer.toJson<String>(bucketItemId),
      'completedDate': serializer.toJson<String>(completedDate),
      'feelingRating': serializer.toJson<int>(feelingRating),
      'worthIt': serializer.toJson<bool>(worthIt),
      'reflection': serializer.toJson<String?>(reflection),
      'reflectionLower': serializer.toJson<String?>(reflectionLower),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BucketExperience copyWith({
    String? id,
    String? bucketItemId,
    String? completedDate,
    int? feelingRating,
    bool? worthIt,
    Value<String?> reflection = const Value.absent(),
    Value<String?> reflectionLower = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BucketExperience(
    id: id ?? this.id,
    bucketItemId: bucketItemId ?? this.bucketItemId,
    completedDate: completedDate ?? this.completedDate,
    feelingRating: feelingRating ?? this.feelingRating,
    worthIt: worthIt ?? this.worthIt,
    reflection: reflection.present ? reflection.value : this.reflection,
    reflectionLower: reflectionLower.present
        ? reflectionLower.value
        : this.reflectionLower,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BucketExperience copyWithCompanion(BucketExperiencesCompanion data) {
    return BucketExperience(
      id: data.id.present ? data.id.value : this.id,
      bucketItemId: data.bucketItemId.present
          ? data.bucketItemId.value
          : this.bucketItemId,
      completedDate: data.completedDate.present
          ? data.completedDate.value
          : this.completedDate,
      feelingRating: data.feelingRating.present
          ? data.feelingRating.value
          : this.feelingRating,
      worthIt: data.worthIt.present ? data.worthIt.value : this.worthIt,
      reflection: data.reflection.present
          ? data.reflection.value
          : this.reflection,
      reflectionLower: data.reflectionLower.present
          ? data.reflectionLower.value
          : this.reflectionLower,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BucketExperience(')
          ..write('id: $id, ')
          ..write('bucketItemId: $bucketItemId, ')
          ..write('completedDate: $completedDate, ')
          ..write('feelingRating: $feelingRating, ')
          ..write('worthIt: $worthIt, ')
          ..write('reflection: $reflection, ')
          ..write('reflectionLower: $reflectionLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bucketItemId,
    completedDate,
    feelingRating,
    worthIt,
    reflection,
    reflectionLower,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BucketExperience &&
          other.id == this.id &&
          other.bucketItemId == this.bucketItemId &&
          other.completedDate == this.completedDate &&
          other.feelingRating == this.feelingRating &&
          other.worthIt == this.worthIt &&
          other.reflection == this.reflection &&
          other.reflectionLower == this.reflectionLower &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BucketExperiencesCompanion extends UpdateCompanion<BucketExperience> {
  final Value<String> id;
  final Value<String> bucketItemId;
  final Value<String> completedDate;
  final Value<int> feelingRating;
  final Value<bool> worthIt;
  final Value<String?> reflection;
  final Value<String?> reflectionLower;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BucketExperiencesCompanion({
    this.id = const Value.absent(),
    this.bucketItemId = const Value.absent(),
    this.completedDate = const Value.absent(),
    this.feelingRating = const Value.absent(),
    this.worthIt = const Value.absent(),
    this.reflection = const Value.absent(),
    this.reflectionLower = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BucketExperiencesCompanion.insert({
    required String id,
    required String bucketItemId,
    required String completedDate,
    required int feelingRating,
    required bool worthIt,
    this.reflection = const Value.absent(),
    this.reflectionLower = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bucketItemId = Value(bucketItemId),
       completedDate = Value(completedDate),
       feelingRating = Value(feelingRating),
       worthIt = Value(worthIt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BucketExperience> custom({
    Expression<String>? id,
    Expression<String>? bucketItemId,
    Expression<String>? completedDate,
    Expression<int>? feelingRating,
    Expression<bool>? worthIt,
    Expression<String>? reflection,
    Expression<String>? reflectionLower,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bucketItemId != null) 'bucket_item_id': bucketItemId,
      if (completedDate != null) 'completed_date': completedDate,
      if (feelingRating != null) 'feeling_rating': feelingRating,
      if (worthIt != null) 'worth_it': worthIt,
      if (reflection != null) 'reflection': reflection,
      if (reflectionLower != null) 'reflection_lower': reflectionLower,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BucketExperiencesCompanion copyWith({
    Value<String>? id,
    Value<String>? bucketItemId,
    Value<String>? completedDate,
    Value<int>? feelingRating,
    Value<bool>? worthIt,
    Value<String?>? reflection,
    Value<String?>? reflectionLower,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BucketExperiencesCompanion(
      id: id ?? this.id,
      bucketItemId: bucketItemId ?? this.bucketItemId,
      completedDate: completedDate ?? this.completedDate,
      feelingRating: feelingRating ?? this.feelingRating,
      worthIt: worthIt ?? this.worthIt,
      reflection: reflection ?? this.reflection,
      reflectionLower: reflectionLower ?? this.reflectionLower,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bucketItemId.present) {
      map['bucket_item_id'] = Variable<String>(bucketItemId.value);
    }
    if (completedDate.present) {
      map['completed_date'] = Variable<String>(completedDate.value);
    }
    if (feelingRating.present) {
      map['feeling_rating'] = Variable<int>(feelingRating.value);
    }
    if (worthIt.present) {
      map['worth_it'] = Variable<bool>(worthIt.value);
    }
    if (reflection.present) {
      map['reflection'] = Variable<String>(reflection.value);
    }
    if (reflectionLower.present) {
      map['reflection_lower'] = Variable<String>(reflectionLower.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BucketExperiencesCompanion(')
          ..write('id: $id, ')
          ..write('bucketItemId: $bucketItemId, ')
          ..write('completedDate: $completedDate, ')
          ..write('feelingRating: $feelingRating, ')
          ..write('worthIt: $worthIt, ')
          ..write('reflection: $reflection, ')
          ..write('reflectionLower: $reflectionLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TripsTable extends Trips with TableInfo<$TripsTable, Trip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleLowerMeta = const VerificationMeta(
    'titleLower',
  );
  @override
  late final GeneratedColumn<String> titleLower = GeneratedColumn<String>(
    'title_lower',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinationMeta = const VerificationMeta(
    'destination',
  );
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
    'destination',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinationLowerMeta = const VerificationMeta(
    'destinationLower',
  );
  @override
  late final GeneratedColumn<String> destinationLower = GeneratedColumn<String>(
    'destination_lower',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromDateMeta = const VerificationMeta(
    'fromDate',
  );
  @override
  late final GeneratedColumn<String> fromDate = GeneratedColumn<String>(
    'from_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toDateMeta = const VerificationMeta('toDate');
  @override
  late final GeneratedColumn<String> toDate = GeneratedColumn<String>(
    'to_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _overallMeta = const VerificationMeta(
    'overall',
  );
  @override
  late final GeneratedColumn<int> overall = GeneratedColumn<int>(
    'overall',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _funMeta = const VerificationMeta('fun');
  @override
  late final GeneratedColumn<int> fun = GeneratedColumn<int>(
    'fun',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _foodMeta = const VerificationMeta('food');
  @override
  late final GeneratedColumn<int> food = GeneratedColumn<int>(
    'food',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sightsMeta = const VerificationMeta('sights');
  @override
  late final GeneratedColumn<int> sights = GeneratedColumn<int>(
    'sights',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wouldRepeatMeta = const VerificationMeta(
    'wouldRepeat',
  );
  @override
  late final GeneratedColumn<bool> wouldRepeat = GeneratedColumn<bool>(
    'would_repeat',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("would_repeat" IN (0, 1))',
    ),
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _commentLowerMeta = const VerificationMeta(
    'commentLower',
  );
  @override
  late final GeneratedColumn<String> commentLower = GeneratedColumn<String>(
    'comment_lower',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    titleLower,
    destination,
    destinationLower,
    fromDate,
    toDate,
    overall,
    fun,
    food,
    sights,
    value,
    wouldRepeat,
    comment,
    commentLower,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<Trip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('title_lower')) {
      context.handle(
        _titleLowerMeta,
        titleLower.isAcceptableOrUnknown(data['title_lower']!, _titleLowerMeta),
      );
    } else if (isInserting) {
      context.missing(_titleLowerMeta);
    }
    if (data.containsKey('destination')) {
      context.handle(
        _destinationMeta,
        destination.isAcceptableOrUnknown(
          data['destination']!,
          _destinationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationMeta);
    }
    if (data.containsKey('destination_lower')) {
      context.handle(
        _destinationLowerMeta,
        destinationLower.isAcceptableOrUnknown(
          data['destination_lower']!,
          _destinationLowerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationLowerMeta);
    }
    if (data.containsKey('from_date')) {
      context.handle(
        _fromDateMeta,
        fromDate.isAcceptableOrUnknown(data['from_date']!, _fromDateMeta),
      );
    } else if (isInserting) {
      context.missing(_fromDateMeta);
    }
    if (data.containsKey('to_date')) {
      context.handle(
        _toDateMeta,
        toDate.isAcceptableOrUnknown(data['to_date']!, _toDateMeta),
      );
    } else if (isInserting) {
      context.missing(_toDateMeta);
    }
    if (data.containsKey('overall')) {
      context.handle(
        _overallMeta,
        overall.isAcceptableOrUnknown(data['overall']!, _overallMeta),
      );
    } else if (isInserting) {
      context.missing(_overallMeta);
    }
    if (data.containsKey('fun')) {
      context.handle(
        _funMeta,
        fun.isAcceptableOrUnknown(data['fun']!, _funMeta),
      );
    }
    if (data.containsKey('food')) {
      context.handle(
        _foodMeta,
        food.isAcceptableOrUnknown(data['food']!, _foodMeta),
      );
    }
    if (data.containsKey('sights')) {
      context.handle(
        _sightsMeta,
        sights.isAcceptableOrUnknown(data['sights']!, _sightsMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('would_repeat')) {
      context.handle(
        _wouldRepeatMeta,
        wouldRepeat.isAcceptableOrUnknown(
          data['would_repeat']!,
          _wouldRepeatMeta,
        ),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('comment_lower')) {
      context.handle(
        _commentLowerMeta,
        commentLower.isAcceptableOrUnknown(
          data['comment_lower']!,
          _commentLowerMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      titleLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_lower'],
      )!,
      destination: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination'],
      )!,
      destinationLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_lower'],
      )!,
      fromDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_date'],
      )!,
      toDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_date'],
      )!,
      overall: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}overall'],
      )!,
      fun: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fun'],
      ),
      food: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food'],
      ),
      sights: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sights'],
      ),
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      ),
      wouldRepeat: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}would_repeat'],
      ),
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      commentLower: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment_lower'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }
}

class Trip extends DataClass implements Insertable<Trip> {
  final String id;
  final String title;
  final String titleLower;
  final String destination;
  final String destinationLower;
  final String fromDate;
  final String toDate;
  final int overall;
  final int? fun;
  final int? food;
  final int? sights;
  final int? value;
  final bool? wouldRepeat;
  final String? comment;
  final String? commentLower;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Trip({
    required this.id,
    required this.title,
    required this.titleLower,
    required this.destination,
    required this.destinationLower,
    required this.fromDate,
    required this.toDate,
    required this.overall,
    this.fun,
    this.food,
    this.sights,
    this.value,
    this.wouldRepeat,
    this.comment,
    this.commentLower,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['title_lower'] = Variable<String>(titleLower);
    map['destination'] = Variable<String>(destination);
    map['destination_lower'] = Variable<String>(destinationLower);
    map['from_date'] = Variable<String>(fromDate);
    map['to_date'] = Variable<String>(toDate);
    map['overall'] = Variable<int>(overall);
    if (!nullToAbsent || fun != null) {
      map['fun'] = Variable<int>(fun);
    }
    if (!nullToAbsent || food != null) {
      map['food'] = Variable<int>(food);
    }
    if (!nullToAbsent || sights != null) {
      map['sights'] = Variable<int>(sights);
    }
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<int>(value);
    }
    if (!nullToAbsent || wouldRepeat != null) {
      map['would_repeat'] = Variable<bool>(wouldRepeat);
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    if (!nullToAbsent || commentLower != null) {
      map['comment_lower'] = Variable<String>(commentLower);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
      title: Value(title),
      titleLower: Value(titleLower),
      destination: Value(destination),
      destinationLower: Value(destinationLower),
      fromDate: Value(fromDate),
      toDate: Value(toDate),
      overall: Value(overall),
      fun: fun == null && nullToAbsent ? const Value.absent() : Value(fun),
      food: food == null && nullToAbsent ? const Value.absent() : Value(food),
      sights: sights == null && nullToAbsent
          ? const Value.absent()
          : Value(sights),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      wouldRepeat: wouldRepeat == null && nullToAbsent
          ? const Value.absent()
          : Value(wouldRepeat),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      commentLower: commentLower == null && nullToAbsent
          ? const Value.absent()
          : Value(commentLower),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Trip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trip(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      titleLower: serializer.fromJson<String>(json['titleLower']),
      destination: serializer.fromJson<String>(json['destination']),
      destinationLower: serializer.fromJson<String>(json['destinationLower']),
      fromDate: serializer.fromJson<String>(json['fromDate']),
      toDate: serializer.fromJson<String>(json['toDate']),
      overall: serializer.fromJson<int>(json['overall']),
      fun: serializer.fromJson<int?>(json['fun']),
      food: serializer.fromJson<int?>(json['food']),
      sights: serializer.fromJson<int?>(json['sights']),
      value: serializer.fromJson<int?>(json['value']),
      wouldRepeat: serializer.fromJson<bool?>(json['wouldRepeat']),
      comment: serializer.fromJson<String?>(json['comment']),
      commentLower: serializer.fromJson<String?>(json['commentLower']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'titleLower': serializer.toJson<String>(titleLower),
      'destination': serializer.toJson<String>(destination),
      'destinationLower': serializer.toJson<String>(destinationLower),
      'fromDate': serializer.toJson<String>(fromDate),
      'toDate': serializer.toJson<String>(toDate),
      'overall': serializer.toJson<int>(overall),
      'fun': serializer.toJson<int?>(fun),
      'food': serializer.toJson<int?>(food),
      'sights': serializer.toJson<int?>(sights),
      'value': serializer.toJson<int?>(value),
      'wouldRepeat': serializer.toJson<bool?>(wouldRepeat),
      'comment': serializer.toJson<String?>(comment),
      'commentLower': serializer.toJson<String?>(commentLower),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Trip copyWith({
    String? id,
    String? title,
    String? titleLower,
    String? destination,
    String? destinationLower,
    String? fromDate,
    String? toDate,
    int? overall,
    Value<int?> fun = const Value.absent(),
    Value<int?> food = const Value.absent(),
    Value<int?> sights = const Value.absent(),
    Value<int?> value = const Value.absent(),
    Value<bool?> wouldRepeat = const Value.absent(),
    Value<String?> comment = const Value.absent(),
    Value<String?> commentLower = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Trip(
    id: id ?? this.id,
    title: title ?? this.title,
    titleLower: titleLower ?? this.titleLower,
    destination: destination ?? this.destination,
    destinationLower: destinationLower ?? this.destinationLower,
    fromDate: fromDate ?? this.fromDate,
    toDate: toDate ?? this.toDate,
    overall: overall ?? this.overall,
    fun: fun.present ? fun.value : this.fun,
    food: food.present ? food.value : this.food,
    sights: sights.present ? sights.value : this.sights,
    value: value.present ? value.value : this.value,
    wouldRepeat: wouldRepeat.present ? wouldRepeat.value : this.wouldRepeat,
    comment: comment.present ? comment.value : this.comment,
    commentLower: commentLower.present ? commentLower.value : this.commentLower,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Trip copyWithCompanion(TripsCompanion data) {
    return Trip(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      titleLower: data.titleLower.present
          ? data.titleLower.value
          : this.titleLower,
      destination: data.destination.present
          ? data.destination.value
          : this.destination,
      destinationLower: data.destinationLower.present
          ? data.destinationLower.value
          : this.destinationLower,
      fromDate: data.fromDate.present ? data.fromDate.value : this.fromDate,
      toDate: data.toDate.present ? data.toDate.value : this.toDate,
      overall: data.overall.present ? data.overall.value : this.overall,
      fun: data.fun.present ? data.fun.value : this.fun,
      food: data.food.present ? data.food.value : this.food,
      sights: data.sights.present ? data.sights.value : this.sights,
      value: data.value.present ? data.value.value : this.value,
      wouldRepeat: data.wouldRepeat.present
          ? data.wouldRepeat.value
          : this.wouldRepeat,
      comment: data.comment.present ? data.comment.value : this.comment,
      commentLower: data.commentLower.present
          ? data.commentLower.value
          : this.commentLower,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trip(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleLower: $titleLower, ')
          ..write('destination: $destination, ')
          ..write('destinationLower: $destinationLower, ')
          ..write('fromDate: $fromDate, ')
          ..write('toDate: $toDate, ')
          ..write('overall: $overall, ')
          ..write('fun: $fun, ')
          ..write('food: $food, ')
          ..write('sights: $sights, ')
          ..write('value: $value, ')
          ..write('wouldRepeat: $wouldRepeat, ')
          ..write('comment: $comment, ')
          ..write('commentLower: $commentLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    titleLower,
    destination,
    destinationLower,
    fromDate,
    toDate,
    overall,
    fun,
    food,
    sights,
    value,
    wouldRepeat,
    comment,
    commentLower,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trip &&
          other.id == this.id &&
          other.title == this.title &&
          other.titleLower == this.titleLower &&
          other.destination == this.destination &&
          other.destinationLower == this.destinationLower &&
          other.fromDate == this.fromDate &&
          other.toDate == this.toDate &&
          other.overall == this.overall &&
          other.fun == this.fun &&
          other.food == this.food &&
          other.sights == this.sights &&
          other.value == this.value &&
          other.wouldRepeat == this.wouldRepeat &&
          other.comment == this.comment &&
          other.commentLower == this.commentLower &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TripsCompanion extends UpdateCompanion<Trip> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> titleLower;
  final Value<String> destination;
  final Value<String> destinationLower;
  final Value<String> fromDate;
  final Value<String> toDate;
  final Value<int> overall;
  final Value<int?> fun;
  final Value<int?> food;
  final Value<int?> sights;
  final Value<int?> value;
  final Value<bool?> wouldRepeat;
  final Value<String?> comment;
  final Value<String?> commentLower;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.titleLower = const Value.absent(),
    this.destination = const Value.absent(),
    this.destinationLower = const Value.absent(),
    this.fromDate = const Value.absent(),
    this.toDate = const Value.absent(),
    this.overall = const Value.absent(),
    this.fun = const Value.absent(),
    this.food = const Value.absent(),
    this.sights = const Value.absent(),
    this.value = const Value.absent(),
    this.wouldRepeat = const Value.absent(),
    this.comment = const Value.absent(),
    this.commentLower = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripsCompanion.insert({
    required String id,
    required String title,
    required String titleLower,
    required String destination,
    required String destinationLower,
    required String fromDate,
    required String toDate,
    required int overall,
    this.fun = const Value.absent(),
    this.food = const Value.absent(),
    this.sights = const Value.absent(),
    this.value = const Value.absent(),
    this.wouldRepeat = const Value.absent(),
    this.comment = const Value.absent(),
    this.commentLower = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       titleLower = Value(titleLower),
       destination = Value(destination),
       destinationLower = Value(destinationLower),
       fromDate = Value(fromDate),
       toDate = Value(toDate),
       overall = Value(overall),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Trip> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? titleLower,
    Expression<String>? destination,
    Expression<String>? destinationLower,
    Expression<String>? fromDate,
    Expression<String>? toDate,
    Expression<int>? overall,
    Expression<int>? fun,
    Expression<int>? food,
    Expression<int>? sights,
    Expression<int>? value,
    Expression<bool>? wouldRepeat,
    Expression<String>? comment,
    Expression<String>? commentLower,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (titleLower != null) 'title_lower': titleLower,
      if (destination != null) 'destination': destination,
      if (destinationLower != null) 'destination_lower': destinationLower,
      if (fromDate != null) 'from_date': fromDate,
      if (toDate != null) 'to_date': toDate,
      if (overall != null) 'overall': overall,
      if (fun != null) 'fun': fun,
      if (food != null) 'food': food,
      if (sights != null) 'sights': sights,
      if (value != null) 'value': value,
      if (wouldRepeat != null) 'would_repeat': wouldRepeat,
      if (comment != null) 'comment': comment,
      if (commentLower != null) 'comment_lower': commentLower,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? titleLower,
    Value<String>? destination,
    Value<String>? destinationLower,
    Value<String>? fromDate,
    Value<String>? toDate,
    Value<int>? overall,
    Value<int?>? fun,
    Value<int?>? food,
    Value<int?>? sights,
    Value<int?>? value,
    Value<bool?>? wouldRepeat,
    Value<String?>? comment,
    Value<String?>? commentLower,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TripsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      titleLower: titleLower ?? this.titleLower,
      destination: destination ?? this.destination,
      destinationLower: destinationLower ?? this.destinationLower,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      overall: overall ?? this.overall,
      fun: fun ?? this.fun,
      food: food ?? this.food,
      sights: sights ?? this.sights,
      value: value ?? this.value,
      wouldRepeat: wouldRepeat ?? this.wouldRepeat,
      comment: comment ?? this.comment,
      commentLower: commentLower ?? this.commentLower,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleLower.present) {
      map['title_lower'] = Variable<String>(titleLower.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (destinationLower.present) {
      map['destination_lower'] = Variable<String>(destinationLower.value);
    }
    if (fromDate.present) {
      map['from_date'] = Variable<String>(fromDate.value);
    }
    if (toDate.present) {
      map['to_date'] = Variable<String>(toDate.value);
    }
    if (overall.present) {
      map['overall'] = Variable<int>(overall.value);
    }
    if (fun.present) {
      map['fun'] = Variable<int>(fun.value);
    }
    if (food.present) {
      map['food'] = Variable<int>(food.value);
    }
    if (sights.present) {
      map['sights'] = Variable<int>(sights.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (wouldRepeat.present) {
      map['would_repeat'] = Variable<bool>(wouldRepeat.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (commentLower.present) {
      map['comment_lower'] = Variable<String>(commentLower.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleLower: $titleLower, ')
          ..write('destination: $destination, ')
          ..write('destinationLower: $destinationLower, ')
          ..write('fromDate: $fromDate, ')
          ..write('toDate: $toDate, ')
          ..write('overall: $overall, ')
          ..write('fun: $fun, ')
          ..write('food: $food, ')
          ..write('sights: $sights, ')
          ..write('value: $value, ')
          ..write('wouldRepeat: $wouldRepeat, ')
          ..write('comment: $comment, ')
          ..write('commentLower: $commentLower, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments
    with TableInfo<$AttachmentsTable, Attachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AttachmentEntity, String>
  entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<AttachmentEntity>($AttachmentsTable.$converterentityType);
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AttachmentRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AttachmentRole>($AttachmentsTable.$converterrole);
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbPathMeta = const VerificationMeta(
    'thumbPath',
  );
  @override
  late final GeneratedColumn<String> thumbPath = GeneratedColumn<String>(
    'thumb_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileTypeMeta = const VerificationMeta(
    'fileType',
  );
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
    'file_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalFileNameMeta = const VerificationMeta(
    'originalFileName',
  );
  @override
  late final GeneratedColumn<String> originalFileName = GeneratedColumn<String>(
    'original_file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    role,
    filePath,
    thumbPath,
    fileType,
    originalFileName,
    fileSize,
    width,
    height,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('thumb_path')) {
      context.handle(
        _thumbPathMeta,
        thumbPath.isAcceptableOrUnknown(data['thumb_path']!, _thumbPathMeta),
      );
    } else if (isInserting) {
      context.missing(_thumbPathMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(
        _fileTypeMeta,
        fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileTypeMeta);
    }
    if (data.containsKey('original_file_name')) {
      context.handle(
        _originalFileNameMeta,
        originalFileName.isAcceptableOrUnknown(
          data['original_file_name']!,
          _originalFileNameMeta,
        ),
      );
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: $AttachmentsTable.$converterentityType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}entity_type'],
        )!,
      ),
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      role: $AttachmentsTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      thumbPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumb_path'],
      )!,
      fileType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_type'],
      )!,
      originalFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_file_name'],
      ),
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(attachedDatabase, alias);
  }

  static TypeConverter<AttachmentEntity, String> $converterentityType =
      attachmentEntityConverter;
  static TypeConverter<AttachmentRole, String> $converterrole =
      attachmentRoleConverter;
}

class Attachment extends DataClass implements Insertable<Attachment> {
  final String id;
  final AttachmentEntity entityType;
  final String entityId;
  final AttachmentRole role;
  final String filePath;
  final String thumbPath;
  final String fileType;
  final String? originalFileName;
  final int fileSize;
  final int? width;
  final int? height;
  final int sortOrder;
  final DateTime createdAt;
  const Attachment({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.role,
    required this.filePath,
    required this.thumbPath,
    required this.fileType,
    this.originalFileName,
    required this.fileSize,
    this.width,
    this.height,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['entity_type'] = Variable<String>(
        $AttachmentsTable.$converterentityType.toSql(entityType),
      );
    }
    map['entity_id'] = Variable<String>(entityId);
    {
      map['role'] = Variable<String>(
        $AttachmentsTable.$converterrole.toSql(role),
      );
    }
    map['file_path'] = Variable<String>(filePath);
    map['thumb_path'] = Variable<String>(thumbPath);
    map['file_type'] = Variable<String>(fileType);
    if (!nullToAbsent || originalFileName != null) {
      map['original_file_name'] = Variable<String>(originalFileName);
    }
    map['file_size'] = Variable<int>(fileSize);
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      role: Value(role),
      filePath: Value(filePath),
      thumbPath: Value(thumbPath),
      fileType: Value(fileType),
      originalFileName: originalFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(originalFileName),
      fileSize: Value(fileSize),
      width: width == null && nullToAbsent
          ? const Value.absent()
          : Value(width),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory Attachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attachment(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<AttachmentEntity>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      role: serializer.fromJson<AttachmentRole>(json['role']),
      filePath: serializer.fromJson<String>(json['filePath']),
      thumbPath: serializer.fromJson<String>(json['thumbPath']),
      fileType: serializer.fromJson<String>(json['fileType']),
      originalFileName: serializer.fromJson<String?>(json['originalFileName']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<AttachmentEntity>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'role': serializer.toJson<AttachmentRole>(role),
      'filePath': serializer.toJson<String>(filePath),
      'thumbPath': serializer.toJson<String>(thumbPath),
      'fileType': serializer.toJson<String>(fileType),
      'originalFileName': serializer.toJson<String?>(originalFileName),
      'fileSize': serializer.toJson<int>(fileSize),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Attachment copyWith({
    String? id,
    AttachmentEntity? entityType,
    String? entityId,
    AttachmentRole? role,
    String? filePath,
    String? thumbPath,
    String? fileType,
    Value<String?> originalFileName = const Value.absent(),
    int? fileSize,
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
  }) => Attachment(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    role: role ?? this.role,
    filePath: filePath ?? this.filePath,
    thumbPath: thumbPath ?? this.thumbPath,
    fileType: fileType ?? this.fileType,
    originalFileName: originalFileName.present
        ? originalFileName.value
        : this.originalFileName,
    fileSize: fileSize ?? this.fileSize,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  Attachment copyWithCompanion(AttachmentsCompanion data) {
    return Attachment(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      role: data.role.present ? data.role.value : this.role,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      thumbPath: data.thumbPath.present ? data.thumbPath.value : this.thumbPath,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      originalFileName: data.originalFileName.present
          ? data.originalFileName.value
          : this.originalFileName,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attachment(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('role: $role, ')
          ..write('filePath: $filePath, ')
          ..write('thumbPath: $thumbPath, ')
          ..write('fileType: $fileType, ')
          ..write('originalFileName: $originalFileName, ')
          ..write('fileSize: $fileSize, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    role,
    filePath,
    thumbPath,
    fileType,
    originalFileName,
    fileSize,
    width,
    height,
    sortOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attachment &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.role == this.role &&
          other.filePath == this.filePath &&
          other.thumbPath == this.thumbPath &&
          other.fileType == this.fileType &&
          other.originalFileName == this.originalFileName &&
          other.fileSize == this.fileSize &&
          other.width == this.width &&
          other.height == this.height &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class AttachmentsCompanion extends UpdateCompanion<Attachment> {
  final Value<String> id;
  final Value<AttachmentEntity> entityType;
  final Value<String> entityId;
  final Value<AttachmentRole> role;
  final Value<String> filePath;
  final Value<String> thumbPath;
  final Value<String> fileType;
  final Value<String?> originalFileName;
  final Value<int> fileSize;
  final Value<int?> width;
  final Value<int?> height;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.role = const Value.absent(),
    this.filePath = const Value.absent(),
    this.thumbPath = const Value.absent(),
    this.fileType = const Value.absent(),
    this.originalFileName = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    required String id,
    required AttachmentEntity entityType,
    required String entityId,
    required AttachmentRole role,
    required String filePath,
    required String thumbPath,
    required String fileType,
    this.originalFileName = const Value.absent(),
    required int fileSize,
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       role = Value(role),
       filePath = Value(filePath),
       thumbPath = Value(thumbPath),
       fileType = Value(fileType),
       fileSize = Value(fileSize),
       createdAt = Value(createdAt);
  static Insertable<Attachment> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? role,
    Expression<String>? filePath,
    Expression<String>? thumbPath,
    Expression<String>? fileType,
    Expression<String>? originalFileName,
    Expression<int>? fileSize,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (role != null) 'role': role,
      if (filePath != null) 'file_path': filePath,
      if (thumbPath != null) 'thumb_path': thumbPath,
      if (fileType != null) 'file_type': fileType,
      if (originalFileName != null) 'original_file_name': originalFileName,
      if (fileSize != null) 'file_size': fileSize,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttachmentsCompanion copyWith({
    Value<String>? id,
    Value<AttachmentEntity>? entityType,
    Value<String>? entityId,
    Value<AttachmentRole>? role,
    Value<String>? filePath,
    Value<String>? thumbPath,
    Value<String>? fileType,
    Value<String?>? originalFileName,
    Value<int>? fileSize,
    Value<int?>? width,
    Value<int?>? height,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      role: role ?? this.role,
      filePath: filePath ?? this.filePath,
      thumbPath: thumbPath ?? this.thumbPath,
      fileType: fileType ?? this.fileType,
      originalFileName: originalFileName ?? this.originalFileName,
      fileSize: fileSize ?? this.fileSize,
      width: width ?? this.width,
      height: height ?? this.height,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(
        $AttachmentsTable.$converterentityType.toSql(entityType.value),
      );
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $AttachmentsTable.$converterrole.toSql(role.value),
      );
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (thumbPath.present) {
      map['thumb_path'] = Variable<String>(thumbPath.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (originalFileName.present) {
      map['original_file_name'] = Variable<String>(originalFileName.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('role: $role, ')
          ..write('filePath: $filePath, ')
          ..write('thumbPath: $thumbPath, ')
          ..write('fileType: $fileType, ')
          ..write('originalFileName: $originalFileName, ')
          ..write('fileSize: $fileSize, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MealsTable meals = $MealsTable(this);
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $IncomeTable income = $IncomeTable(this);
  late final $HealthEventsTable healthEvents = $HealthEventsTable(this);
  late final $LabTestsTable labTests = $LabTestsTable(this);
  late final $BloodPressureLogsTable bloodPressureLogs =
      $BloodPressureLogsTable(this);
  late final $MedicationLogsTable medicationLogs = $MedicationLogsTable(this);
  late final $DailyLogsTable dailyLogs = $DailyLogsTable(this);
  late final $StepsTable steps = $StepsTable(this);
  late final $BucketItemsTable bucketItems = $BucketItemsTable(this);
  late final $BucketExperiencesTable bucketExperiences =
      $BucketExperiencesTable(this);
  late final $TripsTable trips = $TripsTable(this);
  late final $AttachmentsTable attachments = $AttachmentsTable(this);
  late final Index idxAttachmentsEntity = Index(
    'idx_attachments_entity',
    'CREATE INDEX idx_attachments_entity ON attachments (entity_type, entity_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    meals,
    activities,
    expenses,
    income,
    healthEvents,
    labTests,
    bloodPressureLogs,
    medicationLogs,
    dailyLogs,
    steps,
    bucketItems,
    bucketExperiences,
    trips,
    attachments,
    idxAttachmentsEntity,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'bucket_items',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bucket_experiences', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$MealsTableCreateCompanionBuilder =
    MealsCompanion Function({
      required String id,
      required String date,
      Value<String?> time,
      required String name,
      required String nameLower,
      required MealType type,
      Value<String?> quantity,
      Value<int?> calories,
      Value<double?> protein,
      Value<double?> carbs,
      Value<double?> fat,
      Value<String?> note,
      Value<String?> noteLower,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$MealsTableUpdateCompanionBuilder =
    MealsCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<String?> time,
      Value<String> name,
      Value<String> nameLower,
      Value<MealType> type,
      Value<String?> quantity,
      Value<int?> calories,
      Value<double?> protein,
      Value<double?> carbs,
      Value<double?> fat,
      Value<String?> note,
      Value<String?> noteLower,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameLower => $composableBuilder(
    column: $table.nameLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MealType, MealType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameLower => $composableBuilder(
    column: $table.nameLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameLower =>
      $composableBuilder(column: $table.nameLower, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MealType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get noteLower =>
      $composableBuilder(column: $table.noteLower, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealsTable,
          Meal,
          $$MealsTableFilterComposer,
          $$MealsTableOrderingComposer,
          $$MealsTableAnnotationComposer,
          $$MealsTableCreateCompanionBuilder,
          $$MealsTableUpdateCompanionBuilder,
          (Meal, BaseReferences<_$AppDatabase, $MealsTable, Meal>),
          Meal,
          PrefetchHooks Function()
        > {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String?> time = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameLower = const Value.absent(),
                Value<MealType> type = const Value.absent(),
                Value<String?> quantity = const Value.absent(),
                Value<int?> calories = const Value.absent(),
                Value<double?> protein = const Value.absent(),
                Value<double?> carbs = const Value.absent(),
                Value<double?> fat = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealsCompanion(
                id: id,
                date: date,
                time: time,
                name: name,
                nameLower: nameLower,
                type: type,
                quantity: quantity,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                Value<String?> time = const Value.absent(),
                required String name,
                required String nameLower,
                required MealType type,
                Value<String?> quantity = const Value.absent(),
                Value<int?> calories = const Value.absent(),
                Value<double?> protein = const Value.absent(),
                Value<double?> carbs = const Value.absent(),
                Value<double?> fat = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MealsCompanion.insert(
                id: id,
                date: date,
                time: time,
                name: name,
                nameLower: nameLower,
                type: type,
                quantity: quantity,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealsTable,
      Meal,
      $$MealsTableFilterComposer,
      $$MealsTableOrderingComposer,
      $$MealsTableAnnotationComposer,
      $$MealsTableCreateCompanionBuilder,
      $$MealsTableUpdateCompanionBuilder,
      (Meal, BaseReferences<_$AppDatabase, $MealsTable, Meal>),
      Meal,
      PrefetchHooks Function()
    >;
typedef $$ActivitiesTableCreateCompanionBuilder =
    ActivitiesCompanion Function({
      required String id,
      required String date,
      Value<String?> startTime,
      Value<String?> endTime,
      Value<int?> durationMin,
      required ActivityType type,
      Value<String?> name,
      Value<String?> nameLower,
      Value<Intensity?> intensity,
      Value<int?> quality,
      Value<int?> moodAfter,
      Value<String?> note,
      Value<String?> noteLower,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ActivitiesTableUpdateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<String?> startTime,
      Value<String?> endTime,
      Value<int?> durationMin,
      Value<ActivityType> type,
      Value<String?> name,
      Value<String?> nameLower,
      Value<Intensity?> intensity,
      Value<int?> quality,
      Value<int?> moodAfter,
      Value<String?> note,
      Value<String?> noteLower,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ActivityType, ActivityType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameLower => $composableBuilder(
    column: $table.nameLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Intensity?, Intensity, String> get intensity =>
      $composableBuilder(
        column: $table.intensity,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moodAfter => $composableBuilder(
    column: $table.moodAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameLower => $composableBuilder(
    column: $table.nameLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moodAfter => $composableBuilder(
    column: $table.moodAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ActivityType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameLower =>
      $composableBuilder(column: $table.nameLower, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Intensity?, String> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<int> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<int> get moodAfter =>
      $composableBuilder(column: $table.moodAfter, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get noteLower =>
      $composableBuilder(column: $table.noteLower, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivitiesTable,
          Activity,
          $$ActivitiesTableFilterComposer,
          $$ActivitiesTableOrderingComposer,
          $$ActivitiesTableAnnotationComposer,
          $$ActivitiesTableCreateCompanionBuilder,
          $$ActivitiesTableUpdateCompanionBuilder,
          (Activity, BaseReferences<_$AppDatabase, $ActivitiesTable, Activity>),
          Activity,
          PrefetchHooks Function()
        > {
  $$ActivitiesTableTableManager(_$AppDatabase db, $ActivitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<int?> durationMin = const Value.absent(),
                Value<ActivityType> type = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> nameLower = const Value.absent(),
                Value<Intensity?> intensity = const Value.absent(),
                Value<int?> quality = const Value.absent(),
                Value<int?> moodAfter = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesCompanion(
                id: id,
                date: date,
                startTime: startTime,
                endTime: endTime,
                durationMin: durationMin,
                type: type,
                name: name,
                nameLower: nameLower,
                intensity: intensity,
                quality: quality,
                moodAfter: moodAfter,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<int?> durationMin = const Value.absent(),
                required ActivityType type,
                Value<String?> name = const Value.absent(),
                Value<String?> nameLower = const Value.absent(),
                Value<Intensity?> intensity = const Value.absent(),
                Value<int?> quality = const Value.absent(),
                Value<int?> moodAfter = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesCompanion.insert(
                id: id,
                date: date,
                startTime: startTime,
                endTime: endTime,
                durationMin: durationMin,
                type: type,
                name: name,
                nameLower: nameLower,
                intensity: intensity,
                quality: quality,
                moodAfter: moodAfter,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivitiesTable,
      Activity,
      $$ActivitiesTableFilterComposer,
      $$ActivitiesTableOrderingComposer,
      $$ActivitiesTableAnnotationComposer,
      $$ActivitiesTableCreateCompanionBuilder,
      $$ActivitiesTableUpdateCompanionBuilder,
      (Activity, BaseReferences<_$AppDatabase, $ActivitiesTable, Activity>),
      Activity,
      PrefetchHooks Function()
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      required String id,
      required String date,
      Value<String?> time,
      required int amountCents,
      required ExpenseCategory category,
      required String description,
      required String descriptionLower,
      Value<PaymentMethod?> paymentMethod,
      Value<String?> note,
      Value<String?> noteLower,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<String?> time,
      Value<int> amountCents,
      Value<ExpenseCategory> category,
      Value<String> description,
      Value<String> descriptionLower,
      Value<PaymentMethod?> paymentMethod,
      Value<String?> note,
      Value<String?> noteLower,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ExpenseCategory, ExpenseCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionLower => $composableBuilder(
    column: $table.descriptionLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentMethod?, PaymentMethod, String>
  get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionLower => $composableBuilder(
    column: $table.descriptionLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ExpenseCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descriptionLower => $composableBuilder(
    column: $table.descriptionLower,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PaymentMethod?, String> get paymentMethod =>
      $composableBuilder(
        column: $table.paymentMethod,
        builder: (column) => column,
      );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get noteLower =>
      $composableBuilder(column: $table.noteLower, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
          Expense,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String?> time = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<ExpenseCategory> category = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> descriptionLower = const Value.absent(),
                Value<PaymentMethod?> paymentMethod = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                date: date,
                time: time,
                amountCents: amountCents,
                category: category,
                description: description,
                descriptionLower: descriptionLower,
                paymentMethod: paymentMethod,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                Value<String?> time = const Value.absent(),
                required int amountCents,
                required ExpenseCategory category,
                required String description,
                required String descriptionLower,
                Value<PaymentMethod?> paymentMethod = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                date: date,
                time: time,
                amountCents: amountCents,
                category: category,
                description: description,
                descriptionLower: descriptionLower,
                paymentMethod: paymentMethod,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
      Expense,
      PrefetchHooks Function()
    >;
typedef $$IncomeTableCreateCompanionBuilder =
    IncomeCompanion Function({
      required String id,
      required String date,
      required int amountCents,
      required String source,
      required String sourceLower,
      required IncomeCategory category,
      Value<String?> note,
      Value<String?> noteLower,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$IncomeTableUpdateCompanionBuilder =
    IncomeCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<int> amountCents,
      Value<String> source,
      Value<String> sourceLower,
      Value<IncomeCategory> category,
      Value<String?> note,
      Value<String?> noteLower,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$IncomeTableFilterComposer
    extends Composer<_$AppDatabase, $IncomeTable> {
  $$IncomeTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLower => $composableBuilder(
    column: $table.sourceLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IncomeCategory, IncomeCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IncomeTableOrderingComposer
    extends Composer<_$AppDatabase, $IncomeTable> {
  $$IncomeTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLower => $composableBuilder(
    column: $table.sourceLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IncomeTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncomeTable> {
  $$IncomeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get sourceLower => $composableBuilder(
    column: $table.sourceLower,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<IncomeCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get noteLower =>
      $composableBuilder(column: $table.noteLower, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$IncomeTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncomeTable,
          IncomeEntry,
          $$IncomeTableFilterComposer,
          $$IncomeTableOrderingComposer,
          $$IncomeTableAnnotationComposer,
          $$IncomeTableCreateCompanionBuilder,
          $$IncomeTableUpdateCompanionBuilder,
          (
            IncomeEntry,
            BaseReferences<_$AppDatabase, $IncomeTable, IncomeEntry>,
          ),
          IncomeEntry,
          PrefetchHooks Function()
        > {
  $$IncomeTableTableManager(_$AppDatabase db, $IncomeTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomeTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> sourceLower = const Value.absent(),
                Value<IncomeCategory> category = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeCompanion(
                id: id,
                date: date,
                amountCents: amountCents,
                source: source,
                sourceLower: sourceLower,
                category: category,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                required int amountCents,
                required String source,
                required String sourceLower,
                required IncomeCategory category,
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => IncomeCompanion.insert(
                id: id,
                date: date,
                amountCents: amountCents,
                source: source,
                sourceLower: sourceLower,
                category: category,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IncomeTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncomeTable,
      IncomeEntry,
      $$IncomeTableFilterComposer,
      $$IncomeTableOrderingComposer,
      $$IncomeTableAnnotationComposer,
      $$IncomeTableCreateCompanionBuilder,
      $$IncomeTableUpdateCompanionBuilder,
      (IncomeEntry, BaseReferences<_$AppDatabase, $IncomeTable, IncomeEntry>),
      IncomeEntry,
      PrefetchHooks Function()
    >;
typedef $$HealthEventsTableCreateCompanionBuilder =
    HealthEventsCompanion Function({
      required String id,
      required String date,
      required HealthEventType type,
      Value<DentalSubtype?> subtype,
      Value<String?> clinic,
      Value<String?> clinicLower,
      Value<String?> reason,
      Value<String?> reasonLower,
      required String whatWasDone,
      required String whatWasDoneLower,
      Value<int?> priceCents,
      Value<String?> nextRecommendedDate,
      Value<String?> note,
      Value<String?> noteLower,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$HealthEventsTableUpdateCompanionBuilder =
    HealthEventsCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<HealthEventType> type,
      Value<DentalSubtype?> subtype,
      Value<String?> clinic,
      Value<String?> clinicLower,
      Value<String?> reason,
      Value<String?> reasonLower,
      Value<String> whatWasDone,
      Value<String> whatWasDoneLower,
      Value<int?> priceCents,
      Value<String?> nextRecommendedDate,
      Value<String?> note,
      Value<String?> noteLower,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$HealthEventsTableFilterComposer
    extends Composer<_$AppDatabase, $HealthEventsTable> {
  $$HealthEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<HealthEventType, HealthEventType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<DentalSubtype?, DentalSubtype, String>
  get subtype => $composableBuilder(
    column: $table.subtype,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get clinic => $composableBuilder(
    column: $table.clinic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clinicLower => $composableBuilder(
    column: $table.clinicLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonLower => $composableBuilder(
    column: $table.reasonLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatWasDone => $composableBuilder(
    column: $table.whatWasDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatWasDoneLower => $composableBuilder(
    column: $table.whatWasDoneLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextRecommendedDate => $composableBuilder(
    column: $table.nextRecommendedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HealthEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthEventsTable> {
  $$HealthEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtype => $composableBuilder(
    column: $table.subtype,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clinic => $composableBuilder(
    column: $table.clinic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clinicLower => $composableBuilder(
    column: $table.clinicLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonLower => $composableBuilder(
    column: $table.reasonLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatWasDone => $composableBuilder(
    column: $table.whatWasDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatWasDoneLower => $composableBuilder(
    column: $table.whatWasDoneLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextRecommendedDate => $composableBuilder(
    column: $table.nextRecommendedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HealthEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthEventsTable> {
  $$HealthEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<HealthEventType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DentalSubtype?, String> get subtype =>
      $composableBuilder(column: $table.subtype, builder: (column) => column);

  GeneratedColumn<String> get clinic =>
      $composableBuilder(column: $table.clinic, builder: (column) => column);

  GeneratedColumn<String> get clinicLower => $composableBuilder(
    column: $table.clinicLower,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get reasonLower => $composableBuilder(
    column: $table.reasonLower,
    builder: (column) => column,
  );

  GeneratedColumn<String> get whatWasDone => $composableBuilder(
    column: $table.whatWasDone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get whatWasDoneLower => $composableBuilder(
    column: $table.whatWasDoneLower,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nextRecommendedDate => $composableBuilder(
    column: $table.nextRecommendedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get noteLower =>
      $composableBuilder(column: $table.noteLower, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HealthEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HealthEventsTable,
          HealthEvent,
          $$HealthEventsTableFilterComposer,
          $$HealthEventsTableOrderingComposer,
          $$HealthEventsTableAnnotationComposer,
          $$HealthEventsTableCreateCompanionBuilder,
          $$HealthEventsTableUpdateCompanionBuilder,
          (
            HealthEvent,
            BaseReferences<_$AppDatabase, $HealthEventsTable, HealthEvent>,
          ),
          HealthEvent,
          PrefetchHooks Function()
        > {
  $$HealthEventsTableTableManager(_$AppDatabase db, $HealthEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<HealthEventType> type = const Value.absent(),
                Value<DentalSubtype?> subtype = const Value.absent(),
                Value<String?> clinic = const Value.absent(),
                Value<String?> clinicLower = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> reasonLower = const Value.absent(),
                Value<String> whatWasDone = const Value.absent(),
                Value<String> whatWasDoneLower = const Value.absent(),
                Value<int?> priceCents = const Value.absent(),
                Value<String?> nextRecommendedDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HealthEventsCompanion(
                id: id,
                date: date,
                type: type,
                subtype: subtype,
                clinic: clinic,
                clinicLower: clinicLower,
                reason: reason,
                reasonLower: reasonLower,
                whatWasDone: whatWasDone,
                whatWasDoneLower: whatWasDoneLower,
                priceCents: priceCents,
                nextRecommendedDate: nextRecommendedDate,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                required HealthEventType type,
                Value<DentalSubtype?> subtype = const Value.absent(),
                Value<String?> clinic = const Value.absent(),
                Value<String?> clinicLower = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> reasonLower = const Value.absent(),
                required String whatWasDone,
                required String whatWasDoneLower,
                Value<int?> priceCents = const Value.absent(),
                Value<String?> nextRecommendedDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HealthEventsCompanion.insert(
                id: id,
                date: date,
                type: type,
                subtype: subtype,
                clinic: clinic,
                clinicLower: clinicLower,
                reason: reason,
                reasonLower: reasonLower,
                whatWasDone: whatWasDone,
                whatWasDoneLower: whatWasDoneLower,
                priceCents: priceCents,
                nextRecommendedDate: nextRecommendedDate,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HealthEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HealthEventsTable,
      HealthEvent,
      $$HealthEventsTableFilterComposer,
      $$HealthEventsTableOrderingComposer,
      $$HealthEventsTableAnnotationComposer,
      $$HealthEventsTableCreateCompanionBuilder,
      $$HealthEventsTableUpdateCompanionBuilder,
      (
        HealthEvent,
        BaseReferences<_$AppDatabase, $HealthEventsTable, HealthEvent>,
      ),
      HealthEvent,
      PrefetchHooks Function()
    >;
typedef $$LabTestsTableCreateCompanionBuilder =
    LabTestsCompanion Function({
      required String id,
      required String date,
      required String lab,
      required String labLower,
      required String reason,
      required String reasonLower,
      Value<String?> resultsText,
      Value<String?> resultsTextLower,
      Value<String?> note,
      Value<String?> noteLower,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LabTestsTableUpdateCompanionBuilder =
    LabTestsCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<String> lab,
      Value<String> labLower,
      Value<String> reason,
      Value<String> reasonLower,
      Value<String?> resultsText,
      Value<String?> resultsTextLower,
      Value<String?> note,
      Value<String?> noteLower,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LabTestsTableFilterComposer
    extends Composer<_$AppDatabase, $LabTestsTable> {
  $$LabTestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lab => $composableBuilder(
    column: $table.lab,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get labLower => $composableBuilder(
    column: $table.labLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonLower => $composableBuilder(
    column: $table.reasonLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultsText => $composableBuilder(
    column: $table.resultsText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultsTextLower => $composableBuilder(
    column: $table.resultsTextLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LabTestsTableOrderingComposer
    extends Composer<_$AppDatabase, $LabTestsTable> {
  $$LabTestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lab => $composableBuilder(
    column: $table.lab,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get labLower => $composableBuilder(
    column: $table.labLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonLower => $composableBuilder(
    column: $table.reasonLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultsText => $composableBuilder(
    column: $table.resultsText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultsTextLower => $composableBuilder(
    column: $table.resultsTextLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LabTestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LabTestsTable> {
  $$LabTestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get lab =>
      $composableBuilder(column: $table.lab, builder: (column) => column);

  GeneratedColumn<String> get labLower =>
      $composableBuilder(column: $table.labLower, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get reasonLower => $composableBuilder(
    column: $table.reasonLower,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resultsText => $composableBuilder(
    column: $table.resultsText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resultsTextLower => $composableBuilder(
    column: $table.resultsTextLower,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get noteLower =>
      $composableBuilder(column: $table.noteLower, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LabTestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LabTestsTable,
          LabTest,
          $$LabTestsTableFilterComposer,
          $$LabTestsTableOrderingComposer,
          $$LabTestsTableAnnotationComposer,
          $$LabTestsTableCreateCompanionBuilder,
          $$LabTestsTableUpdateCompanionBuilder,
          (LabTest, BaseReferences<_$AppDatabase, $LabTestsTable, LabTest>),
          LabTest,
          PrefetchHooks Function()
        > {
  $$LabTestsTableTableManager(_$AppDatabase db, $LabTestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LabTestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LabTestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LabTestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> lab = const Value.absent(),
                Value<String> labLower = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> reasonLower = const Value.absent(),
                Value<String?> resultsText = const Value.absent(),
                Value<String?> resultsTextLower = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LabTestsCompanion(
                id: id,
                date: date,
                lab: lab,
                labLower: labLower,
                reason: reason,
                reasonLower: reasonLower,
                resultsText: resultsText,
                resultsTextLower: resultsTextLower,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                required String lab,
                required String labLower,
                required String reason,
                required String reasonLower,
                Value<String?> resultsText = const Value.absent(),
                Value<String?> resultsTextLower = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LabTestsCompanion.insert(
                id: id,
                date: date,
                lab: lab,
                labLower: labLower,
                reason: reason,
                reasonLower: reasonLower,
                resultsText: resultsText,
                resultsTextLower: resultsTextLower,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LabTestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LabTestsTable,
      LabTest,
      $$LabTestsTableFilterComposer,
      $$LabTestsTableOrderingComposer,
      $$LabTestsTableAnnotationComposer,
      $$LabTestsTableCreateCompanionBuilder,
      $$LabTestsTableUpdateCompanionBuilder,
      (LabTest, BaseReferences<_$AppDatabase, $LabTestsTable, LabTest>),
      LabTest,
      PrefetchHooks Function()
    >;
typedef $$BloodPressureLogsTableCreateCompanionBuilder =
    BloodPressureLogsCompanion Function({
      required String id,
      required String date,
      required String time,
      required int systolic,
      required int diastolic,
      required int pulse,
      Value<String?> note,
      Value<String?> noteLower,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BloodPressureLogsTableUpdateCompanionBuilder =
    BloodPressureLogsCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<String> time,
      Value<int> systolic,
      Value<int> diastolic,
      Value<int> pulse,
      Value<String?> note,
      Value<String?> noteLower,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$BloodPressureLogsTableFilterComposer
    extends Composer<_$AppDatabase, $BloodPressureLogsTable> {
  $$BloodPressureLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get systolic => $composableBuilder(
    column: $table.systolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diastolic => $composableBuilder(
    column: $table.diastolic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pulse => $composableBuilder(
    column: $table.pulse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BloodPressureLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $BloodPressureLogsTable> {
  $$BloodPressureLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get systolic => $composableBuilder(
    column: $table.systolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diastolic => $composableBuilder(
    column: $table.diastolic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pulse => $composableBuilder(
    column: $table.pulse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BloodPressureLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BloodPressureLogsTable> {
  $$BloodPressureLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get systolic =>
      $composableBuilder(column: $table.systolic, builder: (column) => column);

  GeneratedColumn<int> get diastolic =>
      $composableBuilder(column: $table.diastolic, builder: (column) => column);

  GeneratedColumn<int> get pulse =>
      $composableBuilder(column: $table.pulse, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get noteLower =>
      $composableBuilder(column: $table.noteLower, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BloodPressureLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BloodPressureLogsTable,
          BloodPressureLog,
          $$BloodPressureLogsTableFilterComposer,
          $$BloodPressureLogsTableOrderingComposer,
          $$BloodPressureLogsTableAnnotationComposer,
          $$BloodPressureLogsTableCreateCompanionBuilder,
          $$BloodPressureLogsTableUpdateCompanionBuilder,
          (
            BloodPressureLog,
            BaseReferences<
              _$AppDatabase,
              $BloodPressureLogsTable,
              BloodPressureLog
            >,
          ),
          BloodPressureLog,
          PrefetchHooks Function()
        > {
  $$BloodPressureLogsTableTableManager(
    _$AppDatabase db,
    $BloodPressureLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BloodPressureLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BloodPressureLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BloodPressureLogsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> time = const Value.absent(),
                Value<int> systolic = const Value.absent(),
                Value<int> diastolic = const Value.absent(),
                Value<int> pulse = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BloodPressureLogsCompanion(
                id: id,
                date: date,
                time: time,
                systolic: systolic,
                diastolic: diastolic,
                pulse: pulse,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                required String time,
                required int systolic,
                required int diastolic,
                required int pulse,
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BloodPressureLogsCompanion.insert(
                id: id,
                date: date,
                time: time,
                systolic: systolic,
                diastolic: diastolic,
                pulse: pulse,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BloodPressureLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BloodPressureLogsTable,
      BloodPressureLog,
      $$BloodPressureLogsTableFilterComposer,
      $$BloodPressureLogsTableOrderingComposer,
      $$BloodPressureLogsTableAnnotationComposer,
      $$BloodPressureLogsTableCreateCompanionBuilder,
      $$BloodPressureLogsTableUpdateCompanionBuilder,
      (
        BloodPressureLog,
        BaseReferences<
          _$AppDatabase,
          $BloodPressureLogsTable,
          BloodPressureLog
        >,
      ),
      BloodPressureLog,
      PrefetchHooks Function()
    >;
typedef $$MedicationLogsTableCreateCompanionBuilder =
    MedicationLogsCompanion Function({
      required String id,
      required String date,
      required String time,
      required String name,
      required String nameLower,
      required MedType type,
      Value<String?> dose,
      required MedStatus status,
      Value<String?> reason,
      Value<String?> reasonLower,
      Value<String?> note,
      Value<String?> noteLower,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$MedicationLogsTableUpdateCompanionBuilder =
    MedicationLogsCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<String> time,
      Value<String> name,
      Value<String> nameLower,
      Value<MedType> type,
      Value<String?> dose,
      Value<MedStatus> status,
      Value<String?> reason,
      Value<String?> reasonLower,
      Value<String?> note,
      Value<String?> noteLower,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$MedicationLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationLogsTable> {
  $$MedicationLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameLower => $composableBuilder(
    column: $table.nameLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MedType, MedType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MedStatus, MedStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonLower => $composableBuilder(
    column: $table.reasonLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicationLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationLogsTable> {
  $$MedicationLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameLower => $composableBuilder(
    column: $table.nameLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonLower => $composableBuilder(
    column: $table.reasonLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicationLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationLogsTable> {
  $$MedicationLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameLower =>
      $composableBuilder(column: $table.nameLower, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MedType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MedStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get reasonLower => $composableBuilder(
    column: $table.reasonLower,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get noteLower =>
      $composableBuilder(column: $table.noteLower, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MedicationLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationLogsTable,
          MedicationLog,
          $$MedicationLogsTableFilterComposer,
          $$MedicationLogsTableOrderingComposer,
          $$MedicationLogsTableAnnotationComposer,
          $$MedicationLogsTableCreateCompanionBuilder,
          $$MedicationLogsTableUpdateCompanionBuilder,
          (
            MedicationLog,
            BaseReferences<_$AppDatabase, $MedicationLogsTable, MedicationLog>,
          ),
          MedicationLog,
          PrefetchHooks Function()
        > {
  $$MedicationLogsTableTableManager(
    _$AppDatabase db,
    $MedicationLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> time = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameLower = const Value.absent(),
                Value<MedType> type = const Value.absent(),
                Value<String?> dose = const Value.absent(),
                Value<MedStatus> status = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> reasonLower = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationLogsCompanion(
                id: id,
                date: date,
                time: time,
                name: name,
                nameLower: nameLower,
                type: type,
                dose: dose,
                status: status,
                reason: reason,
                reasonLower: reasonLower,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                required String time,
                required String name,
                required String nameLower,
                required MedType type,
                Value<String?> dose = const Value.absent(),
                required MedStatus status,
                Value<String?> reason = const Value.absent(),
                Value<String?> reasonLower = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => MedicationLogsCompanion.insert(
                id: id,
                date: date,
                time: time,
                name: name,
                nameLower: nameLower,
                type: type,
                dose: dose,
                status: status,
                reason: reason,
                reasonLower: reasonLower,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicationLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationLogsTable,
      MedicationLog,
      $$MedicationLogsTableFilterComposer,
      $$MedicationLogsTableOrderingComposer,
      $$MedicationLogsTableAnnotationComposer,
      $$MedicationLogsTableCreateCompanionBuilder,
      $$MedicationLogsTableUpdateCompanionBuilder,
      (
        MedicationLog,
        BaseReferences<_$AppDatabase, $MedicationLogsTable, MedicationLog>,
      ),
      MedicationLog,
      PrefetchHooks Function()
    >;
typedef $$DailyLogsTableCreateCompanionBuilder =
    DailyLogsCompanion Function({
      required String id,
      required String date,
      required int mood,
      required bool proud,
      required bool didUncomfortable,
      Value<String?> uncomfortableWhat,
      required bool workout,
      required bool drankAlcohol,
      Value<String?> alcoholWhat,
      Value<int?> screenTimeMin,
      Value<String?> note,
      Value<String?> noteLower,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DailyLogsTableUpdateCompanionBuilder =
    DailyLogsCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<int> mood,
      Value<bool> proud,
      Value<bool> didUncomfortable,
      Value<String?> uncomfortableWhat,
      Value<bool> workout,
      Value<bool> drankAlcohol,
      Value<String?> alcoholWhat,
      Value<int?> screenTimeMin,
      Value<String?> note,
      Value<String?> noteLower,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DailyLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get proud => $composableBuilder(
    column: $table.proud,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get didUncomfortable => $composableBuilder(
    column: $table.didUncomfortable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uncomfortableWhat => $composableBuilder(
    column: $table.uncomfortableWhat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get workout => $composableBuilder(
    column: $table.workout,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get drankAlcohol => $composableBuilder(
    column: $table.drankAlcohol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alcoholWhat => $composableBuilder(
    column: $table.alcoholWhat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get screenTimeMin => $composableBuilder(
    column: $table.screenTimeMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get proud => $composableBuilder(
    column: $table.proud,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get didUncomfortable => $composableBuilder(
    column: $table.didUncomfortable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uncomfortableWhat => $composableBuilder(
    column: $table.uncomfortableWhat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get workout => $composableBuilder(
    column: $table.workout,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get drankAlcohol => $composableBuilder(
    column: $table.drankAlcohol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alcoholWhat => $composableBuilder(
    column: $table.alcoholWhat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get screenTimeMin => $composableBuilder(
    column: $table.screenTimeMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteLower => $composableBuilder(
    column: $table.noteLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<bool> get proud =>
      $composableBuilder(column: $table.proud, builder: (column) => column);

  GeneratedColumn<bool> get didUncomfortable => $composableBuilder(
    column: $table.didUncomfortable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uncomfortableWhat => $composableBuilder(
    column: $table.uncomfortableWhat,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get workout =>
      $composableBuilder(column: $table.workout, builder: (column) => column);

  GeneratedColumn<bool> get drankAlcohol => $composableBuilder(
    column: $table.drankAlcohol,
    builder: (column) => column,
  );

  GeneratedColumn<String> get alcoholWhat => $composableBuilder(
    column: $table.alcoholWhat,
    builder: (column) => column,
  );

  GeneratedColumn<int> get screenTimeMin => $composableBuilder(
    column: $table.screenTimeMin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get noteLower =>
      $composableBuilder(column: $table.noteLower, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyLogsTable,
          DailyLog,
          $$DailyLogsTableFilterComposer,
          $$DailyLogsTableOrderingComposer,
          $$DailyLogsTableAnnotationComposer,
          $$DailyLogsTableCreateCompanionBuilder,
          $$DailyLogsTableUpdateCompanionBuilder,
          (DailyLog, BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog>),
          DailyLog,
          PrefetchHooks Function()
        > {
  $$DailyLogsTableTableManager(_$AppDatabase db, $DailyLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> mood = const Value.absent(),
                Value<bool> proud = const Value.absent(),
                Value<bool> didUncomfortable = const Value.absent(),
                Value<String?> uncomfortableWhat = const Value.absent(),
                Value<bool> workout = const Value.absent(),
                Value<bool> drankAlcohol = const Value.absent(),
                Value<String?> alcoholWhat = const Value.absent(),
                Value<int?> screenTimeMin = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyLogsCompanion(
                id: id,
                date: date,
                mood: mood,
                proud: proud,
                didUncomfortable: didUncomfortable,
                uncomfortableWhat: uncomfortableWhat,
                workout: workout,
                drankAlcohol: drankAlcohol,
                alcoholWhat: alcoholWhat,
                screenTimeMin: screenTimeMin,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                required int mood,
                required bool proud,
                required bool didUncomfortable,
                Value<String?> uncomfortableWhat = const Value.absent(),
                required bool workout,
                required bool drankAlcohol,
                Value<String?> alcoholWhat = const Value.absent(),
                Value<int?> screenTimeMin = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> noteLower = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DailyLogsCompanion.insert(
                id: id,
                date: date,
                mood: mood,
                proud: proud,
                didUncomfortable: didUncomfortable,
                uncomfortableWhat: uncomfortableWhat,
                workout: workout,
                drankAlcohol: drankAlcohol,
                alcoholWhat: alcoholWhat,
                screenTimeMin: screenTimeMin,
                note: note,
                noteLower: noteLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyLogsTable,
      DailyLog,
      $$DailyLogsTableFilterComposer,
      $$DailyLogsTableOrderingComposer,
      $$DailyLogsTableAnnotationComposer,
      $$DailyLogsTableCreateCompanionBuilder,
      $$DailyLogsTableUpdateCompanionBuilder,
      (DailyLog, BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog>),
      DailyLog,
      PrefetchHooks Function()
    >;
typedef $$StepsTableCreateCompanionBuilder =
    StepsCompanion Function({
      required String id,
      required String date,
      required int count,
      Value<String?> note,
      required StepsSource source,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$StepsTableUpdateCompanionBuilder =
    StepsCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<int> count,
      Value<String?> note,
      Value<StepsSource> source,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$StepsTableFilterComposer extends Composer<_$AppDatabase, $StepsTable> {
  $$StepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StepsSource, StepsSource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StepsTableOrderingComposer
    extends Composer<_$AppDatabase, $StepsTable> {
  $$StepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StepsTable> {
  $$StepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StepsSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StepsTable,
          StepEntry,
          $$StepsTableFilterComposer,
          $$StepsTableOrderingComposer,
          $$StepsTableAnnotationComposer,
          $$StepsTableCreateCompanionBuilder,
          $$StepsTableUpdateCompanionBuilder,
          (StepEntry, BaseReferences<_$AppDatabase, $StepsTable, StepEntry>),
          StepEntry,
          PrefetchHooks Function()
        > {
  $$StepsTableTableManager(_$AppDatabase db, $StepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<StepsSource> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StepsCompanion(
                id: id,
                date: date,
                count: count,
                note: note,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                required int count,
                Value<String?> note = const Value.absent(),
                required StepsSource source,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StepsCompanion.insert(
                id: id,
                date: date,
                count: count,
                note: note,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StepsTable,
      StepEntry,
      $$StepsTableFilterComposer,
      $$StepsTableOrderingComposer,
      $$StepsTableAnnotationComposer,
      $$StepsTableCreateCompanionBuilder,
      $$StepsTableUpdateCompanionBuilder,
      (StepEntry, BaseReferences<_$AppDatabase, $StepsTable, StepEntry>),
      StepEntry,
      PrefetchHooks Function()
    >;
typedef $$BucketItemsTableCreateCompanionBuilder =
    BucketItemsCompanion Function({
      required String id,
      required String title,
      required String titleLower,
      Value<String?> description,
      Value<String?> descriptionLower,
      Value<String?> whyWantIt,
      Value<String?> whyWantItLower,
      required BucketPriority priority,
      required BucketStatus status,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BucketItemsTableUpdateCompanionBuilder =
    BucketItemsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> titleLower,
      Value<String?> description,
      Value<String?> descriptionLower,
      Value<String?> whyWantIt,
      Value<String?> whyWantItLower,
      Value<BucketPriority> priority,
      Value<BucketStatus> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$BucketItemsTableReferences
    extends BaseReferences<_$AppDatabase, $BucketItemsTable, BucketItem> {
  $$BucketItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BucketExperiencesTable, List<BucketExperience>>
  _bucketExperiencesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.bucketExperiences,
        aliasName: $_aliasNameGenerator(
          db.bucketItems.id,
          db.bucketExperiences.bucketItemId,
        ),
      );

  $$BucketExperiencesTableProcessedTableManager get bucketExperiencesRefs {
    final manager = $$BucketExperiencesTableTableManager(
      $_db,
      $_db.bucketExperiences,
    ).filter((f) => f.bucketItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _bucketExperiencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BucketItemsTableFilterComposer
    extends Composer<_$AppDatabase, $BucketItemsTable> {
  $$BucketItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleLower => $composableBuilder(
    column: $table.titleLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionLower => $composableBuilder(
    column: $table.descriptionLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whyWantIt => $composableBuilder(
    column: $table.whyWantIt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whyWantItLower => $composableBuilder(
    column: $table.whyWantItLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BucketPriority, BucketPriority, String>
  get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<BucketStatus, BucketStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> bucketExperiencesRefs(
    Expression<bool> Function($$BucketExperiencesTableFilterComposer f) f,
  ) {
    final $$BucketExperiencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bucketExperiences,
      getReferencedColumn: (t) => t.bucketItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BucketExperiencesTableFilterComposer(
            $db: $db,
            $table: $db.bucketExperiences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BucketItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $BucketItemsTable> {
  $$BucketItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleLower => $composableBuilder(
    column: $table.titleLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionLower => $composableBuilder(
    column: $table.descriptionLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whyWantIt => $composableBuilder(
    column: $table.whyWantIt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whyWantItLower => $composableBuilder(
    column: $table.whyWantItLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BucketItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BucketItemsTable> {
  $$BucketItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get titleLower => $composableBuilder(
    column: $table.titleLower,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descriptionLower => $composableBuilder(
    column: $table.descriptionLower,
    builder: (column) => column,
  );

  GeneratedColumn<String> get whyWantIt =>
      $composableBuilder(column: $table.whyWantIt, builder: (column) => column);

  GeneratedColumn<String> get whyWantItLower => $composableBuilder(
    column: $table.whyWantItLower,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<BucketPriority, String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BucketStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> bucketExperiencesRefs<T extends Object>(
    Expression<T> Function($$BucketExperiencesTableAnnotationComposer a) f,
  ) {
    final $$BucketExperiencesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.bucketExperiences,
          getReferencedColumn: (t) => t.bucketItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BucketExperiencesTableAnnotationComposer(
                $db: $db,
                $table: $db.bucketExperiences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BucketItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BucketItemsTable,
          BucketItem,
          $$BucketItemsTableFilterComposer,
          $$BucketItemsTableOrderingComposer,
          $$BucketItemsTableAnnotationComposer,
          $$BucketItemsTableCreateCompanionBuilder,
          $$BucketItemsTableUpdateCompanionBuilder,
          (BucketItem, $$BucketItemsTableReferences),
          BucketItem,
          PrefetchHooks Function({bool bucketExperiencesRefs})
        > {
  $$BucketItemsTableTableManager(_$AppDatabase db, $BucketItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BucketItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BucketItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BucketItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> titleLower = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> descriptionLower = const Value.absent(),
                Value<String?> whyWantIt = const Value.absent(),
                Value<String?> whyWantItLower = const Value.absent(),
                Value<BucketPriority> priority = const Value.absent(),
                Value<BucketStatus> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BucketItemsCompanion(
                id: id,
                title: title,
                titleLower: titleLower,
                description: description,
                descriptionLower: descriptionLower,
                whyWantIt: whyWantIt,
                whyWantItLower: whyWantItLower,
                priority: priority,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String titleLower,
                Value<String?> description = const Value.absent(),
                Value<String?> descriptionLower = const Value.absent(),
                Value<String?> whyWantIt = const Value.absent(),
                Value<String?> whyWantItLower = const Value.absent(),
                required BucketPriority priority,
                required BucketStatus status,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BucketItemsCompanion.insert(
                id: id,
                title: title,
                titleLower: titleLower,
                description: description,
                descriptionLower: descriptionLower,
                whyWantIt: whyWantIt,
                whyWantItLower: whyWantItLower,
                priority: priority,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BucketItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bucketExperiencesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (bucketExperiencesRefs) db.bucketExperiences,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bucketExperiencesRefs)
                    await $_getPrefetchedData<
                      BucketItem,
                      $BucketItemsTable,
                      BucketExperience
                    >(
                      currentTable: table,
                      referencedTable: $$BucketItemsTableReferences
                          ._bucketExperiencesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BucketItemsTableReferences(
                            db,
                            table,
                            p0,
                          ).bucketExperiencesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.bucketItemId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BucketItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BucketItemsTable,
      BucketItem,
      $$BucketItemsTableFilterComposer,
      $$BucketItemsTableOrderingComposer,
      $$BucketItemsTableAnnotationComposer,
      $$BucketItemsTableCreateCompanionBuilder,
      $$BucketItemsTableUpdateCompanionBuilder,
      (BucketItem, $$BucketItemsTableReferences),
      BucketItem,
      PrefetchHooks Function({bool bucketExperiencesRefs})
    >;
typedef $$BucketExperiencesTableCreateCompanionBuilder =
    BucketExperiencesCompanion Function({
      required String id,
      required String bucketItemId,
      required String completedDate,
      required int feelingRating,
      required bool worthIt,
      Value<String?> reflection,
      Value<String?> reflectionLower,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BucketExperiencesTableUpdateCompanionBuilder =
    BucketExperiencesCompanion Function({
      Value<String> id,
      Value<String> bucketItemId,
      Value<String> completedDate,
      Value<int> feelingRating,
      Value<bool> worthIt,
      Value<String?> reflection,
      Value<String?> reflectionLower,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$BucketExperiencesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BucketExperiencesTable,
          BucketExperience
        > {
  $$BucketExperiencesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BucketItemsTable _bucketItemIdTable(_$AppDatabase db) =>
      db.bucketItems.createAlias(
        $_aliasNameGenerator(
          db.bucketExperiences.bucketItemId,
          db.bucketItems.id,
        ),
      );

  $$BucketItemsTableProcessedTableManager get bucketItemId {
    final $_column = $_itemColumn<String>('bucket_item_id')!;

    final manager = $$BucketItemsTableTableManager(
      $_db,
      $_db.bucketItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bucketItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BucketExperiencesTableFilterComposer
    extends Composer<_$AppDatabase, $BucketExperiencesTable> {
  $$BucketExperiencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedDate => $composableBuilder(
    column: $table.completedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get feelingRating => $composableBuilder(
    column: $table.feelingRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get worthIt => $composableBuilder(
    column: $table.worthIt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reflection => $composableBuilder(
    column: $table.reflection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reflectionLower => $composableBuilder(
    column: $table.reflectionLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BucketItemsTableFilterComposer get bucketItemId {
    final $$BucketItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bucketItemId,
      referencedTable: $db.bucketItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BucketItemsTableFilterComposer(
            $db: $db,
            $table: $db.bucketItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BucketExperiencesTableOrderingComposer
    extends Composer<_$AppDatabase, $BucketExperiencesTable> {
  $$BucketExperiencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedDate => $composableBuilder(
    column: $table.completedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get feelingRating => $composableBuilder(
    column: $table.feelingRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get worthIt => $composableBuilder(
    column: $table.worthIt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reflection => $composableBuilder(
    column: $table.reflection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reflectionLower => $composableBuilder(
    column: $table.reflectionLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BucketItemsTableOrderingComposer get bucketItemId {
    final $$BucketItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bucketItemId,
      referencedTable: $db.bucketItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BucketItemsTableOrderingComposer(
            $db: $db,
            $table: $db.bucketItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BucketExperiencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BucketExperiencesTable> {
  $$BucketExperiencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get completedDate => $composableBuilder(
    column: $table.completedDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get feelingRating => $composableBuilder(
    column: $table.feelingRating,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get worthIt =>
      $composableBuilder(column: $table.worthIt, builder: (column) => column);

  GeneratedColumn<String> get reflection => $composableBuilder(
    column: $table.reflection,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reflectionLower => $composableBuilder(
    column: $table.reflectionLower,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BucketItemsTableAnnotationComposer get bucketItemId {
    final $$BucketItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bucketItemId,
      referencedTable: $db.bucketItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BucketItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.bucketItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BucketExperiencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BucketExperiencesTable,
          BucketExperience,
          $$BucketExperiencesTableFilterComposer,
          $$BucketExperiencesTableOrderingComposer,
          $$BucketExperiencesTableAnnotationComposer,
          $$BucketExperiencesTableCreateCompanionBuilder,
          $$BucketExperiencesTableUpdateCompanionBuilder,
          (BucketExperience, $$BucketExperiencesTableReferences),
          BucketExperience,
          PrefetchHooks Function({bool bucketItemId})
        > {
  $$BucketExperiencesTableTableManager(
    _$AppDatabase db,
    $BucketExperiencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BucketExperiencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BucketExperiencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BucketExperiencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bucketItemId = const Value.absent(),
                Value<String> completedDate = const Value.absent(),
                Value<int> feelingRating = const Value.absent(),
                Value<bool> worthIt = const Value.absent(),
                Value<String?> reflection = const Value.absent(),
                Value<String?> reflectionLower = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BucketExperiencesCompanion(
                id: id,
                bucketItemId: bucketItemId,
                completedDate: completedDate,
                feelingRating: feelingRating,
                worthIt: worthIt,
                reflection: reflection,
                reflectionLower: reflectionLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bucketItemId,
                required String completedDate,
                required int feelingRating,
                required bool worthIt,
                Value<String?> reflection = const Value.absent(),
                Value<String?> reflectionLower = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BucketExperiencesCompanion.insert(
                id: id,
                bucketItemId: bucketItemId,
                completedDate: completedDate,
                feelingRating: feelingRating,
                worthIt: worthIt,
                reflection: reflection,
                reflectionLower: reflectionLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BucketExperiencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bucketItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bucketItemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bucketItemId,
                                referencedTable:
                                    $$BucketExperiencesTableReferences
                                        ._bucketItemIdTable(db),
                                referencedColumn:
                                    $$BucketExperiencesTableReferences
                                        ._bucketItemIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BucketExperiencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BucketExperiencesTable,
      BucketExperience,
      $$BucketExperiencesTableFilterComposer,
      $$BucketExperiencesTableOrderingComposer,
      $$BucketExperiencesTableAnnotationComposer,
      $$BucketExperiencesTableCreateCompanionBuilder,
      $$BucketExperiencesTableUpdateCompanionBuilder,
      (BucketExperience, $$BucketExperiencesTableReferences),
      BucketExperience,
      PrefetchHooks Function({bool bucketItemId})
    >;
typedef $$TripsTableCreateCompanionBuilder =
    TripsCompanion Function({
      required String id,
      required String title,
      required String titleLower,
      required String destination,
      required String destinationLower,
      required String fromDate,
      required String toDate,
      required int overall,
      Value<int?> fun,
      Value<int?> food,
      Value<int?> sights,
      Value<int?> value,
      Value<bool?> wouldRepeat,
      Value<String?> comment,
      Value<String?> commentLower,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TripsTableUpdateCompanionBuilder =
    TripsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> titleLower,
      Value<String> destination,
      Value<String> destinationLower,
      Value<String> fromDate,
      Value<String> toDate,
      Value<int> overall,
      Value<int?> fun,
      Value<int?> food,
      Value<int?> sights,
      Value<int?> value,
      Value<bool?> wouldRepeat,
      Value<String?> comment,
      Value<String?> commentLower,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TripsTableFilterComposer extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleLower => $composableBuilder(
    column: $table.titleLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinationLower => $composableBuilder(
    column: $table.destinationLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromDate => $composableBuilder(
    column: $table.fromDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toDate => $composableBuilder(
    column: $table.toDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get overall => $composableBuilder(
    column: $table.overall,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fun => $composableBuilder(
    column: $table.fun,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get food => $composableBuilder(
    column: $table.food,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sights => $composableBuilder(
    column: $table.sights,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wouldRepeat => $composableBuilder(
    column: $table.wouldRepeat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get commentLower => $composableBuilder(
    column: $table.commentLower,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleLower => $composableBuilder(
    column: $table.titleLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinationLower => $composableBuilder(
    column: $table.destinationLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromDate => $composableBuilder(
    column: $table.fromDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toDate => $composableBuilder(
    column: $table.toDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get overall => $composableBuilder(
    column: $table.overall,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fun => $composableBuilder(
    column: $table.fun,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get food => $composableBuilder(
    column: $table.food,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sights => $composableBuilder(
    column: $table.sights,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wouldRepeat => $composableBuilder(
    column: $table.wouldRepeat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get commentLower => $composableBuilder(
    column: $table.commentLower,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get titleLower => $composableBuilder(
    column: $table.titleLower,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destinationLower => $composableBuilder(
    column: $table.destinationLower,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fromDate =>
      $composableBuilder(column: $table.fromDate, builder: (column) => column);

  GeneratedColumn<String> get toDate =>
      $composableBuilder(column: $table.toDate, builder: (column) => column);

  GeneratedColumn<int> get overall =>
      $composableBuilder(column: $table.overall, builder: (column) => column);

  GeneratedColumn<int> get fun =>
      $composableBuilder(column: $table.fun, builder: (column) => column);

  GeneratedColumn<int> get food =>
      $composableBuilder(column: $table.food, builder: (column) => column);

  GeneratedColumn<int> get sights =>
      $composableBuilder(column: $table.sights, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<bool> get wouldRepeat => $composableBuilder(
    column: $table.wouldRepeat,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<String> get commentLower => $composableBuilder(
    column: $table.commentLower,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TripsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripsTable,
          Trip,
          $$TripsTableFilterComposer,
          $$TripsTableOrderingComposer,
          $$TripsTableAnnotationComposer,
          $$TripsTableCreateCompanionBuilder,
          $$TripsTableUpdateCompanionBuilder,
          (Trip, BaseReferences<_$AppDatabase, $TripsTable, Trip>),
          Trip,
          PrefetchHooks Function()
        > {
  $$TripsTableTableManager(_$AppDatabase db, $TripsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> titleLower = const Value.absent(),
                Value<String> destination = const Value.absent(),
                Value<String> destinationLower = const Value.absent(),
                Value<String> fromDate = const Value.absent(),
                Value<String> toDate = const Value.absent(),
                Value<int> overall = const Value.absent(),
                Value<int?> fun = const Value.absent(),
                Value<int?> food = const Value.absent(),
                Value<int?> sights = const Value.absent(),
                Value<int?> value = const Value.absent(),
                Value<bool?> wouldRepeat = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<String?> commentLower = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripsCompanion(
                id: id,
                title: title,
                titleLower: titleLower,
                destination: destination,
                destinationLower: destinationLower,
                fromDate: fromDate,
                toDate: toDate,
                overall: overall,
                fun: fun,
                food: food,
                sights: sights,
                value: value,
                wouldRepeat: wouldRepeat,
                comment: comment,
                commentLower: commentLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String titleLower,
                required String destination,
                required String destinationLower,
                required String fromDate,
                required String toDate,
                required int overall,
                Value<int?> fun = const Value.absent(),
                Value<int?> food = const Value.absent(),
                Value<int?> sights = const Value.absent(),
                Value<int?> value = const Value.absent(),
                Value<bool?> wouldRepeat = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<String?> commentLower = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TripsCompanion.insert(
                id: id,
                title: title,
                titleLower: titleLower,
                destination: destination,
                destinationLower: destinationLower,
                fromDate: fromDate,
                toDate: toDate,
                overall: overall,
                fun: fun,
                food: food,
                sights: sights,
                value: value,
                wouldRepeat: wouldRepeat,
                comment: comment,
                commentLower: commentLower,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TripsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripsTable,
      Trip,
      $$TripsTableFilterComposer,
      $$TripsTableOrderingComposer,
      $$TripsTableAnnotationComposer,
      $$TripsTableCreateCompanionBuilder,
      $$TripsTableUpdateCompanionBuilder,
      (Trip, BaseReferences<_$AppDatabase, $TripsTable, Trip>),
      Trip,
      PrefetchHooks Function()
    >;
typedef $$AttachmentsTableCreateCompanionBuilder =
    AttachmentsCompanion Function({
      required String id,
      required AttachmentEntity entityType,
      required String entityId,
      required AttachmentRole role,
      required String filePath,
      required String thumbPath,
      required String fileType,
      Value<String?> originalFileName,
      required int fileSize,
      Value<int?> width,
      Value<int?> height,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$AttachmentsTableUpdateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<String> id,
      Value<AttachmentEntity> entityType,
      Value<String> entityId,
      Value<AttachmentRole> role,
      Value<String> filePath,
      Value<String> thumbPath,
      Value<String> fileType,
      Value<String?> originalFileName,
      Value<int> fileSize,
      Value<int?> width,
      Value<int?> height,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$AttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AttachmentEntity, AttachmentEntity, String>
  get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AttachmentRole, AttachmentRole, String>
  get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbPath => $composableBuilder(
    column: $table.thumbPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalFileName => $composableBuilder(
    column: $table.originalFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbPath => $composableBuilder(
    column: $table.thumbPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalFileName => $composableBuilder(
    column: $table.originalFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AttachmentEntity, String> get entityType =>
      $composableBuilder(
        column: $table.entityType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AttachmentRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get thumbPath =>
      $composableBuilder(column: $table.thumbPath, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<String> get originalFileName => $composableBuilder(
    column: $table.originalFileName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttachmentsTable,
          Attachment,
          $$AttachmentsTableFilterComposer,
          $$AttachmentsTableOrderingComposer,
          $$AttachmentsTableAnnotationComposer,
          $$AttachmentsTableCreateCompanionBuilder,
          $$AttachmentsTableUpdateCompanionBuilder,
          (
            Attachment,
            BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>,
          ),
          Attachment,
          PrefetchHooks Function()
        > {
  $$AttachmentsTableTableManager(_$AppDatabase db, $AttachmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<AttachmentEntity> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<AttachmentRole> role = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> thumbPath = const Value.absent(),
                Value<String> fileType = const Value.absent(),
                Value<String?> originalFileName = const Value.absent(),
                Value<int> fileSize = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                role: role,
                filePath: filePath,
                thumbPath: thumbPath,
                fileType: fileType,
                originalFileName: originalFileName,
                fileSize: fileSize,
                width: width,
                height: height,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required AttachmentEntity entityType,
                required String entityId,
                required AttachmentRole role,
                required String filePath,
                required String thumbPath,
                required String fileType,
                Value<String?> originalFileName = const Value.absent(),
                required int fileSize,
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                role: role,
                filePath: filePath,
                thumbPath: thumbPath,
                fileType: fileType,
                originalFileName: originalFileName,
                fileSize: fileSize,
                width: width,
                height: height,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttachmentsTable,
      Attachment,
      $$AttachmentsTableFilterComposer,
      $$AttachmentsTableOrderingComposer,
      $$AttachmentsTableAnnotationComposer,
      $$AttachmentsTableCreateCompanionBuilder,
      $$AttachmentsTableUpdateCompanionBuilder,
      (
        Attachment,
        BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>,
      ),
      Attachment,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db, _db.activities);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$IncomeTableTableManager get income =>
      $$IncomeTableTableManager(_db, _db.income);
  $$HealthEventsTableTableManager get healthEvents =>
      $$HealthEventsTableTableManager(_db, _db.healthEvents);
  $$LabTestsTableTableManager get labTests =>
      $$LabTestsTableTableManager(_db, _db.labTests);
  $$BloodPressureLogsTableTableManager get bloodPressureLogs =>
      $$BloodPressureLogsTableTableManager(_db, _db.bloodPressureLogs);
  $$MedicationLogsTableTableManager get medicationLogs =>
      $$MedicationLogsTableTableManager(_db, _db.medicationLogs);
  $$DailyLogsTableTableManager get dailyLogs =>
      $$DailyLogsTableTableManager(_db, _db.dailyLogs);
  $$StepsTableTableManager get steps =>
      $$StepsTableTableManager(_db, _db.steps);
  $$BucketItemsTableTableManager get bucketItems =>
      $$BucketItemsTableTableManager(_db, _db.bucketItems);
  $$BucketExperiencesTableTableManager get bucketExperiences =>
      $$BucketExperiencesTableTableManager(_db, _db.bucketExperiences);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db, _db.attachments);
}
