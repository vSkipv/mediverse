import 'package:flutter/material.dart';

import '../../../../constants.dart';

void main() {
  runApp(const MedicalApp());
}

class MedicalApp extends StatelessWidget {
  const MedicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const MedicalInformationScreen(),
    );
  }
}

class MedicalInformationScreen extends StatefulWidget {
  const MedicalInformationScreen({super.key});

  @override
  State<MedicalInformationScreen> createState() => _MedicalInformationScreenState();
}

class _MedicalInformationScreenState extends State<MedicalInformationScreen> {
  // Replace single selection with map of parent checkboxes
  Map<String, bool> parentSelection = {
    'Father': false,
    'Mother': false,
  };

  List<String?> selectedDiseases = [null]; // List to store multiple disease selections
  String? selectedBirthType;
  final TextEditingController additionalInfoController = TextEditingController();

  void addAnotherDiseaseField() {
    setState(() {
      selectedDiseases.add(null);
    });
  }

  void updateDiseaseSelection(int index, String? newValue) {
    setState(() {
      selectedDiseases[index] = newValue;
    });
  }

  void removeDiseaseField(int index) {
    if (selectedDiseases.length > 1) {
      setState(() {
        selectedDiseases.removeAt(index);
      });
    }
  }

  // Toggle parent checkbox
  void toggleParentCheckbox(String parent) {
    setState(() {
      parentSelection[parent] = !parentSelection[parent]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
                    onPressed: () {
                      // Handle back navigation
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Disease',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        'medical Information',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Parent selection checkboxes
              const Text(
                'Select affected parent(s)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Parent checkboxes
              Row(
                children: [
                  Expanded(
                    child: _buildParentCheckbox('Father'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildParentCheckbox('Mother'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Disease selection
              const Text(
                'Select one or more inherited diseases',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Multiple disease dropdowns
              ...List.generate(selectedDiseases.length, (index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDiseaseDropdown(index),
                        ),
                        if (index > 0)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: kPrimaryColor),
                            onPressed: () => removeDiseaseField(index),
                          ),
                      ],
                    ),
                    if (index < selectedDiseases.length - 1)
                      const SizedBox(height: 8),
                  ],
                );
              }),

              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: addAnotherDiseaseField,
                icon: const Icon(Icons.add, size: 20, color: Colors.black54),
                label: const Text(
                  'Add More',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
              ),

              const SizedBox(height: 18),

              // Additional information
              const Text(
                'Add more additional information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: additionalInfoController,
                decoration: InputDecoration(
                  hintText: 'More information...',
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 18),

              // Birth type
              const Text(
                'Birth type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildBirthTypeButton('Natural'),
                  const SizedBox(width: 10),
                  _buildBirthTypeButton('cesarean'),
                  const SizedBox(width: 10),
                  _buildBirthTypeButton('premature'),
                ],
              ),

              const Spacer(),

              // Bottom buttons
              ElevatedButton(
                onPressed: () {
                  // Handle add another parent
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0E64D2),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Add another diseases',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),

              const SizedBox(height: 16),

              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Or', style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  // Handle continue
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // New parent checkbox widget
  Widget _buildParentCheckbox(String text) {
    final isSelected = parentSelection[text] ?? false;

    return InkWell(
      onTap: () => toggleParentCheckbox(text),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff0E64D2) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xff0E64D2) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Checkbox
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => toggleParentCheckbox(text),
                activeColor: Colors.white,
                checkColor: const Color(0xff0E64D2),
                side: BorderSide(
                  color: isSelected ? Colors.white : Colors.grey,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseDropdown(int index) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Text('Select Disease'),
          value: selectedDiseases[index],
          icon: const Icon(Icons.keyboard_arrow_down),
          items: <String>[
            'Diabetes',
            'Heart Disease',
            'Hypertension',
            'Asthma',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            updateDiseaseSelection(index, newValue);
          },
        ),
      ),
    );
  }

  Widget _buildBirthTypeButton(String text) {
    final isSelected = selectedBirthType == text;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedBirthType = text;
          });
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xff0E64D2) : Colors.white,
            border: Border.all(
              color: isSelected ? const Color(0xff0E64D2) : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}