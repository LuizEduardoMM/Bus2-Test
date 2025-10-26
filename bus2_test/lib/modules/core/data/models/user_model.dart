import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.uuid,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    required super.pictureLarge,
    required super.city,
    required super.state,
    required super.country,
    required super.gender,
    required super.age,
    required super.nationality,
    required super.street,
    required super.streetNumber,
    required super.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? {};
    final location = json['location'] ?? {};
    final picture = json['picture'] ?? {};
    final login = json['login'] ?? {};
    final dob = json['dob'] ?? {};
    final street = location['street'] ?? {};

    return UserModel(
      uuid: login['uuid'] ?? '',
      firstName: name['first'] ?? '',
      lastName: name['last'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      pictureLarge: picture['large'] ?? '',
      city: location['city'] ?? '',
      state: location['state'] ?? '',
      country: location['country'] ?? '',
      gender: json['gender'] ?? '',
      age: dob['age'] ?? 0,
      nationality: json['nat'] ?? '',
      street: street['name'] ?? '',
      streetNumber: street['number'] ?? 0,
      username: login['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login': {'uuid': uuid, 'username': username},
      'name': {'first': firstName, 'last': lastName},
      'email': email,
      'phone': phone,
      'picture': {'large': pictureLarge},
      'location': {
        'city': city,
        'state': state,
        'country': country,
        'street': {'name': street, 'number': streetNumber},
      },
      'gender': gender,
      'dob': {'age': age},
      'nat': nationality,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      uuid: user.uuid,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      phone: user.phone,
      pictureLarge: user.pictureLarge,
      city: user.city,
      state: user.state,
      country: user.country,
      gender: user.gender,
      age: user.age,
      nationality: user.nationality,
      street: user.street,
      streetNumber: user.streetNumber,
      username: user.username,
    );
  }
}
