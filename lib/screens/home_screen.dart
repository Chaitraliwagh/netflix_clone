import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../utils/constants.dart';
import '../widgets/featured_banner.dart';
import '../widgets/movie_row.dart';
import '../widgets/netflix_app_bar.dart';
import '../widgets/shimmer_loader.dart';
import 'movie_detail_screen.dart';

/// The main home screen of the Netflix app.
/// Displays:
/// - Auto-scrolling featured banner carousel
/// - Multiple horizontal category rows
/// - Shimmer loading state while fetching
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load data after the first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MovieProvider>();
      if (!provider.isLoaded) {
        provider.loadData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToDetail(Movie movie) {
    context.read<MovieProvider>().selectMovie(movie);
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MovieDetailScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await context.read<MovieProvider>().refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NetflixColors.background,
      extendBodyBehindAppBar: true,
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          if (provider.status == LoadingStatus.loading) {
            return const HomeShimmer();
          }

          if (provider.status == LoadingStatus.error) {
            return _buildErrorState(provider);
          }

          return Stack(
            children: [
              // Main scrollable content
              RefreshIndicator(
                onRefresh: _onRefresh,
                color: NetflixColors.primary,
                backgroundColor: NetflixColors.surface,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Featured carousel banner (full height, no top padding)
                      FeaturedBanner(
                        movies: provider.featuredMovies,
                        onMovieTap: _navigateToDetail,
                      ),

                      const SizedBox(height: NetflixSpacing.lg),

                      // Dynamic category rows
                      ...provider.categories.map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: NetflixSpacing.xl),
                          child: MovieRow(
                            category: category,
                            onMovieTap: _navigateToDetail,
                          ),
                        ),
                      ),

                      // Bottom padding for nav bar
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),

              // Scroll-aware overlay app bar
              ScrollAwareAppBar(scrollController: _scrollController),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorState(MovieProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(NetflixSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              color: NetflixColors.textMuted,
              size: 60,
            ),
            const SizedBox(height: NetflixSpacing.md),
            Text(
              provider.errorMessage,
              style: NetflixTextStyles.bannerSubtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: NetflixSpacing.lg),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: NetflixColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: NetflixSpacing.xl,
                  vertical: NetflixSpacing.sm,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: provider.loadData,
              child: const Text(
                'Try Again',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
