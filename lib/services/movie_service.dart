import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/category.dart';
import '../models/movie.dart';

/// Service responsible for loading and providing movie data.
/// Simulates an API call by reading from a local JSON asset.
class MovieService {
  // Singleton pattern to avoid multiple JSON reads
  static MovieService? _instance;
  static MovieService get instance => _instance ??= MovieService._();
  MovieService._();

  List<Category>? _cachedCategories;

  /// Loads all categories and their movies from the local JSON asset.
  /// Results are cached after the first load.
  Future<List<Category>> fetchCategories() async {
    if (_cachedCategories != null) return _cachedCategories!;

    // Simulate network latency for shimmer effect demonstration
    await Future.delayed(const Duration(milliseconds: 1200));

    final String jsonString =
        await rootBundle.loadString('assets/data/movies.json');
    final Map<String, dynamic> jsonData =
        json.decode(jsonString) as Map<String, dynamic>;

    _cachedCategories = (jsonData['categories'] as List)
        .map((c) => Category.fromJson(c as Map<String, dynamic>))
        .toList();

    return _cachedCategories!;
  }

  /// Returns only the featured movies (banner carousel).
  Future<List<Movie>> fetchFeaturedMovies() async {
    final categories = await fetchCategories();
    final featured = categories.firstWhere(
      (c) => c.id == 'featured',
      orElse: () => categories.first,
    );
    return featured.movies;
  }

  /// Returns categories excluding the "featured" banner category.
  Future<List<Category>> fetchRowCategories() async {
    final categories = await fetchCategories();
    return categories.where((c) => c.id != 'featured').toList();
  }

  /// Searches across all movies by title.
  Future<List<Movie>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];
    final categories = await fetchCategories();
    final allMovies = categories.expand((c) => c.movies).toSet().toList();
    final lowerQuery = query.toLowerCase();
    return allMovies
        .where((m) =>
            m.title.toLowerCase().contains(lowerQuery) ||
            m.genre.any((g) => g.toLowerCase().contains(lowerQuery)))
        .toList();
  }

  /// Clears cached data (useful for pull-to-refresh).
  void clearCache() => _cachedCategories = null;
}
