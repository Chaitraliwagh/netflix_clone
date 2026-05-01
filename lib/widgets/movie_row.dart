import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/movie.dart';
import '../utils/constants.dart';
import 'movie_card.dart';

/// A labeled horizontal scrolling row of movie poster cards.
/// Used for each category section on the Home screen.
class MovieRow extends StatelessWidget {
  final Category category;
  final Function(Movie) onMovieTap;

  const MovieRow({
    super.key,
    required this.category,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    if (category.movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NetflixSpacing.sectionPadding,
          ),
          child: Text(
            category.name,
            style: NetflixTextStyles.sectionTitle,
          ),
        ),

        const SizedBox(height: NetflixSpacing.sm),

        // Horizontal scrolling poster list
        SizedBox(
          height: NetflixSpacing.cardHeight + 12, // +12 for progress bar space
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: NetflixSpacing.sectionPadding,
            ),
            itemCount: category.movies.length,
            itemBuilder: (context, index) {
              final movie = category.movies[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < category.movies.length - 1
                      ? NetflixSpacing.sm
                      : 0,
                ),
                child: MovieCard(
                  movie: movie,
                  onTap: () => onMovieTap(movie),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
