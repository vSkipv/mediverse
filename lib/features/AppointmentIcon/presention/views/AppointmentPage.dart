import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:mediverse/core/network/api/api_service.dart';
import 'package:mediverse/features/DoctorProfile/presention/views/DoctorProfile.dart';
import 'package:mediverse/features/AppointmentIcon/presention/cubit/appointment_cubit.dart';
import 'package:mediverse/features/AppointmentIcon/data/repositories/appointment_repository_impl.dart';
import 'package:mediverse/features/AppointmentIcon/data/models/doctor.dart';


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
  late AppointmentCubit _appointmentCubit;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchingByName = false;

  // Specialties list
  final List<String> specialties = [
    'Ophthalmologist',
    'Pediatrician',
    'Dentist',
    'Orthopedic',
    'Cardiologist',
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
  void initState() {
    super.initState();
    final dio = Dio();
    final apiService = ApiService(dio);
    final repository = AppointmentRepositoryImpl(apiService, context);
    _appointmentCubit = AppointmentCubit(repository: repository);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _appointmentCubit.close();
    super.dispose();
  }

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
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
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

              // Search Bar

              if (!_isSearchingByName) ...[
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
              ],

              const Spacer(),

              // Next Button with Navigation
              if (!_isSearchingByName)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: ElevatedButton(
                    onPressed: _handleSearch,
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

  void _handleSearch() {
    if (selectedSpecialty != null && selectedState != null && selectedCity != null) {
      _appointmentCubit.searchDoctors(
        specialist: selectedSpecialty!,
        country: selectedState!,
        city: selectedCity!,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _appointmentCubit,
            child: DoctorListScreen(
              specialty: selectedSpecialty!,
              ctate: selectedState!,
              city: selectedCity!,
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields'),
        ),
      );
    }
  }
}

class DoctorListScreen extends StatefulWidget {
  final String specialty;
  final String ctate;
  final String city;

  const DoctorListScreen({
    Key? key,
    required this.specialty,
    required this.ctate,
    required this.city,
  }) : super(key: key);

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchingByName = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _isSearchingByName = true;
      });
      context.read<AppointmentCubit>().searchDoctorsByName(_searchController.text);
    }
  }

  void _resetSearch() {
    setState(() {
      _isSearchingByName = false;
      _searchController.clear();
    });
    context.read<AppointmentCubit>().searchDoctors(
      specialist: widget.specialty,
      country: widget.ctate,
      city: widget.city,
    );
  }

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
          '${widget.specialty} Doctors',
          style: const TextStyle(color: Colors.black87),
        ),
      ),
      body: BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AppointmentError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  if (state.isAuthError) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Go to Login'),
                    ),
                  ],
                ],
              ),
            );
          }

          if (state is AppointmentLoaded) {
            return Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search doctors by name',
                              prefixIcon: Icon(Icons.search, color: Color(0xFF9E9E9E)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                            onSubmitted: (_) => _handleSearch(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Color(0xFF4285F4)),
                          onPressed: _handleSearch,
                        ),
                      ],
                    ),
                  ),
                ),
                // Location Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildLocationHeader('${widget.city}, ${widget.ctate}'),
                ),
                const SizedBox(height: 16),
                // Reset Search Button (shown when searching by name or no results)
                if (_isSearchingByName || state.doctors.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton.icon(
                      onPressed: _resetSearch,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text('Reset to Original Search'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4285F4),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                // No Results Message
                if (state.doctors.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No doctors found matching your search criteria',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                // Doctors List
                if (state.doctors.isNotEmpty)
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: state.doctors.map((doctor) => _buildDoctorCard(
                        context,
                        firstName: doctor.firstName,
                        lastName: doctor.lastName,
                        specialty: doctor.specialty,
                        rating: doctor.rating,
                        reviews: doctor.reviews,
                        distance: doctor.distance,
                        imageUrl: doctor.imageUrl ?? 'assets/images/doctor_placeholder.png',
                        id: doctor.id!
                      )).toList(),
                    ),
                  ),
              ],
            );
          }

          return const Center(child: Text('No doctors found'));
        },
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
        required String firstName,
        required String lastName,
        required String specialty,
        required double rating,
        required int reviews,
        required String distance,
        required String imageUrl,
        required int id,
      }) {
    // Combine firstName and lastName for display
    final String fullName = '$firstName $lastName'.trim();

    return GestureDetector(
      onTap: () {
        // Navigate to doctor detail page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentScreen2(
              doctorId: 1, // Replace with actual doctor ID from the API
            ),
          ),
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
                      fullName,
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
                                MaterialPageRoute(builder: (context) => AppointmentScreen2(doctorId:id ,)), // Navigate to LoginScreen
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

