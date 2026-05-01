import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/movie.dart';
import '../utils/constants.dart';

/// Auto-scrolling banner carousel for featured movies.
/// Features:
/// - Full-screen gradient overlay
/// - Title, genre, rating display
/// - Play button with Netflix styling
/// - Page indicator dots
/// - Hero tag for smooth navigation
class FeaturedBanner extends StatefulWidget {
  final List<Movie> movies;
  final Function(Movie) onMovieTap;

  const FeaturedBanner({
    super.key,
    required this.movies,
    required this.onMovieTap,
  });

  @override
  State<FeaturedBanner> createState() => _FeaturedBannerState();
}

class _FeaturedBannerState extends State<FeaturedBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: [
        // Carousel
        CarouselSlider.builder(
          itemCount: widget.movies.length,
          itemBuilder: (context, index, realIndex) {
            return _BannerItem(
              movie: widget.movies[index],
              onTap: () => widget.onMovieTap(widget.movies[index]),
            );
          },
          options: CarouselOptions(
            height: NetflixSpacing.bannerHeight,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),

        // Page indicator dots
        Positioned(
          bottom: NetflixSpacing.md,
          left: 0,
          right: 0,
          child: Center(
            child: AnimatedSmoothIndicator(
              activeIndex: _currentIndex,
              count: widget.movies.length,
              effect: const WormEffect(
                dotColor: Color(0x66FFFFFF),
                activeDotColor: NetflixColors.primary,
                dotHeight: 6,
                dotWidth: 6,
                spacing: 6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Individual banner item within the carousel.
class _BannerItem extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const _BannerItem({
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Background image with Hero for smooth transition
          Hero(
            tag: 'movie-${movie.id}',
            child: SizedBox.expand(
              child: Image.network(
                movie.bannerUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(color: NetflixColors.surface);
                },
                errorBuilder: (_, __, ___) =>
                    Container(color: NetflixColors.surface),
              ),
            ),
          ),

          // Multi-layer gradient overlays for depth
          // Bottom gradient (main readability)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.85),
                    Colors.black,
                  ],
                  stops: const [0.0, 0.4, 0.75, 1.0],
                ),
              ),
            ),
          ),

          // Side vignette
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),

          // Content: title, metadata, buttons
          Positioned(
            bottom: 50,
            left: NetflixSpacing.sectionPadding,
            right: NetflixSpacing.sectionPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Genre tags
                Wrap(
                  spacing: NetflixSpacing.xs,
                  children: movie.genre
                      .take(3)
                      .map((g) => _GenreChip(genre: g))
                      .toList(),
                ),

                const SizedBox(height: NetflixSpacing.sm),

                // Title
                Text(
                  movie.title,
                  style: NetflixTextStyles.bannerTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: NetflixSpacing.xs),

                // Rating + Year + Duration
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: NetflixColors.ratingGold,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      movie.ratingString,
                      style: NetflixTextStyles.rating,
                    ),
                    const SizedBox(width: NetflixSpacing.md),
                    Text(
                      '${movie.year}',
                      style: NetflixTextStyles.caption,
                    ),
                    const SizedBox(width: NetflixSpacing.md),
                    Text(
                      movie.duration,
                      style: NetflixTextStyles.caption,
                    ),
                  ],
                ),

                const SizedBox(height: NetflixSpacing.md),

                // Buttons row
                Row(
                  children: [
                    // Play button
                    _PlayButton(onTap: onTap),
                    const SizedBox(width: NetflixSpacing.sm),
                    // My List button
                    _OutlineButton(
                      icon: Icons.add,
                      label: 'My List',
                    ),
                    const Spacer(),
                    // Info button
                    _InfoButton(onTap: onTap),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Netflix-style play button.
class _PlayButton extends StatelessWidget {
  final VoidCallback onTap;
  const _PlayButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: NetflixSpacing.lg,
          vertical: NetflixSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: NetflixColors.textPrimary,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_arrow_rounded,
              color: Colors.black,
              size: 22,
            ),
            SizedBox(width: 6),
            Text(
              'Play',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Secondary outline-style banner button.
class _OutlineButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _OutlineButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: NetflixSpacing.md,
        vertical: NetflixSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Info icon button in the banner.
class _InfoButton extends StatelessWidget {
  final VoidCallback onTap;
  const _InfoButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54, width: 1.5),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Info',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Genre tag chip displayed on the banner.
class _GenreChip extends StatelessWidget {
  final String genre;
  const _GenreChip({required this.genre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.white24, width: 0.5),
      ),
      child: Text(
        genre,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
