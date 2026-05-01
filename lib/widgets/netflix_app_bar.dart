import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// Netflix-style app bar that fades in a background on scroll.
/// Designed to overlay the hero banner at the top.
class NetflixAppBar extends StatelessWidget {
  final ScrollController? scrollController;
  final bool showBackground;

  const NetflixAppBar({
    super.key,
    this.scrollController,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: showBackground
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.9),
                  Colors.transparent,
                ],
              )
            : const LinearGradient(
                colors: [Colors.transparent, Colors.transparent],
              ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NetflixSpacing.sectionPadding,
            vertical: NetflixSpacing.sm,
          ),
          child: Row(
            children: [
              // Netflix logo text
              _NetflixLogo(),

              const Spacer(),

              // Cast icon
              IconButton(
                icon: const Icon(
                  Icons.cast_rounded,
                  color: NetflixColors.textPrimary,
                ),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),

              const SizedBox(width: NetflixSpacing.md),

              // Profile avatar
              _ProfileAvatar(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Red "N" Netflix logo approximation.
class _NetflixLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      'NETFLIX',
      style: TextStyle(
        color: NetflixColors.primary,
        fontSize: 22,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.0,
      ),
    );
  }
}

/// Circular user profile avatar.
class _ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xFF4169E1), // Blue profile color
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}

/// A scroll-aware variant of the app bar.
/// Fades in a dark background when the user scrolls down.
class ScrollAwareAppBar extends StatefulWidget {
  final ScrollController scrollController;

  const ScrollAwareAppBar({super.key, required this.scrollController});

  @override
  State<ScrollAwareAppBar> createState() => _ScrollAwareAppBarState();
}

class _ScrollAwareAppBarState extends State<ScrollAwareAppBar> {
  bool _showBackground = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final show = widget.scrollController.offset > 50;
    if (show != _showBackground) {
      setState(() => _showBackground = show);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: NetflixAppBar(showBackground: _showBackground),
    );
  }
}
