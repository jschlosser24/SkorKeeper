/// Sound pack IDs and metadata.
abstract class SoundPacks {
  static const all = [
    _classic,
    _arcade,
    _nature,
    _jazz,
    _minimal,
    _epic,
    _neon,
    _sports,
  ];

  static const _classic = SoundPackDefinition(
    id: 'classic',
    name: 'Classic',
    emoji: '🎵',
    description: 'Clean, simple game sounds.',
  );

  static const _arcade = SoundPackDefinition(
    id: 'arcade',
    name: 'Arcade',
    emoji: '🕹️',
    description: 'Retro 8-bit style bleeps and bloops.',
    isPro: true,
  );

  static const _nature = SoundPackDefinition(
    id: 'nature',
    name: 'Nature',
    emoji: '🌿',
    description: 'Organic, earthy game tones.',
    isPro: true,
  );

  static const _jazz = SoundPackDefinition(
    id: 'jazz',
    name: 'Jazz',
    emoji: '🎷',
    description: 'Smooth jazzy musical notes.',
    isPro: true,
  );

  static const _minimal = SoundPackDefinition(
    id: 'minimal',
    name: 'Minimal',
    emoji: '🤫',
    description: 'Ultra-subtle, barely-there clicks.',
    isPro: true,
  );

  static const _epic = SoundPackDefinition(
    id: 'epic',
    name: 'Epic',
    emoji: '⚡',
    description: 'Dramatic, cinematic game hits.',
    isPro: true,
  );

  static const _neon = SoundPackDefinition(
    id: 'neon',
    name: 'Neon',
    emoji: '🌟',
    description: 'Synth-wave electronic vibes.',
    isPro: true,
  );

  static const _sports = SoundPackDefinition(
    id: 'sports',
    name: 'Sports',
    emoji: '🏆',
    description: 'Athletic, punchy, energetic.',
    isPro: true,
  );

  static SoundPackDefinition findById(String id) =>
      all.firstWhere((p) => p.id == id, orElse: () => _classic);
}

class SoundPackDefinition {
  const SoundPackDefinition({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    this.isPro = false,
  });

  final String id;
  final String name;
  final String emoji;
  final String description;
  final bool isPro;
}
