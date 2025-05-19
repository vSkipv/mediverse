class SearchRequest {
  final String specialist;
  final String country;
  final String city;

  SearchRequest({
    required this.specialist,
    required this.country,
    required this.city,
  });

  Map<String, dynamic> toJson() {
    return {
      'specialist': specialist,
      'country': country,
      'city': city,
    };
  }
} 