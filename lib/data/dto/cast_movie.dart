class MovieCredits {
  final List<CastMember> cast;

  MovieCredits({required this.cast});

  factory MovieCredits.fromJson(Map<String, dynamic> json) {
    return MovieCredits(
      cast: (json['cast'] as List)
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
    return CastMember(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      profilePath: json['profile_path'],
      character: json['character'],
    );
  }

  String get profileImageUrl {
    if (profilePath != null && profilePath!.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w185$profilePath';
    } else {
      return 'https://via.placeholder.com/100x150?text=No+Image';
    }
  }
}
