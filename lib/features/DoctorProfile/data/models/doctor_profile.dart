class DoctorProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String description;
  final String city;
  final String country;
  final String fullAddress;
  final String specialist;
  DoctorProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.description,
    required this.city,
    required this.country,
    required this.fullAddress,
    required this.specialist,
  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    return DoctorProfile(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      description: json['description'],
      city: json['city'],
      country: json['country'],
      fullAddress: json['fullAddress'],
      specialist: json['specialist'],
    );
  }
}