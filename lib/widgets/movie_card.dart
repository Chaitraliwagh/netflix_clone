import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../utils/constants.dart';

/// A tappable movie poster card with:
/// - Hero animation for smooth detail transitions
/// - Scale animation on tap
/// - Image shadow + rounded corners
/// - Optional progress bar for "Continue Watching"
class MovieCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.width = NetflixSpacing.cardWidth,
    this.height = NetflixSpacing.cardHeight,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();
  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: widget.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster image with hero animation
              Hero(
                tag: 'movie-${widget.movie.id}',
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(NetflixSpacing.cardBorderRadius),
                    boxShadow: const [
                      BoxShadow(
                        color: NetflixColors.cardShadow,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(NetflixSpacing.cardBorderRadius),
                    child: Image.network(
                      widget.movie.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _buildImagePlaceholder();
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImageError();
                      },
                    ),
                  ),
                ),
              ),

              // Progress bar for "Continue Watching"
              if (widget.movie.isContinueWatching &&
                  widget.movie.watchProgress > 0) ...[
                const SizedBox(height: NetflixSpacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: widget.movie.watchProgress,
                    backgroundColor: NetflixColors.surfaceLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        NetflixColors.primary),
                    minHeight: 3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: NetflixColors.surfaceLight,
      child: const Center(
        child: Icon(
          Icons.movie_outlined,
          color: NetflixColors.textMuted,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      color: NetflixColors.surfaceLight,
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: NetflixColors.textMuted,
          size: 32,
        ),
      ),
    );
  }
}
