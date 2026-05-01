/// Model representing a single Movie/Show entity.
class Movie {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String bannerUrl;
  final double rating;
  final int year;
  final String duration;
  final List<String> genre;
  final bool isTrending;
  final bool isContinueWatching;
  final double watchProgress; // 0.0 to 1.0

  const Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.bannerUrl,
    required this.rating,
    required this.year,
    required this.duration,
    required this.genre,
    this.isTrending = false,
    this.isContinueWatching = false,
    this.watchProgress = 0.0,
  });

  /// Factory constructor to create a Movie from JSON data.
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      bannerUrl: json['bannerUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      year: json['year'] as int,
      duration: json['duration'] as String,
      genre: List<String>.from(json['genre'] as List),
      isTrending: json['isTrending'] as bool? ?? false,
      isContinueWatching: json['isContinueWatching'] as bool? ?? false,
      watchProgress: (json['watchProgress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Converts Movie object back to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'bannerUrl': bannerUrl,
      'rating': rating,
      'year': year,
      'duration': duration,
      'genre': genre,
      'isTrending': isTrending,
      'isContinueWatching': isContinueWatching,
      'watchProgress': watchProgress,
    };
  }

  /// Formatted genre string for display.
  String get genreString => genre.join(' • ');

  /// Rating displayed as a string with one decimal.
  String get ratingString => rating.toStringAsFixed(1);
}
