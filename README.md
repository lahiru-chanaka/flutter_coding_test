# Flutter Developer Coding Test

## Objective
This test evaluates your ability to build robust, maintainable, and performant Flutter applications using modern techniques and best practices. It assesses your understanding of recent Flutter/Dart updates, advanced asynchronous programming with Streams and RxDart, and overall code quality, with a focus on using Provider for state management.

## Project Structure
```
lib/
├── main.dart              # Application entry point with navigation
├── models/
│   └── user.dart          # User model class (Part 3)
├── providers/
│   ├── search_provider.dart  # Provider for search functionality (Part 2)
│   └── user_provider.dart    # Provider for user profile (Part 3)
├── repositories/
│   └── user_repository.dart  # User data repository (Part 3)
├── screens/
│   ├── search_screen.dart    # Search implementation (Part 2)
│   ├── settings_screen.dart  # Cupertino widgets (Part 1)
│   └── user_profile_screen.dart  # Screen to refactor (Part 3)
├── services/
│   └── search_service.dart   # Mock search service (Part 2)
└── widgets/
    # Add any custom widgets you create
```

## Setup and Instructions
1. The project is already set up with the necessary structure and required dependencies:
   - rxdart, provider, and http packages are included in pubspec.yaml
   - Flutter SDK is set to the latest stable version

2. To begin developing, simply run:
   ```
   flutter pub get
   flutter run
   ```

3. Navigate the app using the home screen buttons to access each part of the test.

4. Complete each of the three parts by implementing code at the marked TODO locations.

## Test Parts

### Part 1: Leveraging Recent Flutter Updates (Flutter 3.29+)
**Files to modify:** `lib/screens/settings_screen.dart`

Implement a settings screen with iOS-style design features:
- Use CupertinoSliverNavigationBar that displays a large title when expanded
- Add a CupertinoSearchTextField as the bottom widget
- Configure the search field to hide when scrolling down
- Make the navigation bar snap between expanded and collapsed states
- Implement a "View Terms & Conditions" button that presents a modal sheet using showCupertinoSheet
- (Bonus) Apply a custom visual effect to the profile card section using ImageFilter.shader

### Part 2: Advanced Reactive Programming with Streams & RxDart
**Files to modify:** 
- `lib/services/search_service.dart` - Create a mock search service
- `lib/providers/search_provider.dart` - Implement reactive search using RxDart
- `lib/screens/search_screen.dart` - Build the search UI connected to provider

Requirements:
- Create a mock service that simulates API fetching with delay
- Use StreamController or BehaviorSubject to manage search queries
- Apply RxDart operators (debounceTime, distinct, switchMap)
- Handle errors within the stream pipeline
- Connect the stream states to Provider for UI updates
- Show appropriate UI for loading, success, error, and empty states

### Part 3: Code Refactoring & Best Practices
**Files to modify:**
- `lib/models/user.dart` - Create a User model class
- `lib/repositories/user_repository.dart` - Extract data fetching logic
- `lib/providers/user_provider.dart` - Implement state management
- `lib/screens/user_profile_screen.dart` - Clean up the UI component

The original code is provided in `user_profile_screen.dart`. Refactor it to:
- Separate concerns by extracting data fetching to a repository
- Replace setState with Provider state management
- Use dependency injection with Provider
- Implement robust error handling
- Create a proper User model with fromJson constructor
- Improve readability and maintainability

## Evaluation Criteria
Your solution will be evaluated based on:
- Correctness: Does the application meet all functional requirements?
- Code Quality: Is the code clean, readable, and maintainable?
- Best Practices: Are Flutter and Dart best practices followed?
- Architecture: Is there a clear separation of concerns?
- State Management: Is Provider used effectively?
- Streams/RxDart: Is the reactive programming logic implemented correctly?
- API Knowledge: Is there demonstrated understanding of specified Flutter APIs?
- Error Handling: Are potential errors handled gracefully?

## Submission
Provide a link to a Git repository containing your solution (GitHub or Bitbucket). Ensure the commit history reflects your development process.

Good luck!
