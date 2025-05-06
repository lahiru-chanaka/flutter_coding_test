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

  /// Fetches the user profile with the given [userId] from the API.
  ///
  /// Sends a GET request to the endpoint `'/users/$userId'`.
  /// If the request is successful (HTTP status code 200),
  /// it returns a [User] object parsed from the JSON response.
  /// If the request fails, it throws an [HttpException] with an error message
  /// including the status code.
  /// Any other errors during the operation will result in a general [Exception].
  ///
  /// The [userServiceState] stream is updated with one of the following states:
  /// - [UserProfileLoading] when the request is in progress
  /// - [UserProfileSuccess] when the request is successful
  /// - [UserProfileError] when any error occurs during the request
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
