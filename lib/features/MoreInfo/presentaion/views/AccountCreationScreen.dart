import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../MedicalScreen/presentaion/views/MedicalScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Creation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AccountCreationScreen(),
    );
  }
}

class AccountCreationScreen extends StatefulWidget {
  const AccountCreationScreen({Key? key}) : super(key: key);

  @override
  State<AccountCreationScreen> createState() => _AccountCreationScreenState();
}

class _AccountCreationScreenState extends State<AccountCreationScreen> {
  String? selectedCountry;
  String? selectedCity;
  String selectedGender = '';
  final TextEditingController _diseasesController = TextEditingController();

  // Sample data for dropdowns
  final List<String> countries = ['Egypt'];
  final Map<String, List<String>> citiesByCountry = {
    'Egypt': ['Cairo', 'Alexandria', 'Giza', 'Tanta', 'Banha', 'Suez', 'Mansoura', 'Luxor', 'Aswan'
    ,'Hurghada', 'Sharm El-Sheikh', 'Ismailia', 'Fayoum', 'Minya', 'Qena', 'Asyut', 'Sohag',
      'Beni Suef'],
  };

  List<String> getCitiesForSelectedCountry() {
    return selectedCountry != null ? citiesByCountry[selectedCountry]! : [];
  }

  @override
  void dispose() {
    _diseasesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centered header with aligned back button
              Stack(
                alignment: Alignment.center,
                children: [
                  // Centered text
                  const Center(
                    child: Text(
                      'Create an account',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Back button aligned to the left
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // Navigation logic
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'personal information',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // National ID TextField
              TextField(
                decoration: InputDecoration(
                  hintText: 'National ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              // Gender Selection with darkened background when selected
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = 'Female';
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: selectedGender == 'Female' ? Colors.black87 : Colors.grey[300]!,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                          boxShadow: selectedGender == 'Female'
                              ? [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Female',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: selectedGender == 'Female' ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = 'Male';
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: selectedGender == 'Male' ? Colors.black87 : Colors.grey[300]!,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                          boxShadow: selectedGender == 'Male'
                              ? [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Male',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: selectedGender == 'Male' ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Country and City Dropdowns
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                        color: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCountry,
                          hint: const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text('country'),
                          ),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCountry = newValue;
                              selectedCity = null; // Reset city when country changes
                            });
                          },
                          items: countries.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                        color: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCity,
                          hint: const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text('city'),
                          ),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          onChanged: selectedCountry == null
                              ? null
                              : (String? newValue) {
                            setState(() {
                              selectedCity = newValue;
                            });
                          },
                          items: selectedCountry == null
                              ? []
                              : getCitiesForSelectedCountry()
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Full Address TextField
              TextField(
                decoration: InputDecoration(
                  hintText: 'full address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Inherited Diseases Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Do You have any inherited diseases?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // TextField instead of static text
                    TextField(
                      controller: _diseasesController,
                      decoration: InputDecoration(
                        hintText: 'Click here to add any inherited diseases from one of your parents',
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Logic to add genetic diseases
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDB6464),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Add genetic Diseases',
                        style: TextStyle(
                          fontFamily: 'GT Sectra Fine',
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MedicalInfoScreen()), // Navigate to LoginScreen
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontFamily: 'GT Sectra Fine',
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
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