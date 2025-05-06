import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../services/search_service.dart';

/// Represents the base class for all possible search states
sealed class SearchState {}

/// State when no search has been initiated yet
class SearchInitial extends SearchState {}

/// State when a search is currently in progress
class SearchLoading extends SearchState {}

/// State when search completes with results
class SearchSuccess extends SearchState {
  final List<String> results;
  SearchSuccess(this.results);
}

/// State when an error occurs during search
class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

/// State when the search query is empty or no results found
class SearchEmpty extends SearchState {}

/// Manages the search logic, debounce, state transitions, and stream control
class SearchProvider extends ChangeNotifier {
  final SearchService _searchService;

  /// Controller to handle user search input
  final _searchController = BehaviorSubject<String>();

  /// Controller to emit the current search state
  final _resultsController = BehaviorSubject<SearchState>.seeded(SearchInitial());

  /// Exposes the stream of search state changes to the UI
  Stream<SearchState> get searchResults => _resultsController.stream;

  /// Exposes a function to push new queries into the search stream
  Function(String) get updateSearch => _searchController.sink.add;

  /// Constructor that optionally accepts a custom SearchService (e.g. for testing)
  SearchProvider({SearchService? searchService})
      : _searchService = searchService ?? SearchService() {
    // Listen to input queries:
    // - debounce to limit rapid input changes
    // - ensure only distinct values trigger search
    // - switchMap cancels previous search if a new one starts
    _searchController.stream
        .debounceTime(const Duration(milliseconds: 300))
        .distinct()
        .switchMap((query) => _performSearch(query))
        .listen(
          (state) => _resultsController.add(state),
          onError: (error) => _resultsController.add(SearchError(error.toString())),
        );
  }

  /// Performs the search logic, debouncing, and state transitions
  /// (loading -> success/empty/error)
  Stream<SearchState> _performSearch(String query) async* {
    if (query.isEmpty) {
      yield SearchEmpty();
      return;
    }

    yield SearchLoading();

    try {
      final results = await _searchService.searchProducts(query);
      if (results.isEmpty) {
        yield SearchEmpty();
      } else {
        yield SearchSuccess(results);
      }
    } catch (e) {
      yield SearchError(e.toString());
    }
  }

  /// Resets the search state to its initial state.
  ///
  /// This is useful when the user wants to start a new search from scratch.
  /// It will clear the current search results and reset the state to its
  /// initial state.
  void resetState() {
    _resultsController.add(SearchInitial());
  }

  /// Retry the current search query, if any.
  ///
  /// This is useful when the user wants to retry a search that previously failed.
  /// It will restart the search process from the current query, if any.
  void retrySearch() {
  final currentQuery = _searchController.valueOrNull;
  if (currentQuery != null && currentQuery.isNotEmpty) {
    _resultsController.addStream(_performSearch(currentQuery));
  }
}

  /// Closes all stream controllers to avoid memory leaks
  @override
  void dispose() {
    _searchController.close();
    _resultsController.close();
    super.dispose();
  }
}
