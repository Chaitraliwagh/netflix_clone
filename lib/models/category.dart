import 'movie.dart';

/// Model representing a category of movies/shows.
class Category {
  final String id;
  final String name;
  final List<Movie> movies;

  const Category({
    required this.id,
    required this.name,
    required this.movies,
  });

  /// Factory constructor to create a Category from JSON data.
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      movies: (json['movies'] as List)
          .map((m) => Movie.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}
