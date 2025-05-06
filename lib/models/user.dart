/// Immutable data model representing a user.
///
/// - All fields are `final`, making the class immutable and thread-safe.
/// - Includes a [fromJson] factory constructor for easy deserialization from JSON responses.
/// - Provides null safety and default fallbacks (e.g. 'N/A') to prevent runtime errors from missing fields.
/// - Overrides [==] and [hashCode] for value equality—essential when using collections or state management.
/// - Overrides [toString] for easier debugging and logging.
///
/// - Avoid using `as Type` directly unless the source is trusted; use type checking when parsing untrusted JSON.
/// - If optional fields are expected, make the corresponding fields nullable instead of defaulting silently.
class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'N/A',
      email: json['email'] as String? ?? 'N/A',
      phone: json['phone'] as String? ?? 'N/A',
      website: json['website'] as String? ?? 'N/A',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          phone == other.phone &&
          website == other.website;

  @override
  int get hashCode => Object.hash(id, name, email, phone, website);

  @override
  String toString() =>
      'User(id: $id, name: $name, email: $email, phone: $phone, website: $website)';
}
