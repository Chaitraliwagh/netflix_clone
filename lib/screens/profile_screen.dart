import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// User profile screen with settings, account info, and app options.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NetflixColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  NetflixSpacing.sectionPadding,
                  NetflixSpacing.md,
                  NetflixSpacing.sectionPadding,
                  NetflixSpacing.lg,
                ),
                child: Text(
                  'Who\'s Watching?',
                  style: TextStyle(
                    color: NetflixColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              // Profile avatars
              _ProfileAvatarGrid(),

              const SizedBox(height: NetflixSpacing.xl),

              const Divider(color: NetflixColors.surfaceLight),

              // Settings sections
              _SettingsSection(
                title: 'Account & Settings',
                items: const [
                  _SettingsItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                  ),
                  _SettingsItem(
                    icon: Icons.download_outlined,
                    label: 'Downloads',
                  ),
                  _SettingsItem(
                    icon: Icons.security_outlined,
                    label: 'Privacy & Security',
                  ),
                  _SettingsItem(
                    icon: Icons.language_outlined,
                    label: 'Language',
                    value: 'English',
                  ),
                  _SettingsItem(
                    icon: Icons.high_quality_outlined,
                    label: 'Video Quality',
                    value: 'Auto',
                  ),
                ],
              ),

              _SettingsSection(
                title: 'Help & Support',
                items: const [
                  _SettingsItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Help Center',
                  ),
                  _SettingsItem(
                    icon: Icons.info_outline_rounded,
                    label: 'About Netflix',
                  ),
                ],
              ),

              // Sign out
              Padding(
                padding: const EdgeInsets.all(NetflixSpacing.sectionPadding),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: NetflixColors.textMuted),
                      foregroundColor: NetflixColors.textPrimary,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),

              const Center(
                child: Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: NetflixColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

/// Grid showing multiple user profiles.
class _ProfileAvatarGrid extends StatelessWidget {
  final List<_Profile> profiles = const [
    _Profile(name: 'You', color: Color(0xFF4169E1)),
    _Profile(name: 'Kids', color: Color(0xFF32CD32)),
    _Profile(name: 'Partner', color: Color(0xFFFF6347)),
    _Profile(name: '+ Add', color: NetflixColors.surfaceLight, isAdd: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: NetflixSpacing.sectionPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: profiles.map((p) => _ProfileAvatar(profile: p)).toList(),
      ),
    );
  }
}

class _Profile {
  final String name;
  final Color color;
  final bool isAdd;
  const _Profile(
      {required this.name, required this.color, this.isAdd = false});
}

class _ProfileAvatar extends StatelessWidget {
  final _Profile profile;
  const _ProfileAvatar({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: NetflixSpacing.lg),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: profile.color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: NetflixColors.surfaceLight,
                width: 1,
              ),
            ),
            child: Icon(
              profile.isAdd ? Icons.add : Icons.person_rounded,
              color: Colors.white,
              size: profile.isAdd ? 28 : 36,
            ),
          ),
          const SizedBox(height: NetflixSpacing.xs),
          Text(
            profile.name,
            style: const TextStyle(
              color: NetflixColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// A labeled group of settings items.
class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NetflixSpacing.sectionPadding,
            NetflixSpacing.md,
            NetflixSpacing.sectionPadding,
            NetflixSpacing.xs,
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: NetflixColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ),
        ...items,
        const Divider(color: NetflixColors.surfaceLight),
      ],
    );
  }
}

/// A single settings row with icon, label, and optional value.
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: NetflixColors.textSecondary, size: 22),
      title: Text(
        label,
        style: const TextStyle(
          color: NetflixColors.textPrimary,
          fontSize: 15,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(
              value!,
              style: const TextStyle(
                color: NetflixColors.textMuted,
                fontSize: 13,
              ),
            ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right_rounded,
            color: NetflixColors.textMuted,
            size: 20,
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: NetflixSpacing.sectionPadding,
      ),
      dense: true,
      onTap: () {},
    );
  }
}
