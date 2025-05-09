import 'package:flutter/material.dart';

import '../../../../constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const MedicalInfoScreen(),
    );
  }
}

class MedicalInfoScreen extends StatefulWidget {
  const MedicalInfoScreen({Key? key}) : super(key: key);

  @override
  State<MedicalInfoScreen> createState() => _MedicalInfoScreenState();
}

class _MedicalInfoScreenState extends State<MedicalInfoScreen> {
  String? selectedParent;
  String? selectedBirthType;
  String? selecteDisease;

  final List<String> diseases = [
    'السكري',
    'ارتفاع ضغط الدم',
    'مرض قلبي',
    'الربو',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              Stack(
                alignment: Alignment.center,
                children: [
                  // Centered text
                  const Center(
                    child: Text(
                      'Select a parent',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Back button aligned to the left
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: kPrimaryColor),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),

              // Medical information subtitle
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'medical Information',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Parent selection buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedParent = 'Father';
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: selectedParent == 'Father' ? kPrimaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                          boxShadow: selectedParent == 'Father'
                              ? [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Father',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: selectedParent == 'Father' ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedParent = 'Mother';
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: selectedParent == 'Mother' ? kPrimaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                          boxShadow: selectedParent == 'Mother'
                              ? [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Mother',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: selectedParent == 'Mother' ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32),

              // Inherited diseases section
              Text(
                'Select one or more inherited diseases',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 12),

              // Disease dropdown
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text('Select Disease'),
                    value: selecteDisease,
                    icon: Icon(Icons.keyboard_arrow_down),
                    onChanged: (value) {
                      setState(() {
                        selecteDisease = value;
                      });
                    },
                    items: diseases.map((disease) {
                      return DropdownMenuItem<String>(
                        value: disease,
                        child: Text(disease),
                      );
                    }).toList(),
                  ),
                ),
              ),

              SizedBox(height: 8),

              // Add more text
              Center(
                child: Text(
                  'Add More',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),

              SizedBox(height: 32),

              // Additional information section
              Text(
                'Add more additional information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 12),

              // Additional information text field
              Container(
                height: 90,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'More information...',
                    border: InputBorder.none,
                  ),
                ),
              ),

              SizedBox(height: 32),

              // Birth type section
              Text(
                'Birth type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 12),

              // Birth type selection
              Row(
                children: [
                  _buildBirthTypeButton('Natural'),
                  SizedBox(width: 12),
                  _buildBirthTypeButton('cesarean'),
                  SizedBox(width: 12),
                  _buildBirthTypeButton('premature'),
                ],
              ),

              Spacer(),

              // Action buttons
              Column(
                children: [
                  // Add other parent button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff0E64D2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Add the other parent',
                        style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'GT Sectra Fine',
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Or divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[400])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Or',
                            style: TextStyle(color: Colors.grey[600],
                            fontSize: 19,),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[400])),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                          fontFamily: 'GT Sectra Fine',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBirthTypeButton(String type) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedBirthType = type;
          });
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: selectedBirthType == type ? kPrimaryColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Text(
              type,
              style: TextStyle(
                fontSize: 14,
                color: selectedBirthType == type ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

