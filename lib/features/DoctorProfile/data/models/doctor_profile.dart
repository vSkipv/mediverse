class DoctorProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String description;
  final String city;
  final String country;
  final String fullAddress;
  final String specialist;
  final String? image;
  DoctorProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.description,
    required this.city,
    required this.country,
    required this.fullAddress,
    required this.specialist,
    this.image,
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
      image: _processImagePath(json['image']),
    );
  }

  // Helper method to process image paths
  static String? _processImagePath(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    String processedPath = imagePath;

    // Remove file:/// prefix if present
    if (processedPath.startsWith('file:///')) {
      processedPath = processedPath.substring(8); // Remove 'file:///'
    }

    // Ensure path starts with /
    if (!processedPath.startsWith('/')) {
      processedPath = '/$processedPath';
    }

    // Construct complete URL
    return 'http://projectmetaverse.runasp.net$processedPath';
  }
} 
