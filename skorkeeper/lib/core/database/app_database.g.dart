// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GameSessionsTable extends GameSessions
    with TableInfo<$GameSessionsTable, GameSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _gameTypeMeta = const VerificationMeta(
    'gameType',
  );
  @override
  late final GeneratedColumn<String> gameType = GeneratedColumn<String>(
    'game_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionNameMeta = const VerificationMeta(
    'sessionName',
  );
  @override
  late final GeneratedColumn<String> sessionName = GeneratedColumn<String>(
    'session_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<int> endedAt = GeneratedColumn<int>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _participantsJsonMeta = const VerificationMeta(
    'participantsJson',
  );
  @override
  late final GeneratedColumn<String> participantsJson = GeneratedColumn<String>(
    'participants_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moduleStateJsonMeta = const VerificationMeta(
    'moduleStateJson',
  );
  @override
  late final GeneratedColumn<String> moduleStateJson = GeneratedColumn<String>(
    'module_state_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _winnerDisplayNameMeta = const VerificationMeta(
    'winnerDisplayName',
  );
  @override
  late final GeneratedColumn<String> winnerDisplayName =
      GeneratedColumn<String>(
        'winner_display_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameType,
    sessionName,
    status,
    startedAt,
    endedAt,
    participantsJson,
    moduleStateJson,
    winnerDisplayName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_type')) {
      context.handle(
        _gameTypeMeta,
        gameType.isAcceptableOrUnknown(data['game_type']!, _gameTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_gameTypeMeta);
    }
    if (data.containsKey('session_name')) {
      context.handle(
        _sessionNameMeta,
        sessionName.isAcceptableOrUnknown(
          data['session_name']!,
          _sessionNameMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('participants_json')) {
      context.handle(
        _participantsJsonMeta,
        participantsJson.isAcceptableOrUnknown(
          data['participants_json']!,
          _participantsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_participantsJsonMeta);
    }
    if (data.containsKey('module_state_json')) {
      context.handle(
        _moduleStateJsonMeta,
        moduleStateJson.isAcceptableOrUnknown(
          data['module_state_json']!,
          _moduleStateJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_moduleStateJsonMeta);
    }
    if (data.containsKey('winner_display_name')) {
      context.handle(
        _winnerDisplayNameMeta,
        winnerDisplayName.isAcceptableOrUnknown(
          data['winner_display_name']!,
          _winnerDisplayNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gameType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_type'],
      )!,
      sessionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_name'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at'],
      ),
      participantsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}participants_json'],
      )!,
      moduleStateJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_state_json'],
      )!,
      winnerDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}winner_display_name'],
      ),
    );
  }

  @override
  $GameSessionsTable createAlias(String alias) {
    return $GameSessionsTable(attachedDatabase, alias);
  }
}

class GameSession extends DataClass implements Insertable<GameSession> {
  final int id;
  final String gameType;
  final String? sessionName;
  final int status;
  final int startedAt;
  final int? endedAt;
  final String participantsJson;
  final String moduleStateJson;
  final String? winnerDisplayName;
  const GameSession({
    required this.id,
    required this.gameType,
    this.sessionName,
    required this.status,
    required this.startedAt,
    this.endedAt,
    required this.participantsJson,
    required this.moduleStateJson,
    this.winnerDisplayName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_type'] = Variable<String>(gameType);
    if (!nullToAbsent || sessionName != null) {
      map['session_name'] = Variable<String>(sessionName);
    }
    map['status'] = Variable<int>(status);
    map['started_at'] = Variable<int>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<int>(endedAt);
    }
    map['participants_json'] = Variable<String>(participantsJson);
    map['module_state_json'] = Variable<String>(moduleStateJson);
    if (!nullToAbsent || winnerDisplayName != null) {
      map['winner_display_name'] = Variable<String>(winnerDisplayName);
    }
    return map;
  }

  GameSessionsCompanion toCompanion(bool nullToAbsent) {
    return GameSessionsCompanion(
      id: Value(id),
      gameType: Value(gameType),
      sessionName: sessionName == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionName),
      status: Value(status),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      participantsJson: Value(participantsJson),
      moduleStateJson: Value(moduleStateJson),
      winnerDisplayName: winnerDisplayName == null && nullToAbsent
          ? const Value.absent()
          : Value(winnerDisplayName),
    );
  }

  factory GameSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameSession(
      id: serializer.fromJson<int>(json['id']),
      gameType: serializer.fromJson<String>(json['gameType']),
      sessionName: serializer.fromJson<String?>(json['sessionName']),
      status: serializer.fromJson<int>(json['status']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      endedAt: serializer.fromJson<int?>(json['endedAt']),
      participantsJson: serializer.fromJson<String>(json['participantsJson']),
      moduleStateJson: serializer.fromJson<String>(json['moduleStateJson']),
      winnerDisplayName: serializer.fromJson<String?>(
        json['winnerDisplayName'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameType': serializer.toJson<String>(gameType),
      'sessionName': serializer.toJson<String?>(sessionName),
      'status': serializer.toJson<int>(status),
      'startedAt': serializer.toJson<int>(startedAt),
      'endedAt': serializer.toJson<int?>(endedAt),
      'participantsJson': serializer.toJson<String>(participantsJson),
      'moduleStateJson': serializer.toJson<String>(moduleStateJson),
      'winnerDisplayName': serializer.toJson<String?>(winnerDisplayName),
    };
  }

  GameSession copyWith({
    int? id,
    String? gameType,
    Value<String?> sessionName = const Value.absent(),
    int? status,
    int? startedAt,
    Value<int?> endedAt = const Value.absent(),
    String? participantsJson,
    String? moduleStateJson,
    Value<String?> winnerDisplayName = const Value.absent(),
  }) => GameSession(
    id: id ?? this.id,
    gameType: gameType ?? this.gameType,
    sessionName: sessionName.present ? sessionName.value : this.sessionName,
    status: status ?? this.status,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    participantsJson: participantsJson ?? this.participantsJson,
    moduleStateJson: moduleStateJson ?? this.moduleStateJson,
    winnerDisplayName: winnerDisplayName.present
        ? winnerDisplayName.value
        : this.winnerDisplayName,
  );
  GameSession copyWithCompanion(GameSessionsCompanion data) {
    return GameSession(
      id: data.id.present ? data.id.value : this.id,
      gameType: data.gameType.present ? data.gameType.value : this.gameType,
      sessionName: data.sessionName.present
          ? data.sessionName.value
          : this.sessionName,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      participantsJson: data.participantsJson.present
          ? data.participantsJson.value
          : this.participantsJson,
      moduleStateJson: data.moduleStateJson.present
          ? data.moduleStateJson.value
          : this.moduleStateJson,
      winnerDisplayName: data.winnerDisplayName.present
          ? data.winnerDisplayName.value
          : this.winnerDisplayName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameSession(')
          ..write('id: $id, ')
          ..write('gameType: $gameType, ')
          ..write('sessionName: $sessionName, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('participantsJson: $participantsJson, ')
          ..write('moduleStateJson: $moduleStateJson, ')
          ..write('winnerDisplayName: $winnerDisplayName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gameType,
    sessionName,
    status,
    startedAt,
    endedAt,
    participantsJson,
    moduleStateJson,
    winnerDisplayName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameSession &&
          other.id == this.id &&
          other.gameType == this.gameType &&
          other.sessionName == this.sessionName &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.participantsJson == this.participantsJson &&
          other.moduleStateJson == this.moduleStateJson &&
          other.winnerDisplayName == this.winnerDisplayName);
}

class GameSessionsCompanion extends UpdateCompanion<GameSession> {
  final Value<int> id;
  final Value<String> gameType;
  final Value<String?> sessionName;
  final Value<int> status;
  final Value<int> startedAt;
  final Value<int?> endedAt;
  final Value<String> participantsJson;
  final Value<String> moduleStateJson;
  final Value<String?> winnerDisplayName;
  const GameSessionsCompanion({
    this.id = const Value.absent(),
    this.gameType = const Value.absent(),
    this.sessionName = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.participantsJson = const Value.absent(),
    this.moduleStateJson = const Value.absent(),
    this.winnerDisplayName = const Value.absent(),
  });
  GameSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String gameType,
    this.sessionName = const Value.absent(),
    this.status = const Value.absent(),
    required int startedAt,
    this.endedAt = const Value.absent(),
    required String participantsJson,
    required String moduleStateJson,
    this.winnerDisplayName = const Value.absent(),
  }) : gameType = Value(gameType),
       startedAt = Value(startedAt),
       participantsJson = Value(participantsJson),
       moduleStateJson = Value(moduleStateJson);
  static Insertable<GameSession> custom({
    Expression<int>? id,
    Expression<String>? gameType,
    Expression<String>? sessionName,
    Expression<int>? status,
    Expression<int>? startedAt,
    Expression<int>? endedAt,
    Expression<String>? participantsJson,
    Expression<String>? moduleStateJson,
    Expression<String>? winnerDisplayName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameType != null) 'game_type': gameType,
      if (sessionName != null) 'session_name': sessionName,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (participantsJson != null) 'participants_json': participantsJson,
      if (moduleStateJson != null) 'module_state_json': moduleStateJson,
      if (winnerDisplayName != null) 'winner_display_name': winnerDisplayName,
    });
  }

  GameSessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? gameType,
    Value<String?>? sessionName,
    Value<int>? status,
    Value<int>? startedAt,
    Value<int?>? endedAt,
    Value<String>? participantsJson,
    Value<String>? moduleStateJson,
    Value<String?>? winnerDisplayName,
  }) {
    return GameSessionsCompanion(
      id: id ?? this.id,
      gameType: gameType ?? this.gameType,
      sessionName: sessionName ?? this.sessionName,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      participantsJson: participantsJson ?? this.participantsJson,
      moduleStateJson: moduleStateJson ?? this.moduleStateJson,
      winnerDisplayName: winnerDisplayName ?? this.winnerDisplayName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameType.present) {
      map['game_type'] = Variable<String>(gameType.value);
    }
    if (sessionName.present) {
      map['session_name'] = Variable<String>(sessionName.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<int>(endedAt.value);
    }
    if (participantsJson.present) {
      map['participants_json'] = Variable<String>(participantsJson.value);
    }
    if (moduleStateJson.present) {
      map['module_state_json'] = Variable<String>(moduleStateJson.value);
    }
    if (winnerDisplayName.present) {
      map['winner_display_name'] = Variable<String>(winnerDisplayName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameSessionsCompanion(')
          ..write('id: $id, ')
          ..write('gameType: $gameType, ')
          ..write('sessionName: $sessionName, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('participantsJson: $participantsJson, ')
          ..write('moduleStateJson: $moduleStateJson, ')
          ..write('winnerDisplayName: $winnerDisplayName')
          ..write(')'))
        .toString();
  }
}

class $ScoreEntriesTable extends ScoreEntries
    with TableInfo<$ScoreEntriesTable, ScoreEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScoreEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES game_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<String> playerId = GeneratedColumn<String>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roundNumberMeta = const VerificationMeta(
    'roundNumber',
  );
  @override
  late final GeneratedColumn<int> roundNumber = GeneratedColumn<int>(
    'round_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<int> recordedAt = GeneratedColumn<int>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    playerId,
    roundNumber,
    value,
    notes,
    recordedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'score_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScoreEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('round_number')) {
      context.handle(
        _roundNumberMeta,
        roundNumber.isAcceptableOrUnknown(
          data['round_number']!,
          _roundNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_roundNumberMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScoreEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScoreEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_id'],
      )!,
      roundNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}round_number'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $ScoreEntriesTable createAlias(String alias) {
    return $ScoreEntriesTable(attachedDatabase, alias);
  }
}

class ScoreEntry extends DataClass implements Insertable<ScoreEntry> {
  final int id;
  final int sessionId;
  final String playerId;
  final int roundNumber;
  final int value;
  final String? notes;
  final int recordedAt;
  const ScoreEntry({
    required this.id,
    required this.sessionId,
    required this.playerId,
    required this.roundNumber,
    required this.value,
    this.notes,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['player_id'] = Variable<String>(playerId);
    map['round_number'] = Variable<int>(roundNumber);
    map['value'] = Variable<int>(value);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['recorded_at'] = Variable<int>(recordedAt);
    return map;
  }

  ScoreEntriesCompanion toCompanion(bool nullToAbsent) {
    return ScoreEntriesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      playerId: Value(playerId),
      roundNumber: Value(roundNumber),
      value: Value(value),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      recordedAt: Value(recordedAt),
    );
  }

  factory ScoreEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScoreEntry(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      playerId: serializer.fromJson<String>(json['playerId']),
      roundNumber: serializer.fromJson<int>(json['roundNumber']),
      value: serializer.fromJson<int>(json['value']),
      notes: serializer.fromJson<String?>(json['notes']),
      recordedAt: serializer.fromJson<int>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'playerId': serializer.toJson<String>(playerId),
      'roundNumber': serializer.toJson<int>(roundNumber),
      'value': serializer.toJson<int>(value),
      'notes': serializer.toJson<String?>(notes),
      'recordedAt': serializer.toJson<int>(recordedAt),
    };
  }

  ScoreEntry copyWith({
    int? id,
    int? sessionId,
    String? playerId,
    int? roundNumber,
    int? value,
    Value<String?> notes = const Value.absent(),
    int? recordedAt,
  }) => ScoreEntry(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    playerId: playerId ?? this.playerId,
    roundNumber: roundNumber ?? this.roundNumber,
    value: value ?? this.value,
    notes: notes.present ? notes.value : this.notes,
    recordedAt: recordedAt ?? this.recordedAt,
  );
  ScoreEntry copyWithCompanion(ScoreEntriesCompanion data) {
    return ScoreEntry(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      roundNumber: data.roundNumber.present
          ? data.roundNumber.value
          : this.roundNumber,
      value: data.value.present ? data.value.value : this.value,
      notes: data.notes.present ? data.notes.value : this.notes,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScoreEntry(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('playerId: $playerId, ')
          ..write('roundNumber: $roundNumber, ')
          ..write('value: $value, ')
          ..write('notes: $notes, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    playerId,
    roundNumber,
    value,
    notes,
    recordedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScoreEntry &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.playerId == this.playerId &&
          other.roundNumber == this.roundNumber &&
          other.value == this.value &&
          other.notes == this.notes &&
          other.recordedAt == this.recordedAt);
}

class ScoreEntriesCompanion extends UpdateCompanion<ScoreEntry> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> playerId;
  final Value<int> roundNumber;
  final Value<int> value;
  final Value<String?> notes;
  final Value<int> recordedAt;
  const ScoreEntriesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.roundNumber = const Value.absent(),
    this.value = const Value.absent(),
    this.notes = const Value.absent(),
    this.recordedAt = const Value.absent(),
  });
  ScoreEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String playerId,
    required int roundNumber,
    required int value,
    this.notes = const Value.absent(),
    required int recordedAt,
  }) : sessionId = Value(sessionId),
       playerId = Value(playerId),
       roundNumber = Value(roundNumber),
       value = Value(value),
       recordedAt = Value(recordedAt);
  static Insertable<ScoreEntry> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? playerId,
    Expression<int>? roundNumber,
    Expression<int>? value,
    Expression<String>? notes,
    Expression<int>? recordedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (playerId != null) 'player_id': playerId,
      if (roundNumber != null) 'round_number': roundNumber,
      if (value != null) 'value': value,
      if (notes != null) 'notes': notes,
      if (recordedAt != null) 'recorded_at': recordedAt,
    });
  }

  ScoreEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<String>? playerId,
    Value<int>? roundNumber,
    Value<int>? value,
    Value<String?>? notes,
    Value<int>? recordedAt,
  }) {
    return ScoreEntriesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      playerId: playerId ?? this.playerId,
      roundNumber: roundNumber ?? this.roundNumber,
      value: value ?? this.value,
      notes: notes ?? this.notes,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<String>(playerId.value);
    }
    if (roundNumber.present) {
      map['round_number'] = Variable<int>(roundNumber.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScoreEntriesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('playerId: $playerId, ')
          ..write('roundNumber: $roundNumber, ')
          ..write('value: $value, ')
          ..write('notes: $notes, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }
}

class $HistoryRecordsTable extends HistoryRecords
    with TableInfo<$HistoryRecordsTable, HistoryRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES game_sessions (id)',
    ),
  );
  static const VerificationMeta _gameTypeMeta = const VerificationMeta(
    'gameType',
  );
  @override
  late final GeneratedColumn<String> gameType = GeneratedColumn<String>(
    'game_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionNameMeta = const VerificationMeta(
    'sessionName',
  );
  @override
  late final GeneratedColumn<String> sessionName = GeneratedColumn<String>(
    'session_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _playerNamesMeta = const VerificationMeta(
    'playerNames',
  );
  @override
  late final GeneratedColumn<String> playerNames = GeneratedColumn<String>(
    'player_names',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _winnerDisplayNameMeta = const VerificationMeta(
    'winnerDisplayName',
  );
  @override
  late final GeneratedColumn<String> winnerDisplayName =
      GeneratedColumn<String>(
        'winner_display_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _finalScoresJsonMeta = const VerificationMeta(
    'finalScoresJson',
  );
  @override
  late final GeneratedColumn<String> finalScoresJson = GeneratedColumn<String>(
    'final_scores_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playedAtMeta = const VerificationMeta(
    'playedAt',
  );
  @override
  late final GeneratedColumn<int> playedAt = GeneratedColumn<int>(
    'played_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    gameType,
    sessionName,
    playerNames,
    winnerDisplayName,
    finalScoresJson,
    playedAt,
    durationSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistoryRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('game_type')) {
      context.handle(
        _gameTypeMeta,
        gameType.isAcceptableOrUnknown(data['game_type']!, _gameTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_gameTypeMeta);
    }
    if (data.containsKey('session_name')) {
      context.handle(
        _sessionNameMeta,
        sessionName.isAcceptableOrUnknown(
          data['session_name']!,
          _sessionNameMeta,
        ),
      );
    }
    if (data.containsKey('player_names')) {
      context.handle(
        _playerNamesMeta,
        playerNames.isAcceptableOrUnknown(
          data['player_names']!,
          _playerNamesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_playerNamesMeta);
    }
    if (data.containsKey('winner_display_name')) {
      context.handle(
        _winnerDisplayNameMeta,
        winnerDisplayName.isAcceptableOrUnknown(
          data['winner_display_name']!,
          _winnerDisplayNameMeta,
        ),
      );
    }
    if (data.containsKey('final_scores_json')) {
      context.handle(
        _finalScoresJsonMeta,
        finalScoresJson.isAcceptableOrUnknown(
          data['final_scores_json']!,
          _finalScoresJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_finalScoresJsonMeta);
    }
    if (data.containsKey('played_at')) {
      context.handle(
        _playedAtMeta,
        playedAt.isAcceptableOrUnknown(data['played_at']!, _playedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_playedAtMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoryRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoryRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      gameType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_type'],
      )!,
      sessionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_name'],
      ),
      playerNames: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_names'],
      )!,
      winnerDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}winner_display_name'],
      ),
      finalScoresJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}final_scores_json'],
      )!,
      playedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}played_at'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
    );
  }

  @override
  $HistoryRecordsTable createAlias(String alias) {
    return $HistoryRecordsTable(attachedDatabase, alias);
  }
}

class HistoryRecord extends DataClass implements Insertable<HistoryRecord> {
  final int id;
  final int sessionId;
  final String gameType;
  final String? sessionName;
  final String playerNames;
  final String? winnerDisplayName;
  final String finalScoresJson;
  final int playedAt;
  final int? durationSeconds;
  const HistoryRecord({
    required this.id,
    required this.sessionId,
    required this.gameType,
    this.sessionName,
    required this.playerNames,
    this.winnerDisplayName,
    required this.finalScoresJson,
    required this.playedAt,
    this.durationSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['game_type'] = Variable<String>(gameType);
    if (!nullToAbsent || sessionName != null) {
      map['session_name'] = Variable<String>(sessionName);
    }
    map['player_names'] = Variable<String>(playerNames);
    if (!nullToAbsent || winnerDisplayName != null) {
      map['winner_display_name'] = Variable<String>(winnerDisplayName);
    }
    map['final_scores_json'] = Variable<String>(finalScoresJson);
    map['played_at'] = Variable<int>(playedAt);
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    return map;
  }

  HistoryRecordsCompanion toCompanion(bool nullToAbsent) {
    return HistoryRecordsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      gameType: Value(gameType),
      sessionName: sessionName == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionName),
      playerNames: Value(playerNames),
      winnerDisplayName: winnerDisplayName == null && nullToAbsent
          ? const Value.absent()
          : Value(winnerDisplayName),
      finalScoresJson: Value(finalScoresJson),
      playedAt: Value(playedAt),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
    );
  }

  factory HistoryRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoryRecord(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      gameType: serializer.fromJson<String>(json['gameType']),
      sessionName: serializer.fromJson<String?>(json['sessionName']),
      playerNames: serializer.fromJson<String>(json['playerNames']),
      winnerDisplayName: serializer.fromJson<String?>(
        json['winnerDisplayName'],
      ),
      finalScoresJson: serializer.fromJson<String>(json['finalScoresJson']),
      playedAt: serializer.fromJson<int>(json['playedAt']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'gameType': serializer.toJson<String>(gameType),
      'sessionName': serializer.toJson<String?>(sessionName),
      'playerNames': serializer.toJson<String>(playerNames),
      'winnerDisplayName': serializer.toJson<String?>(winnerDisplayName),
      'finalScoresJson': serializer.toJson<String>(finalScoresJson),
      'playedAt': serializer.toJson<int>(playedAt),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
    };
  }

  HistoryRecord copyWith({
    int? id,
    int? sessionId,
    String? gameType,
    Value<String?> sessionName = const Value.absent(),
    String? playerNames,
    Value<String?> winnerDisplayName = const Value.absent(),
    String? finalScoresJson,
    int? playedAt,
    Value<int?> durationSeconds = const Value.absent(),
  }) => HistoryRecord(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    gameType: gameType ?? this.gameType,
    sessionName: sessionName.present ? sessionName.value : this.sessionName,
    playerNames: playerNames ?? this.playerNames,
    winnerDisplayName: winnerDisplayName.present
        ? winnerDisplayName.value
        : this.winnerDisplayName,
    finalScoresJson: finalScoresJson ?? this.finalScoresJson,
    playedAt: playedAt ?? this.playedAt,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
  );
  HistoryRecord copyWithCompanion(HistoryRecordsCompanion data) {
    return HistoryRecord(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      gameType: data.gameType.present ? data.gameType.value : this.gameType,
      sessionName: data.sessionName.present
          ? data.sessionName.value
          : this.sessionName,
      playerNames: data.playerNames.present
          ? data.playerNames.value
          : this.playerNames,
      winnerDisplayName: data.winnerDisplayName.present
          ? data.winnerDisplayName.value
          : this.winnerDisplayName,
      finalScoresJson: data.finalScoresJson.present
          ? data.finalScoresJson.value
          : this.finalScoresJson,
      playedAt: data.playedAt.present ? data.playedAt.value : this.playedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoryRecord(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('gameType: $gameType, ')
          ..write('sessionName: $sessionName, ')
          ..write('playerNames: $playerNames, ')
          ..write('winnerDisplayName: $winnerDisplayName, ')
          ..write('finalScoresJson: $finalScoresJson, ')
          ..write('playedAt: $playedAt, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    gameType,
    sessionName,
    playerNames,
    winnerDisplayName,
    finalScoresJson,
    playedAt,
    durationSeconds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryRecord &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.gameType == this.gameType &&
          other.sessionName == this.sessionName &&
          other.playerNames == this.playerNames &&
          other.winnerDisplayName == this.winnerDisplayName &&
          other.finalScoresJson == this.finalScoresJson &&
          other.playedAt == this.playedAt &&
          other.durationSeconds == this.durationSeconds);
}

class HistoryRecordsCompanion extends UpdateCompanion<HistoryRecord> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> gameType;
  final Value<String?> sessionName;
  final Value<String> playerNames;
  final Value<String?> winnerDisplayName;
  final Value<String> finalScoresJson;
  final Value<int> playedAt;
  final Value<int?> durationSeconds;
  const HistoryRecordsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.gameType = const Value.absent(),
    this.sessionName = const Value.absent(),
    this.playerNames = const Value.absent(),
    this.winnerDisplayName = const Value.absent(),
    this.finalScoresJson = const Value.absent(),
    this.playedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
  });
  HistoryRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String gameType,
    this.sessionName = const Value.absent(),
    required String playerNames,
    this.winnerDisplayName = const Value.absent(),
    required String finalScoresJson,
    required int playedAt,
    this.durationSeconds = const Value.absent(),
  }) : sessionId = Value(sessionId),
       gameType = Value(gameType),
       playerNames = Value(playerNames),
       finalScoresJson = Value(finalScoresJson),
       playedAt = Value(playedAt);
  static Insertable<HistoryRecord> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? gameType,
    Expression<String>? sessionName,
    Expression<String>? playerNames,
    Expression<String>? winnerDisplayName,
    Expression<String>? finalScoresJson,
    Expression<int>? playedAt,
    Expression<int>? durationSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (gameType != null) 'game_type': gameType,
      if (sessionName != null) 'session_name': sessionName,
      if (playerNames != null) 'player_names': playerNames,
      if (winnerDisplayName != null) 'winner_display_name': winnerDisplayName,
      if (finalScoresJson != null) 'final_scores_json': finalScoresJson,
      if (playedAt != null) 'played_at': playedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
    });
  }

  HistoryRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<String>? gameType,
    Value<String?>? sessionName,
    Value<String>? playerNames,
    Value<String?>? winnerDisplayName,
    Value<String>? finalScoresJson,
    Value<int>? playedAt,
    Value<int?>? durationSeconds,
  }) {
    return HistoryRecordsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      gameType: gameType ?? this.gameType,
      sessionName: sessionName ?? this.sessionName,
      playerNames: playerNames ?? this.playerNames,
      winnerDisplayName: winnerDisplayName ?? this.winnerDisplayName,
      finalScoresJson: finalScoresJson ?? this.finalScoresJson,
      playedAt: playedAt ?? this.playedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (gameType.present) {
      map['game_type'] = Variable<String>(gameType.value);
    }
    if (sessionName.present) {
      map['session_name'] = Variable<String>(sessionName.value);
    }
    if (playerNames.present) {
      map['player_names'] = Variable<String>(playerNames.value);
    }
    if (winnerDisplayName.present) {
      map['winner_display_name'] = Variable<String>(winnerDisplayName.value);
    }
    if (finalScoresJson.present) {
      map['final_scores_json'] = Variable<String>(finalScoresJson.value);
    }
    if (playedAt.present) {
      map['played_at'] = Variable<int>(playedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoryRecordsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('gameType: $gameType, ')
          ..write('sessionName: $sessionName, ')
          ..write('playerNames: $playerNames, ')
          ..write('winnerDisplayName: $winnerDisplayName, ')
          ..write('finalScoresJson: $finalScoresJson, ')
          ..write('playedAt: $playedAt, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }
}

class $NotepadEntriesTable extends NotepadEntries
    with TableInfo<$NotepadEntriesTable, NotepadEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotepadEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Note'),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, body, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notepad_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotepadEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
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
  NotepadEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotepadEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotepadEntriesTable createAlias(String alias) {
    return $NotepadEntriesTable(attachedDatabase, alias);
  }
}

class NotepadEntry extends DataClass implements Insertable<NotepadEntry> {
  final int id;
  final String title;
  final String body;
  final int updatedAt;
  const NotepadEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  NotepadEntriesCompanion toCompanion(bool nullToAbsent) {
    return NotepadEntriesCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      updatedAt: Value(updatedAt),
    );
  }

  factory NotepadEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotepadEntry(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  NotepadEntry copyWith({
    int? id,
    String? title,
    String? body,
    int? updatedAt,
  }) => NotepadEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NotepadEntry copyWithCompanion(NotepadEntriesCompanion data) {
    return NotepadEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotepadEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, body, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotepadEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.updatedAt == this.updatedAt);
}

class NotepadEntriesCompanion extends UpdateCompanion<NotepadEntry> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> body;
  final Value<int> updatedAt;
  const NotepadEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotepadEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    required int updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<NotepadEntry> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotepadEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? body,
    Value<int>? updatedAt,
  }) {
    return NotepadEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotepadEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TallyCountersTable extends TallyCounters
    with TableInfo<$TallyCountersTable, TallyCounter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TallyCountersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Counter'),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tally_counters';
  @override
  VerificationContext validateIntegrity(
    Insertable<TallyCounter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
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
  TallyCounter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TallyCounter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TallyCountersTable createAlias(String alias) {
    return $TallyCountersTable(attachedDatabase, alias);
  }
}

class TallyCounter extends DataClass implements Insertable<TallyCounter> {
  final int id;
  final String name;
  final int value;
  final int updatedAt;
  const TallyCounter({
    required this.id,
    required this.name,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['value'] = Variable<int>(value);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  TallyCountersCompanion toCompanion(bool nullToAbsent) {
    return TallyCountersCompanion(
      id: Value(id),
      name: Value(name),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory TallyCounter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TallyCounter(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      value: serializer.fromJson<int>(json['value']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'value': serializer.toJson<int>(value),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  TallyCounter copyWith({int? id, String? name, int? value, int? updatedAt}) =>
      TallyCounter(
        id: id ?? this.id,
        name: name ?? this.name,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TallyCounter copyWithCompanion(TallyCountersCompanion data) {
    return TallyCounter(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TallyCounter(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TallyCounter &&
          other.id == this.id &&
          other.name == this.name &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class TallyCountersCompanion extends UpdateCompanion<TallyCounter> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> value;
  final Value<int> updatedAt;
  const TallyCountersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TallyCountersCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    required int updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<TallyCounter> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? value,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TallyCountersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? value,
    Value<int>? updatedAt,
  }) {
    return TallyCountersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TallyCountersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GameSessionsTable gameSessions = $GameSessionsTable(this);
  late final $ScoreEntriesTable scoreEntries = $ScoreEntriesTable(this);
  late final $HistoryRecordsTable historyRecords = $HistoryRecordsTable(this);
  late final $NotepadEntriesTable notepadEntries = $NotepadEntriesTable(this);
  late final $TallyCountersTable tallyCounters = $TallyCountersTable(this);
  late final Index idxSessionsStatus = Index(
    'idx_sessions_status',
    'CREATE INDEX idx_sessions_status ON game_sessions (status)',
  );
  late final Index idxSessionsGameTypeStatus = Index(
    'idx_sessions_game_type_status',
    'CREATE INDEX idx_sessions_game_type_status ON game_sessions (game_type, status)',
  );
  late final Index idxSessionsStartedAt = Index(
    'idx_sessions_started_at',
    'CREATE INDEX idx_sessions_started_at ON game_sessions (started_at DESC)',
  );
  late final Index idxScoreEntriesSession = Index(
    'idx_score_entries_session',
    'CREATE INDEX idx_score_entries_session ON score_entries (session_id)',
  );
  late final Index idxScoreEntriesSessionPlayer = Index(
    'idx_score_entries_session_player',
    'CREATE INDEX idx_score_entries_session_player ON score_entries (session_id, player_id)',
  );
  late final Index idxScoreEntriesSessionRound = Index(
    'idx_score_entries_session_round',
    'CREATE INDEX idx_score_entries_session_round ON score_entries (session_id, round_number)',
  );
  late final Index idxHistoryGameType = Index(
    'idx_history_game_type',
    'CREATE INDEX idx_history_game_type ON history_records (game_type)',
  );
  late final Index idxHistoryPlayedAt = Index(
    'idx_history_played_at',
    'CREATE INDEX idx_history_played_at ON history_records (played_at DESC)',
  );
  late final Index idxHistoryPlayerNames = Index(
    'idx_history_player_names',
    'CREATE INDEX idx_history_player_names ON history_records (player_names)',
  );
  late final SessionDao sessionDao = SessionDao(this as AppDatabase);
  late final HistoryDao historyDao = HistoryDao(this as AppDatabase);
  late final ToolsDao toolsDao = ToolsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    gameSessions,
    scoreEntries,
    historyRecords,
    notepadEntries,
    tallyCounters,
    idxSessionsStatus,
    idxSessionsGameTypeStatus,
    idxSessionsStartedAt,
    idxScoreEntriesSession,
    idxScoreEntriesSessionPlayer,
    idxScoreEntriesSessionRound,
    idxHistoryGameType,
    idxHistoryPlayedAt,
    idxHistoryPlayerNames,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'game_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('score_entries', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$GameSessionsTableCreateCompanionBuilder =
    GameSessionsCompanion Function({
      Value<int> id,
      required String gameType,
      Value<String?> sessionName,
      Value<int> status,
      required int startedAt,
      Value<int?> endedAt,
      required String participantsJson,
      required String moduleStateJson,
      Value<String?> winnerDisplayName,
    });
typedef $$GameSessionsTableUpdateCompanionBuilder =
    GameSessionsCompanion Function({
      Value<int> id,
      Value<String> gameType,
      Value<String?> sessionName,
      Value<int> status,
      Value<int> startedAt,
      Value<int?> endedAt,
      Value<String> participantsJson,
      Value<String> moduleStateJson,
      Value<String?> winnerDisplayName,
    });

final class $$GameSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $GameSessionsTable, GameSession> {
  $$GameSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ScoreEntriesTable, List<ScoreEntry>>
  _scoreEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.scoreEntries,
    aliasName: $_aliasNameGenerator(
      db.gameSessions.id,
      db.scoreEntries.sessionId,
    ),
  );

  $$ScoreEntriesTableProcessedTableManager get scoreEntriesRefs {
    final manager = $$ScoreEntriesTableTableManager(
      $_db,
      $_db.scoreEntries,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_scoreEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HistoryRecordsTable, List<HistoryRecord>>
  _historyRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.historyRecords,
    aliasName: $_aliasNameGenerator(
      db.gameSessions.id,
      db.historyRecords.sessionId,
    ),
  );

  $$HistoryRecordsTableProcessedTableManager get historyRecordsRefs {
    final manager = $$HistoryRecordsTableTableManager(
      $_db,
      $_db.historyRecords,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_historyRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GameSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $GameSessionsTable> {
  $$GameSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gameType => $composableBuilder(
    column: $table.gameType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionName => $composableBuilder(
    column: $table.sessionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get participantsJson => $composableBuilder(
    column: $table.participantsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleStateJson => $composableBuilder(
    column: $table.moduleStateJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get winnerDisplayName => $composableBuilder(
    column: $table.winnerDisplayName,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> scoreEntriesRefs(
    Expression<bool> Function($$ScoreEntriesTableFilterComposer f) f,
  ) {
    final $$ScoreEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scoreEntries,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScoreEntriesTableFilterComposer(
            $db: $db,
            $table: $db.scoreEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> historyRecordsRefs(
    Expression<bool> Function($$HistoryRecordsTableFilterComposer f) f,
  ) {
    final $$HistoryRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.historyRecords,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HistoryRecordsTableFilterComposer(
            $db: $db,
            $table: $db.historyRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GameSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $GameSessionsTable> {
  $$GameSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gameType => $composableBuilder(
    column: $table.gameType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionName => $composableBuilder(
    column: $table.sessionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get participantsJson => $composableBuilder(
    column: $table.participantsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleStateJson => $composableBuilder(
    column: $table.moduleStateJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get winnerDisplayName => $composableBuilder(
    column: $table.winnerDisplayName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GameSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameSessionsTable> {
  $$GameSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gameType =>
      $composableBuilder(column: $table.gameType, builder: (column) => column);

  GeneratedColumn<String> get sessionName => $composableBuilder(
    column: $table.sessionName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get participantsJson => $composableBuilder(
    column: $table.participantsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moduleStateJson => $composableBuilder(
    column: $table.moduleStateJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get winnerDisplayName => $composableBuilder(
    column: $table.winnerDisplayName,
    builder: (column) => column,
  );

  Expression<T> scoreEntriesRefs<T extends Object>(
    Expression<T> Function($$ScoreEntriesTableAnnotationComposer a) f,
  ) {
    final $$ScoreEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scoreEntries,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScoreEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.scoreEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> historyRecordsRefs<T extends Object>(
    Expression<T> Function($$HistoryRecordsTableAnnotationComposer a) f,
  ) {
    final $$HistoryRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.historyRecords,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HistoryRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.historyRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GameSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameSessionsTable,
          GameSession,
          $$GameSessionsTableFilterComposer,
          $$GameSessionsTableOrderingComposer,
          $$GameSessionsTableAnnotationComposer,
          $$GameSessionsTableCreateCompanionBuilder,
          $$GameSessionsTableUpdateCompanionBuilder,
          (GameSession, $$GameSessionsTableReferences),
          GameSession,
          PrefetchHooks Function({
            bool scoreEntriesRefs,
            bool historyRecordsRefs,
          })
        > {
  $$GameSessionsTableTableManager(_$AppDatabase db, $GameSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> gameType = const Value.absent(),
                Value<String?> sessionName = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> startedAt = const Value.absent(),
                Value<int?> endedAt = const Value.absent(),
                Value<String> participantsJson = const Value.absent(),
                Value<String> moduleStateJson = const Value.absent(),
                Value<String?> winnerDisplayName = const Value.absent(),
              }) => GameSessionsCompanion(
                id: id,
                gameType: gameType,
                sessionName: sessionName,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                participantsJson: participantsJson,
                moduleStateJson: moduleStateJson,
                winnerDisplayName: winnerDisplayName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String gameType,
                Value<String?> sessionName = const Value.absent(),
                Value<int> status = const Value.absent(),
                required int startedAt,
                Value<int?> endedAt = const Value.absent(),
                required String participantsJson,
                required String moduleStateJson,
                Value<String?> winnerDisplayName = const Value.absent(),
              }) => GameSessionsCompanion.insert(
                id: id,
                gameType: gameType,
                sessionName: sessionName,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                participantsJson: participantsJson,
                moduleStateJson: moduleStateJson,
                winnerDisplayName: winnerDisplayName,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GameSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({scoreEntriesRefs = false, historyRecordsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (scoreEntriesRefs) db.scoreEntries,
                    if (historyRecordsRefs) db.historyRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (scoreEntriesRefs)
                        await $_getPrefetchedData<
                          GameSession,
                          $GameSessionsTable,
                          ScoreEntry
                        >(
                          currentTable: table,
                          referencedTable: $$GameSessionsTableReferences
                              ._scoreEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GameSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).scoreEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (historyRecordsRefs)
                        await $_getPrefetchedData<
                          GameSession,
                          $GameSessionsTable,
                          HistoryRecord
                        >(
                          currentTable: table,
                          referencedTable: $$GameSessionsTableReferences
                              ._historyRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GameSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).historyRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
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

typedef $$GameSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameSessionsTable,
      GameSession,
      $$GameSessionsTableFilterComposer,
      $$GameSessionsTableOrderingComposer,
      $$GameSessionsTableAnnotationComposer,
      $$GameSessionsTableCreateCompanionBuilder,
      $$GameSessionsTableUpdateCompanionBuilder,
      (GameSession, $$GameSessionsTableReferences),
      GameSession,
      PrefetchHooks Function({bool scoreEntriesRefs, bool historyRecordsRefs})
    >;
typedef $$ScoreEntriesTableCreateCompanionBuilder =
    ScoreEntriesCompanion Function({
      Value<int> id,
      required int sessionId,
      required String playerId,
      required int roundNumber,
      required int value,
      Value<String?> notes,
      required int recordedAt,
    });
typedef $$ScoreEntriesTableUpdateCompanionBuilder =
    ScoreEntriesCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<String> playerId,
      Value<int> roundNumber,
      Value<int> value,
      Value<String?> notes,
      Value<int> recordedAt,
    });

final class $$ScoreEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $ScoreEntriesTable, ScoreEntry> {
  $$ScoreEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GameSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.gameSessions.createAlias(
        $_aliasNameGenerator(db.scoreEntries.sessionId, db.gameSessions.id),
      );

  $$GameSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$GameSessionsTableTableManager(
      $_db,
      $_db.gameSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScoreEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ScoreEntriesTable> {
  $$ScoreEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roundNumber => $composableBuilder(
    column: $table.roundNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GameSessionsTableFilterComposer get sessionId {
    final $$GameSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.gameSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameSessionsTableFilterComposer(
            $db: $db,
            $table: $db.gameSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScoreEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScoreEntriesTable> {
  $$ScoreEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roundNumber => $composableBuilder(
    column: $table.roundNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GameSessionsTableOrderingComposer get sessionId {
    final $$GameSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.gameSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.gameSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScoreEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScoreEntriesTable> {
  $$ScoreEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get playerId =>
      $composableBuilder(column: $table.playerId, builder: (column) => column);

  GeneratedColumn<int> get roundNumber => $composableBuilder(
    column: $table.roundNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  $$GameSessionsTableAnnotationComposer get sessionId {
    final $$GameSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.gameSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.gameSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScoreEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScoreEntriesTable,
          ScoreEntry,
          $$ScoreEntriesTableFilterComposer,
          $$ScoreEntriesTableOrderingComposer,
          $$ScoreEntriesTableAnnotationComposer,
          $$ScoreEntriesTableCreateCompanionBuilder,
          $$ScoreEntriesTableUpdateCompanionBuilder,
          (ScoreEntry, $$ScoreEntriesTableReferences),
          ScoreEntry,
          PrefetchHooks Function({bool sessionId})
        > {
  $$ScoreEntriesTableTableManager(_$AppDatabase db, $ScoreEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScoreEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScoreEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScoreEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<String> playerId = const Value.absent(),
                Value<int> roundNumber = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> recordedAt = const Value.absent(),
              }) => ScoreEntriesCompanion(
                id: id,
                sessionId: sessionId,
                playerId: playerId,
                roundNumber: roundNumber,
                value: value,
                notes: notes,
                recordedAt: recordedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required String playerId,
                required int roundNumber,
                required int value,
                Value<String?> notes = const Value.absent(),
                required int recordedAt,
              }) => ScoreEntriesCompanion.insert(
                id: id,
                sessionId: sessionId,
                playerId: playerId,
                roundNumber: roundNumber,
                value: value,
                notes: notes,
                recordedAt: recordedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ScoreEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
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
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$ScoreEntriesTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$ScoreEntriesTableReferences
                                    ._sessionIdTable(db)
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

typedef $$ScoreEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScoreEntriesTable,
      ScoreEntry,
      $$ScoreEntriesTableFilterComposer,
      $$ScoreEntriesTableOrderingComposer,
      $$ScoreEntriesTableAnnotationComposer,
      $$ScoreEntriesTableCreateCompanionBuilder,
      $$ScoreEntriesTableUpdateCompanionBuilder,
      (ScoreEntry, $$ScoreEntriesTableReferences),
      ScoreEntry,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$HistoryRecordsTableCreateCompanionBuilder =
    HistoryRecordsCompanion Function({
      Value<int> id,
      required int sessionId,
      required String gameType,
      Value<String?> sessionName,
      required String playerNames,
      Value<String?> winnerDisplayName,
      required String finalScoresJson,
      required int playedAt,
      Value<int?> durationSeconds,
    });
typedef $$HistoryRecordsTableUpdateCompanionBuilder =
    HistoryRecordsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<String> gameType,
      Value<String?> sessionName,
      Value<String> playerNames,
      Value<String?> winnerDisplayName,
      Value<String> finalScoresJson,
      Value<int> playedAt,
      Value<int?> durationSeconds,
    });

final class $$HistoryRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $HistoryRecordsTable, HistoryRecord> {
  $$HistoryRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GameSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.gameSessions.createAlias(
        $_aliasNameGenerator(db.historyRecords.sessionId, db.gameSessions.id),
      );

  $$GameSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$GameSessionsTableTableManager(
      $_db,
      $_db.gameSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HistoryRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $HistoryRecordsTable> {
  $$HistoryRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gameType => $composableBuilder(
    column: $table.gameType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionName => $composableBuilder(
    column: $table.sessionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get playerNames => $composableBuilder(
    column: $table.playerNames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get winnerDisplayName => $composableBuilder(
    column: $table.winnerDisplayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get finalScoresJson => $composableBuilder(
    column: $table.finalScoresJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playedAt => $composableBuilder(
    column: $table.playedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  $$GameSessionsTableFilterComposer get sessionId {
    final $$GameSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.gameSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameSessionsTableFilterComposer(
            $db: $db,
            $table: $db.gameSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HistoryRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoryRecordsTable> {
  $$HistoryRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gameType => $composableBuilder(
    column: $table.gameType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionName => $composableBuilder(
    column: $table.sessionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get playerNames => $composableBuilder(
    column: $table.playerNames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get winnerDisplayName => $composableBuilder(
    column: $table.winnerDisplayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get finalScoresJson => $composableBuilder(
    column: $table.finalScoresJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playedAt => $composableBuilder(
    column: $table.playedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  $$GameSessionsTableOrderingComposer get sessionId {
    final $$GameSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.gameSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.gameSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HistoryRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoryRecordsTable> {
  $$HistoryRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gameType =>
      $composableBuilder(column: $table.gameType, builder: (column) => column);

  GeneratedColumn<String> get sessionName => $composableBuilder(
    column: $table.sessionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get playerNames => $composableBuilder(
    column: $table.playerNames,
    builder: (column) => column,
  );

  GeneratedColumn<String> get winnerDisplayName => $composableBuilder(
    column: $table.winnerDisplayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get finalScoresJson => $composableBuilder(
    column: $table.finalScoresJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get playedAt =>
      $composableBuilder(column: $table.playedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  $$GameSessionsTableAnnotationComposer get sessionId {
    final $$GameSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.gameSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.gameSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HistoryRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HistoryRecordsTable,
          HistoryRecord,
          $$HistoryRecordsTableFilterComposer,
          $$HistoryRecordsTableOrderingComposer,
          $$HistoryRecordsTableAnnotationComposer,
          $$HistoryRecordsTableCreateCompanionBuilder,
          $$HistoryRecordsTableUpdateCompanionBuilder,
          (HistoryRecord, $$HistoryRecordsTableReferences),
          HistoryRecord,
          PrefetchHooks Function({bool sessionId})
        > {
  $$HistoryRecordsTableTableManager(
    _$AppDatabase db,
    $HistoryRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoryRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoryRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoryRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<String> gameType = const Value.absent(),
                Value<String?> sessionName = const Value.absent(),
                Value<String> playerNames = const Value.absent(),
                Value<String?> winnerDisplayName = const Value.absent(),
                Value<String> finalScoresJson = const Value.absent(),
                Value<int> playedAt = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
              }) => HistoryRecordsCompanion(
                id: id,
                sessionId: sessionId,
                gameType: gameType,
                sessionName: sessionName,
                playerNames: playerNames,
                winnerDisplayName: winnerDisplayName,
                finalScoresJson: finalScoresJson,
                playedAt: playedAt,
                durationSeconds: durationSeconds,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required String gameType,
                Value<String?> sessionName = const Value.absent(),
                required String playerNames,
                Value<String?> winnerDisplayName = const Value.absent(),
                required String finalScoresJson,
                required int playedAt,
                Value<int?> durationSeconds = const Value.absent(),
              }) => HistoryRecordsCompanion.insert(
                id: id,
                sessionId: sessionId,
                gameType: gameType,
                sessionName: sessionName,
                playerNames: playerNames,
                winnerDisplayName: winnerDisplayName,
                finalScoresJson: finalScoresJson,
                playedAt: playedAt,
                durationSeconds: durationSeconds,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HistoryRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
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
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$HistoryRecordsTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn:
                                    $$HistoryRecordsTableReferences
                                        ._sessionIdTable(db)
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

typedef $$HistoryRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistoryRecordsTable,
      HistoryRecord,
      $$HistoryRecordsTableFilterComposer,
      $$HistoryRecordsTableOrderingComposer,
      $$HistoryRecordsTableAnnotationComposer,
      $$HistoryRecordsTableCreateCompanionBuilder,
      $$HistoryRecordsTableUpdateCompanionBuilder,
      (HistoryRecord, $$HistoryRecordsTableReferences),
      HistoryRecord,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$NotepadEntriesTableCreateCompanionBuilder =
    NotepadEntriesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> body,
      required int updatedAt,
    });
typedef $$NotepadEntriesTableUpdateCompanionBuilder =
    NotepadEntriesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> body,
      Value<int> updatedAt,
    });

class $$NotepadEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $NotepadEntriesTable> {
  $$NotepadEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotepadEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotepadEntriesTable> {
  $$NotepadEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotepadEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotepadEntriesTable> {
  $$NotepadEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NotepadEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotepadEntriesTable,
          NotepadEntry,
          $$NotepadEntriesTableFilterComposer,
          $$NotepadEntriesTableOrderingComposer,
          $$NotepadEntriesTableAnnotationComposer,
          $$NotepadEntriesTableCreateCompanionBuilder,
          $$NotepadEntriesTableUpdateCompanionBuilder,
          (
            NotepadEntry,
            BaseReferences<_$AppDatabase, $NotepadEntriesTable, NotepadEntry>,
          ),
          NotepadEntry,
          PrefetchHooks Function()
        > {
  $$NotepadEntriesTableTableManager(
    _$AppDatabase db,
    $NotepadEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotepadEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotepadEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotepadEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => NotepadEntriesCompanion(
                id: id,
                title: title,
                body: body,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                required int updatedAt,
              }) => NotepadEntriesCompanion.insert(
                id: id,
                title: title,
                body: body,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotepadEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotepadEntriesTable,
      NotepadEntry,
      $$NotepadEntriesTableFilterComposer,
      $$NotepadEntriesTableOrderingComposer,
      $$NotepadEntriesTableAnnotationComposer,
      $$NotepadEntriesTableCreateCompanionBuilder,
      $$NotepadEntriesTableUpdateCompanionBuilder,
      (
        NotepadEntry,
        BaseReferences<_$AppDatabase, $NotepadEntriesTable, NotepadEntry>,
      ),
      NotepadEntry,
      PrefetchHooks Function()
    >;
typedef $$TallyCountersTableCreateCompanionBuilder =
    TallyCountersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> value,
      required int updatedAt,
    });
typedef $$TallyCountersTableUpdateCompanionBuilder =
    TallyCountersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> value,
      Value<int> updatedAt,
    });

class $$TallyCountersTableFilterComposer
    extends Composer<_$AppDatabase, $TallyCountersTable> {
  $$TallyCountersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TallyCountersTableOrderingComposer
    extends Composer<_$AppDatabase, $TallyCountersTable> {
  $$TallyCountersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TallyCountersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TallyCountersTable> {
  $$TallyCountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TallyCountersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TallyCountersTable,
          TallyCounter,
          $$TallyCountersTableFilterComposer,
          $$TallyCountersTableOrderingComposer,
          $$TallyCountersTableAnnotationComposer,
          $$TallyCountersTableCreateCompanionBuilder,
          $$TallyCountersTableUpdateCompanionBuilder,
          (
            TallyCounter,
            BaseReferences<_$AppDatabase, $TallyCountersTable, TallyCounter>,
          ),
          TallyCounter,
          PrefetchHooks Function()
        > {
  $$TallyCountersTableTableManager(_$AppDatabase db, $TallyCountersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TallyCountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TallyCountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TallyCountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => TallyCountersCompanion(
                id: id,
                name: name,
                value: value,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> value = const Value.absent(),
                required int updatedAt,
              }) => TallyCountersCompanion.insert(
                id: id,
                name: name,
                value: value,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TallyCountersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TallyCountersTable,
      TallyCounter,
      $$TallyCountersTableFilterComposer,
      $$TallyCountersTableOrderingComposer,
      $$TallyCountersTableAnnotationComposer,
      $$TallyCountersTableCreateCompanionBuilder,
      $$TallyCountersTableUpdateCompanionBuilder,
      (
        TallyCounter,
        BaseReferences<_$AppDatabase, $TallyCountersTable, TallyCounter>,
      ),
      TallyCounter,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GameSessionsTableTableManager get gameSessions =>
      $$GameSessionsTableTableManager(_db, _db.gameSessions);
  $$ScoreEntriesTableTableManager get scoreEntries =>
      $$ScoreEntriesTableTableManager(_db, _db.scoreEntries);
  $$HistoryRecordsTableTableManager get historyRecords =>
      $$HistoryRecordsTableTableManager(_db, _db.historyRecords);
  $$NotepadEntriesTableTableManager get notepadEntries =>
      $$NotepadEntriesTableTableManager(_db, _db.notepadEntries);
  $$TallyCountersTableTableManager get tallyCounters =>
      $$TallyCountersTableTableManager(_db, _db.tallyCounters);
}
