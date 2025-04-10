import 'package:flutter/material.dart';
import 'package:mediverse/features/DoctorProfile/presention/views/DoctorProfile.dart';


class HealthcareSearchApp extends StatelessWidget {
  const HealthcareSearchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SearchScreen();
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? selectedSpecialty;
  String? selectedState;
  String? selectedCity;

  // Specialties list
  final List<String> specialties = [
    'Ophthalmologist | عيون',
    'Pediatrician | اطفال',
    'Dentist | اسنان',
    'Orthopedic| عظام',
    'Cardiologist | قلب',
  ];

  // States list
  final List<String> states = [
    'Gharbia',
    'Cairo',
    'Giza',
    'Alx',
    'Qalyubia',
  ];

  // Cities based on state
  Map<String, List<String>> citiesByState = {
    'Gharbia': ['Tanta', 'Mahalla', 'Zifta'],
    'Cairo': ['Maadi', 'Nasr City', 'Heliopolis'],
    'Giza': ['Dokki', '6th October', 'Sheikh Zayed','Tahrir'],
    'Alx': ['Miami', 'Montaza', 'Sidi Gaber'],
    'Qalyubia': ['Banha', 'Obour',],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF4285F4),
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // Specialties Section
              const Padding(
                padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
                child: Text(
                  'Specialties',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    hintText: 'Select a specialtie',
                    hintStyle: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                    ),
                  ),
                  value: selectedSpecialty,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF9E9E9E),
                  ),
                  items: specialties.map((String specialty) {
                    return DropdownMenuItem(
                      value: specialty,
                      child: Text(specialty),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSpecialty = newValue;
                    });
                  },
                ),
              ),

              const SizedBox(height: 28),

              // State Section
              const Padding(
                padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
                child: Text(
                  'State',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    hintText: 'Select a region',
                    hintStyle: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                    ),
                  ),
                  value: selectedState,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF9E9E9E),
                  ),
                  items: states.map((String state) {
                    return DropdownMenuItem(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedState = newValue;
                      // Reset city when state changes
                      selectedCity = null;
                    });
                  },
                ),
              ),

              const SizedBox(height: 28),

              // City Section
              const Padding(
                padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
                child: Text(
                  'City',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    hintText: 'Select a region',
                    hintStyle: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                    ),
                  ),
                  value: selectedCity,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF9E9E9E),
                  ),
                  items: selectedState == null
                      ? []
                      : citiesByState[selectedState]!.map((String city) {
                    return DropdownMenuItem(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: selectedState == null
                      ? null
                      : (String? newValue) {
                    setState(() {
                      selectedCity = newValue;
                    });
                  },
                ),
              ),

              const Spacer(),

              // Next Button with Navigation
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate form fields
                    if (selectedSpecialty != null && selectedState != null && selectedCity != null) {
                      // Navigate to the next page when all fields are filled
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorListScreen(
                            specialty: selectedSpecialty!,
                            state: selectedState!,
                            city: selectedCity!,
                          ),
                        ),
                      );
                    } else {
                      // Show error message if any field is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please complete all fields'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 56),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// New screen to navigate to when Next button is pressed
class DoctorListScreen extends StatelessWidget {
  final String specialty;
  final String state;
  final String city;

  const DoctorListScreen({
    Key? key,
    required this.specialty,
    required this.state,
    required this.city,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF4285F4),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '$specialty Doctors',
          style: const TextStyle(color: Colors.black87),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildLocationHeader('$city, $state'),
          const SizedBox(height: 16),
          ...List.generate(
            5, // Generate 5 sample doctors
                (index) => _buildDoctorCard(
              context,
              name: 'Dr. John Smith ${index + 1}',
              specialty: specialty,
              rating: 4.5,
              reviews: 120 + (index * 10),
              distance: (1.5 + (index * 0.7)).toStringAsFixed(1),
              imageUrl: 'assets/images/doctor_placeholder.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationHeader(String location) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: Colors.blue.shade700,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            location,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.tune,
            color: Colors.blue.shade700,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            'Filter',
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(
      BuildContext context, {
        required String name,
        required String specialty,
        required double rating,
        required int reviews,
        required String distance,
        required String imageUrl,
      }) {
    return GestureDetector(
      onTap: () {
        // Navigate to doctor detail page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected doctor: $name')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Image (Placeholder)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              // Doctor Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialty,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$rating ($reviews reviews)',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.location_on,
                          color: Colors.blue.shade300,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$distance km',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AppointmentScreen2()), // Navigate to LoginScreen
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              side: const BorderSide(color: Colors.blue),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Profile'),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// For testing purposes only - remove when integrating with your main app
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Healthcare Provider Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const HealthcareSearchApp(),
    ),
  );
}