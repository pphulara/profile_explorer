import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.pictureUrl,
    required super.age,
    required super.city,
    required super.country,
    required super.email,
    required super.phone,
    super.isLiked,
  });

  factory UserModel.fromJson(Map json) {
    return UserModel(
      id: json['login']['uuid'],
      firstName: json['name']['first'],
      lastName: json['name']['last'],
      pictureUrl: json['picture']['large'],
      age: json['dob']['age'],
      city: json['location']['city'],
      country: json['location']['country'],
      email: json['email'],
      phone: json['phone'],
      isLiked: false,
    );
  }

  Map toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'pictureUrl': pictureUrl,
      'age': age,
      'city': city,
      'country': country,
      'email': email,
      'phone': phone,
      'isLiked': isLiked,
    };
  }
}