import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../utils/constants.dart';

/// Full-screen movie/show detail page.
/// Features:
/// - Hero image transition from poster/banner
/// - Gradient overlay on full-bleed image
/// - Title, description, rating, year, duration
/// - Netflix-style Play + Download buttons
/// - Genre tags
/// - Smooth scroll content below the fold
class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movie = context.watch<MovieProvider>().selectedMovie;

    if (movie == null) {
      return const Scaffold(
        backgroundColor: NetflixColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: NetflixColors.background,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          // Collapsing hero header
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: NetflixColors.background,
            leading: _BackButton(),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _HeroBanner(movie: movie),
              collapseMode: CollapseMode.pin,
            ),
          ),

          // Scrollable content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NetflixSpacing.sectionPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: NetflixSpacing.md),

                  // Title
                  Text(movie.title, style: NetflixTextStyles.detailTitle),

                  const SizedBox(height: NetflixSpacing.sm),

                  // Metadata row
                  _MetadataRow(movie: movie),

                  const SizedBox(height: NetflixSpacing.md),

                  // Genre tags
                  Wrap(
                    spacing: NetflixSpacing.xs,
                    runSpacing: NetflixSpacing.xs,
                    children: movie.genre.map((g) => _Tag(label: g)).toList(),
                  ),

                  const SizedBox(height: NetflixSpacing.md),

                  // Description
                  Text(
                    movie.description,
                    style: NetflixTextStyles.detailBody,
                  ),

                  const SizedBox(height: NetflixSpacing.lg),

                  // Action buttons
                  _ActionButtons(movie: movie),

                  const SizedBox(height: NetflixSpacing.xl),

                  // More like this / cast sections (static UI)
                  _SectionHeader(title: 'More Details'),
                  const SizedBox(height: NetflixSpacing.sm),
                  _DetailRow(
                      label: 'Year', value: '${movie.year}'),
                  _DetailRow(
                      label: 'Duration', value: movie.duration),
                  _DetailRow(
                      label: 'Rating', value: '${movie.ratingString} / 10'),
                  _DetailRow(
                      label: 'Genres', value: movie.genreString),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-bleed hero image with gradient overlay.
class _HeroBanner extends StatelessWidget {
  final Movie movie;
  const _HeroBanner({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Hero image — matches the tag used in the poster card
        Hero(
          tag: 'movie-${movie.id}',
          child: Image.network(
            movie.bannerUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: NetflixColors.surface),
          ),
        ),

        // Bottom gradient fade
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                  NetflixColors.background,
                ],
                stops: const [0.0, 0.3, 0.75, 1.0],
              ),
            ),
          ),
        ),

        // Top gradient for status bar readability
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 100,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Metadata row: rating, year, duration.
class _MetadataRow extends StatelessWidget {
  final Movie movie;
  const _MetadataRow({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded,
            color: NetflixColors.ratingGold, size: 18),
        const SizedBox(width: 4),
        Text(movie.ratingString, style: NetflixTextStyles.rating),
        const SizedBox(width: NetflixSpacing.md),
        _MetaChip(text: '${movie.year}'),
        const SizedBox(width: NetflixSpacing.sm),
        _MetaChip(text: movie.duration),
        if (movie.isTrending) ...[
          const SizedBox(width: NetflixSpacing.sm),
          _MetaChip(
            text: '🔥 Trending',
            isHighlighted: true,
          ),
        ],
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String text;
  final bool isHighlighted;
  const _MetaChip({required this.text, this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isHighlighted
            ? NetflixColors.primary.withOpacity(0.2)
            : NetflixColors.surfaceLight,
        borderRadius: BorderRadius.circular(4),
        border: isHighlighted
            ? Border.all(color: NetflixColors.primary.withOpacity(0.4))
            : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isHighlighted
              ? NetflixColors.primary
              : NetflixColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Genre tag chip.
class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: NetflixColors.textMuted),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: NetflixColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

/// Play, Download, My List, Rate action buttons.
class _ActionButtons extends StatelessWidget {
  final Movie movie;
  const _ActionButtons({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary Play button (full width)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.play_arrow_rounded, size: 26),
            label: const Text(
              'Play',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),

        const SizedBox(height: NetflixSpacing.sm),

        // Secondary Download button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: NetflixColors.surfaceLight,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.download_rounded, size: 22),
            label: const Text(
              'Download',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: NetflixSpacing.md),

        // Icon row: Add, Like, Share
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _IconAction(icon: Icons.add, label: 'My List'),
            _IconAction(icon: Icons.thumb_up_outlined, label: 'Rate'),
            _IconAction(icon: Icons.share_outlined, label: 'Share'),
          ],
        ),
      ],
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: NetflixColors.textSecondary, size: 26),
        const SizedBox(height: 4),
        Text(label, style: NetflixTextStyles.caption),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: NetflixTextStyles.sectionTitle);
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: NetflixTextStyles.caption.copyWith(
                color: NetflixColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: NetflixTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}

/// Back button with semi-transparent background.
class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}
