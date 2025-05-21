class Doctor {
  final String firstName;
  final String lastName;
  final String specialty;
  final double rating;
  final int reviews;
  final String distance;
  final String? imageUrl;
  final String? id;
  final String? email;
  final String? phone;
  final String? address;

  Doctor({
    required this.firstName,
    required this.lastName,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.distance,
    this.imageUrl,
    this.id,
    this.email,
    this.phone,
    this.address,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    // Handle the case where we might receive a full name or separate first/last names
    String firstName = json['firstName'] ?? '';
    String lastName = json['lastName'] ?? '';

    // If we have a name but not firstName/lastName (for backward compatibility)
    if ((firstName.isEmpty || lastName.isEmpty) && json['name'] != null) {
      List<String> nameParts = (json['name'] as String).split(' ');
      if (nameParts.isNotEmpty) {
        firstName = firstName.isNotEmpty ? firstName : nameParts[0];
        // Join the rest as last name if there are multiple parts
        lastName = lastName.isNotEmpty ? lastName :
        (nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '');
      }
    }

    return Doctor(
      id: json['id']?.toString(),
      firstName: firstName,
      lastName: lastName,
      specialty: json['specialty'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviews: json['reviews'] ?? 0,
      distance: json['distance']?.toString() ?? '0.0',
      imageUrl: json['imageUrl'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'specialty': specialty,
      'rating': rating,
      'reviews': reviews,
      'distance': distance,
      'imageUrl': imageUrl,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  // Helper method to get full name
  String get fullName => '$firstName $lastName'.trim();
}