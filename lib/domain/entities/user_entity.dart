class UserEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String pictureUrl;
  final int age;
  final String city;
  final String country;
  final String email;
  final String phone;
  bool isLiked;

  UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.pictureUrl,
    required this.age,
    required this.city,
    required this.country,
    required this.email,
    required this.phone,
    this.isLiked = false,
  });

  String get fullName => '$firstName $lastName';
  String get location => '$city, $country';
}