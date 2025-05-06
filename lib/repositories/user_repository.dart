
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/models.dart';

/// A repository class responsible for fetching user data from an external API.
///
/// This class abstracts away HTTP logic and provides a clean interface
/// for the app to retrieve [User] models. Uses [https://jsonplaceholder.typicode.com]
/// as the mock backend.
class UserRepository {
  final http.Client _client;
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  UserRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches a user by their unique [userId] from the API.
  ///
  /// Sends a GET request to the endpoint `'/users/$userId'`.
  /// If the request is successful (HTTP status code 200),
  /// it returns a [User] object parsed from the JSON response.
  /// If the request fails, it throws an [HttpException] with an error message
  /// including the status code.
  /// Any other errors during the operation will result in a general [Exception].
  Future<User> getUser(String userId) async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/users/$userId'));

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));

      } else {
        throw HttpException('Failed to load user data. Status Code: ${response.statusCode}');
      }

    } on HttpException {
      rethrow;

    } catch (e) {
      throw Exception('An error occurred while fetching user data: $e');
    }
  }

  /// Closes the underlying HTTP client.
  /// Call this method when you're done with the repository to free up resources.
  /// This is a no-op if the repository is already disposed.
  void dispose() {
    _client.close();
  }
}

