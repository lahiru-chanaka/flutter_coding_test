import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

/// A screen that provides a real-time search interface with dynamic results.
///
/// This widget uses [SearchProvider] for business logic and handles search
/// states (initial, loading, success, error, empty) using a [StreamBuilder].
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  /// Initializes the text controller and resets the search state once the widget tree
  /// is built.
  ///
  /// This is done to ensure that the search state is reset to its initial state only
  /// after the widget tree is built and the [SearchProvider] is available.
  /// * [SearchProvider.resetState]
  @override
  void initState() {
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().resetState();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Type for search',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                context.read<SearchProvider>().updateSearch(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<SearchState>(
                stream: context.read<SearchProvider>().searchResults,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Start typing to search'));
                  }
                  final state = snapshot.data!;
                  return switch (state) {
                    SearchInitial() => const Center(
                      child: Text('Start typing to search'),
                    ),
                    SearchLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    SearchSuccess(results: final results) => ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(results[index]),
                            leading: const Icon(Icons.article),
                            onTap: () {},
                          );
                        },
                      ),
                    SearchError(message: final message) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error: $message',
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (_searchController.text.isNotEmpty) {
                                  context.read<SearchProvider>().retrySearch();
                                }
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    SearchEmpty() => const Center(
                      child: Text('No results found'),
                    ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
