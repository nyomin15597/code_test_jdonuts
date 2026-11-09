class UserModel {
  const UserModel({
    required this.phone,
    this.firstName = '',
    this.lastName = '',
    this.dob = '',
  });

  final String phone;
  final String firstName;
  final String lastName;
  final String dob;

  factory UserModel.fromMap(Map<String, Object?> map) {
    return UserModel(
      phone: map['phone'] as String,
      firstName: map['first_name'] as String? ?? '',
      lastName: map['last_name'] as String? ?? '',
      dob: map['dob'] as String? ?? '',
    );
  }

  Map<String, Object?> toMap() => {
    'phone': phone,
    'first_name': firstName,
    'last_name': lastName,
    'dob': dob,
  };
}
