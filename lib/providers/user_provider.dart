import 'dart:async';

import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../repositories/user_repository.dart';

/// Represents the abstract base class for all user profile service states.
sealed class UserProfileServiceState {}

/// State when user profile fetch has been initiated yet
class UserProfileInitial extends UserProfileServiceState {}

/// State when a user profile fetch is currently in progress
class UserProfileLoading extends UserProfileServiceState {}

/// State when success with user profile fetch
class UserProfileSuccess extends UserProfileServiceState {
  final User user;
  UserProfileSuccess(this.user);
}

/// State when an error occurs during user profile fetch
class UserProfileError extends UserProfileServiceState {
  final String message;
  UserProfileError(this.message);
}

class UserProvider extends UserRepository with ChangeNotifier {
  /// A stream controller for managing the state of the user profile service.
  final StreamController<UserProfileServiceState>
  _userProfileServiceStateController =
      StreamController<UserProfileServiceState>.broadcast();

  /// Returns a stream of [UserProfileServiceState] objects representing the state of the user profile service.
  Stream<UserProfileServiceState> get userServiceState =>
      _userProfileServiceStateController.stream;

  /// The service class for managing user profiles.
  /// This class provides methods for retrieving and updating user profiles.
  /// The [_userProfile] variable holds the current user's profile information.
  User? _user;

  User? get user => _user;

  /// Fetches user data from the API.
  ///
  /// This will update the provider's [status] to [UserStatus.loading] while the data is being fetched,
  /// and then either [UserStatus.success] or [UserStatus.error] after the data has been fetched.
  ///
  /// If the data is successfully fetched, the provider's [user] is updated with the fetched data.
  /// If the data could not be fetched, the provider's [error] is updated with the error message.
  ///
  /// This method notifies its listeners at the start and end of the fetch operation.
  Future<void> fetchUser(String userId) async {
    _userProfileServiceStateController.add(UserProfileLoading());
    try {
      final response = await getUser(userId);
      _user = response;
      _userProfileServiceStateController.add(UserProfileSuccess(response));
    } on Exception catch (e) {
      _userProfileServiceStateController.add(UserProfileError(e.toString()));
    }
    notifyListeners();
  }
}
