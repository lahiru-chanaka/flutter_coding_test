import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late final UserProvider userService;
  late User user;

  @override
  void initState() {
    userService = context.read<UserProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) => userService.fetchUser(widget.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfileServiceState>(
      stream: userService.userServiceState,
      builder: (context, snapshot) {
        if (snapshot.data is UserProfileSuccess) {
          user = (snapshot.data as UserProfileSuccess).user;
        }
        return Scaffold(
          appBar: AppBar(title: const Text('User Profile')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (snapshot.data is UserProfileLoading) ...[
                  CircularProgressIndicator(),
                ] else if (snapshot.data is UserProfileError) ...[
                  Text(
                    (snapshot.data as UserProfileError).message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ] else if (snapshot.data is UserProfileSuccess) ...[
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
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => userService.fetchUser(widget.userId),
            tooltip: 'Refresh',
            child: const Icon(Icons.refresh),
          ),
        );
      },
    );
  }
}
