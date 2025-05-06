import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../repositories/user_repository.dart';

enum UserStatus { initial, loading, success, error }

class UserProvider extends UserRepository with ChangeNotifier  {
  
  User? _user;
  UserStatus _status = UserStatus.initial;
  String? _error;

  UserProvider();

  User? get user => _user;
  UserStatus get status => _status;
  String? get error => _error;
  bool get isLoading => _status == UserStatus.loading;

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
    _status = UserStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _user = await getUser(userId);
      _status = UserStatus.success;
    } catch (e) {
      _error = e.toString();
      _status = UserStatus.error;
    }
    
    notifyListeners();
  }
}
