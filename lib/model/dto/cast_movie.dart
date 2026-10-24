class MovieCredits {
  final List<CastMember> cast;

  MovieCredits({required this.cast});

  factory MovieCredits.fromJson(dynamic json) {
    List<dynamic> list = [];
    if (json is List) {
      list = json;
    } else if (json is Map<String, dynamic>) {
      if (json['cast'] is List) {
        list = json['cast'] as List;
      } else if (json['_embedded'] is Map &&
          (json['_embedded'] as Map)['cast'] is List) {
        list = (json['_embedded'] as Map)['cast'] as List;
      }
    }
    return MovieCredits(
      cast: list
          .whereType<Map<String, dynamic>>()
          .map((item) => CastMember.fromJson(item))
          .toList(),
    );
  }
}

class CastMember {
  final int id;
  final String name;
  final String? profilePath;
  final String? character;

  CastMember({
    required this.id,
    required this.name,
    this.profilePath,
    this.character,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('person') && json['person'] is Map) {
      final person = json['person'] as Map<String, dynamic>;
      final character = json['character'] as Map<String, dynamic>? ?? {};
      final personImage = person['image'] as Map<String, dynamic>?;
      return CastMember(
        id: (person['id'] as num?)?.toInt() ?? 0,
        name: (person['name'] as String?)?.trim() ?? 'Unknown',
        profilePath: (personImage?['medium'] ?? personImage?['original']) as String?,
        character: (character['name'] as String?)?.trim(),
      );
    }

    return CastMember(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?)?.trim() ?? 'Unknown',
      profilePath: json['profile_path'] as String?,
      character: (json['character'] as String?)?.trim(),
    );
  }

  String? get profileImageUrl {
    if (profilePath == null || profilePath!.isEmpty) return null;
    if (profilePath!.startsWith('http')) return profilePath;
    return 'https://image.tmdb.org/t/p/w185$profilePath';
  }
}
