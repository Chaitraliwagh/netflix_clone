import 'package:flutter/foundation.dart' hide Category;

import '../models/category.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

/// Enum representing the loading state of data.
enum LoadingStatus { idle, loading, loaded, error }

/// Provider that manages global movie state.
/// Used by screens to access featured movies, categories, and search.
class MovieProvider extends ChangeNotifier {
  final MovieService _service = MovieService.instance;

  // State fields
  LoadingStatus _status = LoadingStatus.idle;
  List<Movie> _featuredMovies = [];
  List<Category> _categories = [];
  Movie? _selectedMovie;
  String _errorMessage = '';

  // Search state
  String _searchQuery = '';
  List<Movie> _searchResults = [];
  bool _isSearching = false;

  // Getters
  LoadingStatus get status => _status;
  List<Movie> get featuredMovies => _featuredMovies;
  List<Category> get categories => _categories;
  Movie? get selectedMovie => _selectedMovie;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  List<Movie> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  bool get isLoaded => _status == LoadingStatus.loaded;

  /// Fetches all data from the service and updates the UI state.
  Future<void> loadData() async {
    if (_status == LoadingStatus.loading) return;

    _status = LoadingStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.fetchFeaturedMovies(),
        _service.fetchRowCategories(),
      ]);

      _featuredMovies = results[0] as List<Movie>;
      _categories = results[1] as List<Category>;
      _status = LoadingStatus.loaded;
    } catch (e) {
      _status = LoadingStatus.error;
      _errorMessage = 'Failed to load content. Please try again.';
      debugPrint('MovieProvider error: $e');
    }

    notifyListeners();
  }

  /// Refreshes data by clearing cache and reloading.
  Future<void> refreshData() async {
    _service.clearCache();
    _status = LoadingStatus.idle;
    await loadData();
  }

  /// Sets the currently selected movie (for detail screen).
  void selectMovie(Movie movie) {
    _selectedMovie = movie;
    notifyListeners();
  }

  /// Updates the search query and fetches results.
  Future<void> updateSearch(String query) async {
    _searchQuery = query;
    _isSearching = query.isNotEmpty;

    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    notifyListeners(); // Show loading state

    _searchResults = await _service.searchMovies(query);
    notifyListeners();
  }

  /// Clears search state.
  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }
}
