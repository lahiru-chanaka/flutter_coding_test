import 'dart:async';
import 'dart:math';
import 'dart:developer' as developer;
import '../models/models.dart';

class SearchService {
  static const Duration _baseDelay = Duration(milliseconds: 500);
  final Random _random = Random();

  /// Simulates a product search with an artificial delay.
  /// Returns a filtered list of mock data that matches the [query].
  /// Returns an empty list if [query] is empty.
  /// Has a 10% chance to throw an error for testing error handling.
  Future<List<String>> searchProducts(String query) async {
    try {
      /// Simulate network delay with slight randomness
      final delay = _baseDelay + Duration(milliseconds: _random.nextInt(800));
      await Future.delayed(delay);

      /// Simulate random error (10% chance)
      if (_random.nextDouble() < 0.1) {
        throw Exception('Failed to fetch search results.');
      }

      /// Return empty list if query is empty
      if (query.trim().isEmpty) {
        return [];
      }

      /// Filter mock data by case-insensitive query
      return mockData
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e, stackTrace) {
      /// Log the error (optional: use a logger)
      developer.log(
        'SearchService error',
        error: e,
        stackTrace: stackTrace,
        name: 'SearchService',
      );

      /// Rethrow so the UI can handle it
      rethrow;
    }
  }
}
