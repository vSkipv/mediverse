class Doctor {
  final String name;
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
    required this.name,
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
    return Doctor(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
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
      'name': name,
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
} 