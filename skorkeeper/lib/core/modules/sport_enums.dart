import 'package:flutter/material.dart';

/// Sport type identifiers used across all sport modules.
enum SportType {
  baseball,
  basketball,
  football,
  soccer,
  tennis,
  volleyball,
  hockey,
  lacrosse;

  /// Whether this sport requires the Sports Pro entitlement to access.
  /// All sports (including Hockey and Lacrosse) are available with the
  /// Sports Plan; Sports Pro only unlocks in-depth tracking for every sport.
  bool get requiresPro => false;

  /// Human-readable display name.
  String get displayName {
    switch (this) {
      case SportType.baseball:
        return 'Baseball';
      case SportType.basketball:
        return 'Basketball';
      case SportType.football:
        return 'Football';
      case SportType.soccer:
        return 'Soccer';
      case SportType.tennis:
        return 'Tennis';
      case SportType.volleyball:
        return 'Volleyball';
      case SportType.hockey:
        return 'Hockey';
      case SportType.lacrosse:
        return 'Lacrosse';
    }
  }

  /// The [gameTypeId] string stored in the database.
  String get gameTypeId => 'sport_$name';
}

/// Tracking fidelity selected at game setup.
enum TrackingMode {
  /// Basic scorekeeping — team-level scores and aggregate stats only.
  basic,

  /// In-depth tracking — player-level attribution, advanced stats. Requires Pro.
  inDepth,
}

/// Lifecycle phase of a sport game session.
enum GamePhase {
  notStarted,
  active,
  paused,

  /// Between quarters or periods (Basketball, Football, Hockey, Lacrosse).
  periodBreak,

  /// Halftime break (Soccer, Football).
  halftimeBreak,

  /// Tennis tiebreak or Hockey overtime / shootout.
  tiebreakActive,

  completed;

  /// Whether the game is in a state where scoring is permitted.
  bool get isPlayable => this == active || this == tiebreakActive;
}

/// Supported export file formats.
enum ExportFormat {
  pdf,
  csv,
  json;

  /// File extension for this format.
  String get extension {
    switch (this) {
      case ExportFormat.pdf:
        return 'pdf';
      case ExportFormat.csv:
        return 'csv';
      case ExportFormat.json:
        return 'json';
    }
  }

  /// MIME type for this format.
  String get mimeType {
    switch (this) {
      case ExportFormat.pdf:
        return 'application/pdf';
      case ExportFormat.csv:
        return 'text/csv';
      case ExportFormat.json:
        return 'application/json';
    }
  }
}

/// Current status of an export operation.
enum ExportStatus { pending, generating, complete, failed }
