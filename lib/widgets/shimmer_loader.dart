import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/constants.dart';

/// Displays a shimmer loading skeleton that mimics the home screen layout.
/// Shown while data is being fetched from the service.
class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: NetflixColors.shimmerBase,
      highlightColor: NetflixColors.shimmerHighlight,
      period: const Duration(milliseconds: 1200),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner placeholder
            Container(
              height: NetflixSpacing.bannerHeight,
              width: double.infinity,
              color: NetflixColors.shimmerBase,
            ),

            const SizedBox(height: NetflixSpacing.lg),

            // Three row placeholders
            ..._buildRowShimmers(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRowShimmers() {
    return List.generate(3, (rowIndex) {
      return Padding(
        padding: const EdgeInsets.only(bottom: NetflixSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title placeholder
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NetflixSpacing.sectionPadding,
              ),
              child: Container(
                height: 18,
                width: 150,
                decoration: BoxDecoration(
                  color: NetflixColors.shimmerBase,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            const SizedBox(height: NetflixSpacing.sm),

            // Card row placeholder
            SizedBox(
              height: NetflixSpacing.cardHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: NetflixSpacing.sectionPadding,
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: NetflixSpacing.sm),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          NetflixSpacing.cardBorderRadius),
                      child: Container(
                        width: NetflixSpacing.cardWidth,
                        height: NetflixSpacing.cardHeight,
                        color: NetflixColors.shimmerBase,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

/// A shimmer placeholder for the search results grid.
class SearchShimmer extends StatelessWidget {
  const SearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: NetflixColors.shimmerBase,
      highlightColor: NetflixColors.shimmerHighlight,
      child: GridView.builder(
        padding: const EdgeInsets.all(NetflixSpacing.sectionPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.67,
          crossAxisSpacing: NetflixSpacing.sm,
          mainAxisSpacing: NetflixSpacing.sm,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius:
                BorderRadius.circular(NetflixSpacing.cardBorderRadius),
            child: Container(color: NetflixColors.shimmerBase),
          );
        },
      ),
    );
  }
}
