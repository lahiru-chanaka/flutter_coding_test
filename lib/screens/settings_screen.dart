import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

  /// Builds the settings screen with a CupertinoPageScaffold containing a
  /// CustomScrollView. The screen includes a navigation bar with a large title
  /// and a search text field, followed by a list of settings items. Each item
  /// can be tapped to perform an action, such as displaying a modal sheet for
  /// "Terms & Conditions". A shader effect is applied to the profile card
  /// section, creating a gradient effect for visual enhancement.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        child: CustomScrollView(
          slivers: [
            /// Navigation bar at the top of the screen
            CupertinoSliverNavigationBar(
              largeTitle: const Text('Settings'),
              stretch: true,
              alwaysShowMiddle: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CupertinoSearchTextField(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Placeholder settings items
                    _buildSettingsItem(
                      'Notifications',
                      CupertinoIcons.bell,
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      'Appearance',
                      CupertinoIcons.person,
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      'Privacy',
                      CupertinoIcons.lock,
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      'Terms & Conditions',
                      CupertinoIcons.doc_text,
                      onTap: () {
                        showCupertinoSheet(
                          context: context,
                          pageBuilder: (context) {
                            return CupertinoPageScaffold(
                              navigationBar: const CupertinoNavigationBar(
                                automaticallyImplyLeading: false,
                                middle: Text('Terms & Conditions'),
                              ),
                              child: SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 24,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'These are the placeholder terms and conditions. Please read them carefully before proceeding.',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Profile Card',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    /// Shader effect applied to a container to create a gradient effect
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.shade400,
                            Colors.blue.shade100,
                            Colors.blue.shade300,
                          ],
                        ).createShader(bounds);
                      },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Profile Card',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    String title,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: CupertinoColors.separator, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: CupertinoColors.activeBlue),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
