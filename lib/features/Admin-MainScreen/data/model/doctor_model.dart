import 'dart:io';

class DoctorAdmin {
  final int id;
  final String firstName;
  final String email;
  final String gender;
  final String lastName;
  final String specialist;
  final String city;
  final String country;
  final String fullAddress;
  final String description;
  final File? image;

  DoctorAdmin({
    required this.id,
    required this.firstName,
    required this.email,
    required this.gender,
    required this.lastName,
    required this.specialist,
    required this.city,
    required this.country,
    required this.fullAddress,
    required this.description,
    required this.image,
  });

  factory DoctorAdmin.fromJson(Map<String, dynamic> json) {
    return DoctorAdmin(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      email: json['email'] ?? '',
      gender: json['Gender'] ?? '',
      lastName: json['lastName'] ?? '',
      specialist: json['specialist'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      fullAddress: json['fullAddress'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }
} 
