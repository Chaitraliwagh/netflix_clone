import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../utils/constants.dart';
import '../widgets/shimmer_loader.dart';
import 'movie_detail_screen.dart';

/// Search screen with real-time movie filtering.
/// Features:
/// - Live search with debounce
/// - Grid layout for results
/// - Hero animation on tap
/// - Empty/no-results states
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    setState(() => _isLoading = query.isNotEmpty);
    await context.read<MovieProvider>().updateSearch(query);
    if (mounted) setState(() => _isLoading = false);
  }

  void _navigateToDetail(Movie movie) {
    context.read<MovieProvider>().selectMovie(movie);
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MovieDetailScreen(),
        transitionsBuilder: (context, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();

    return Scaffold(
      backgroundColor: NetflixColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                NetflixSpacing.sectionPadding,
                NetflixSpacing.md,
                NetflixSpacing.sectionPadding,
                NetflixSpacing.md,
              ),
              child: const Text(
                'Search',
                style: TextStyle(
                  color: NetflixColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NetflixSpacing.sectionPadding,
              ),
              child: _SearchBar(
                controller: _controller,
                onChanged: _onSearchChanged,
                onClear: () {
                  _controller.clear();
                  _onSearchChanged('');
                },
              ),
            ),

            const SizedBox(height: NetflixSpacing.md),

            // Content area
            Expanded(
              child: _buildContent(provider, _isLoading),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(MovieProvider provider, bool isLoading) {
    // Not yet searched
    if (!provider.isSearching) {
      return _buildBrowseState(provider);
    }

    // Loading search results
    if (isLoading) {
      return const SearchShimmer();
    }

    // No results
    if (provider.searchResults.isEmpty) {
      return _buildNoResults(provider.searchQuery);
    }

    // Results grid
    return _SearchResultsGrid(
      movies: provider.searchResults,
      onMovieTap: _navigateToDetail,
    );
  }

  Widget _buildBrowseState(MovieProvider provider) {
    // Show all categories as a flat list
    final allMovies = provider.categories
        .expand((c) => c.movies)
        .toSet()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: NetflixSpacing.sectionPadding,
          ),
          child: Text(
            'Top Searches',
            style: NetflixTextStyles.sectionTitle,
          ),
        ),
        const SizedBox(height: NetflixSpacing.sm),
        Expanded(
          child: ListView.builder(
            itemCount: allMovies.length,
            itemBuilder: (context, index) {
              return _SearchListTile(
                movie: allMovies[index],
                onTap: () => _navigateToDetail(allMovies[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoResults(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: NetflixColors.textMuted,
            size: 64,
          ),
          const SizedBox(height: NetflixSpacing.md),
          const Text(
            'No results found',
            style: TextStyle(
              color: NetflixColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: NetflixSpacing.xs),
          Text(
            'Try different keywords for "$query"',
            style: NetflixTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

/// Netflix-style search input field.
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: false,
        style: const TextStyle(
          color: NetflixColors.textPrimary,
          fontSize: 15,
        ),
        cursorColor: NetflixColors.primary,
        decoration: InputDecoration(
          hintText: 'Search titles, genres...',
          hintStyle: const TextStyle(
            color: NetflixColors.textMuted,
            fontSize: 15,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: NetflixColors.textMuted,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) {
              return value.text.isNotEmpty
                  ? GestureDetector(
                      onTap: onClear,
                      child: const Icon(
                        Icons.close_rounded,
                        color: NetflixColors.textSecondary,
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: NetflixSpacing.md,
            vertical: NetflixSpacing.sm + 2,
          ),
        ),
      ),
    );
  }
}

/// Grid of search result movie cards.
class _SearchResultsGrid extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie) onMovieTap;

  const _SearchResultsGrid({required this.movies, required this.onMovieTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: NetflixSpacing.sectionPadding,
        vertical: NetflixSpacing.sm,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.67,
        crossAxisSpacing: NetflixSpacing.sm,
        mainAxisSpacing: NetflixSpacing.sm,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () => onMovieTap(movie),
          child: Hero(
            tag: 'search-${movie.id}',
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(NetflixSpacing.cardBorderRadius),
              child: Image.network(
                movie.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(color: NetflixColors.surfaceLight);
                },
                errorBuilder: (_, __, ___) =>
                    Container(color: NetflixColors.surfaceLight),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// List tile for top searches / browse state.
class _SearchListTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const _SearchListTile({required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: NetflixSpacing.sectionPadding,
          vertical: NetflixSpacing.xs,
        ),
        height: 70,
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                movie.imageUrl,
                width: 120,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: NetflixColors.surfaceLight, width: 120),
              ),
            ),

            const SizedBox(width: NetflixSpacing.md),

            // Title + rating
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    style: NetflixTextStyles.movieTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 12, color: NetflixColors.ratingGold),
                      const SizedBox(width: 2),
                      Text(movie.ratingString, style: NetflixTextStyles.rating.copyWith(fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),

            // Play icon
            const Icon(
              Icons.play_circle_outline_rounded,
              color: NetflixColors.textSecondary,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
