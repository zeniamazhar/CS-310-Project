class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;
  final String overview;
  final DateTime? createdAt;
  final String? createdBy;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.overview,
    required this.createdAt,
    required this.createdBy,
  });

  factory Movie.fromMap(Map<String, dynamic> data) {
    return Movie(
      id: data['id'],
      title: data['title'],
      posterPath: data['posterPath'],
      releaseDate: data['releaseDate'],
      voteAverage: (data['voteAverage'] ?? 0).toDouble(),
      overview: data['overview'],
      createdAt: data['createdAt'] as DateTime?,
      createdBy: data['createdBy'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'posterPath': posterPath,
    'releaseDate': releaseDate,
    'overview': overview,
    'voteAverage': voteAverage,
    'createdAt': createdAt,
    'createdBy': createdBy,
  };
}
