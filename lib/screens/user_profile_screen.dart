import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<UserProvider>().fetchUser(userId),
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  /// Builds the user profile screen body, which may display one of the following states:
  ///
  /// - A loading indicator if the user profile is being fetched
  /// - An error message if there was an error fetching the user profile
  /// - The user profile information if the user profile was fetched successfully
  /// - Nothing if the user profile has not been fetched yet
  Widget _buildBody(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<UserProvider>().status == UserStatus.initial) {
        context.read<UserProvider>().fetchUser(userId);
      }
    });

    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        return Center(
          child: switch (provider.status) {
            UserStatus.loading => const CircularProgressIndicator(),
            UserStatus.error => _buildError(provider.error),
            UserStatus.success => _buildUserProfile(context, provider.user!),
            UserStatus.initial => const SizedBox.shrink(),
          },
        );
      },
    );
  }

  /// Builds an error message widget if there was an error fetching the user profile.
  ///
  /// If [error] is null, it displays a generic error message.
  /// Otherwise, it displays the error message.
  Widget _buildError(String? error) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        error ?? 'An unknown error occurred',
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Builds a user profile widget from the given [User].
  ///
  /// The widget displays the user's name, email, phone number, and website.
  ///
  /// The widget is padded by 16 device pixels on all sides, and is centered horizontally.
  /// The user's name is displayed in a headline-small font, and the other user information is
  /// displayed in the default font.
  Widget _buildUserProfile(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name: ${user.name}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Email: ${user.email}'),
          const SizedBox(height: 8),
          Text('Phone: ${user.phone}'),
          const SizedBox(height: 8),
          Text('Website: ${user.website}'),
        ],
      ),
    );
  }
}