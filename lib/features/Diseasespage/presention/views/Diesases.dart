import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:mediverse/core/network/api/api_service.dart';
import 'package:mediverse/core/utililes/cached_sp.dart';
import '../../../../constants.dart';
import '../cubit/genetic_history_cubit.dart';
import '../cubit/genetic_history_state.dart';
import '../../data/repositories/genetic_history_repository_impl.dart';
import '../../../../constants.dart' as Constant;

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
  String? selectedParent;
  List<String?> selectedDiseases = [null]; // List to store multiple disease selections
  String? selectedBirthType;
  final TextEditingController additionalInfoController = TextEditingController();
  late GeneticHistoryCubit _geneticHistoryCubit;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    final apiService = ApiService(dio);
    final repository = GeneticHistoryRepositoryImpl(apiService);
    _geneticHistoryCubit = GeneticHistoryCubit(repository: repository);
  }

  @override
  void dispose() {
    _geneticHistoryCubit.close();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<GeneticHistoryCubit, GeneticHistoryState>(
          bloc: _geneticHistoryCubit,
          listener: (context, state) {
            if (state is GeneticHistorySuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Genetic history saved successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state is GeneticHistoryError) {
              print(state.message);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with back button and title
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.blue),
                        onPressed: () {
                          // Handle back navigation
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                      ),
                      SizedBox(width: 48), // Balance the back button width
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Parent selection radio buttons
                  const Text(
                    'Select affected parent',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Clean radio buttons for parent selection
                  Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Father'),
                        value: 'Father',
                        groupValue: selectedParent,
                        onChanged: (String? value) {
                          setState(() {
                            selectedParent = value;
                          });
                        },
                        activeColor: const Color(0xff0E64D2),
                        contentPadding: EdgeInsets.zero,
                      ),
                      RadioListTile<String>(
                        title: const Text('Mother'),
                        value: 'Mother',
                        groupValue: selectedParent,
                        onChanged: (String? value) {
                          setState(() {
                            selectedParent = value;
                          });
                        },
                        activeColor: const Color(0xff0E64D2),
                        contentPadding: EdgeInsets.zero,
                      ),
                      RadioListTile<String>(
                        title: const Text('Both'),
                        value: 'Both',
                        groupValue: selectedParent,
                        onChanged: (String? value) {
                          setState(() {
                            selectedParent = value;
                          });
                        },
                        activeColor: const Color(0xff0E64D2),
                        contentPadding: EdgeInsets.zero,
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

                  const SizedBox(height: 24),

                  // Bottom buttons
                  ElevatedButton(
                    onPressed: () async {
                      // Get selected disease
                      String? selectedDisease = selectedDiseases.firstWhere(
                            (disease) => disease != null,
                        orElse: () => null,
                      );

                      if (selectedParent == null || selectedDisease == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a parent and at least one disease'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      _geneticHistoryCubit.addGeneticHistory(
                        patientId: await CachedData.getData(Constant.id), // Replace with actual patient ID
                        diseaseName: selectedDisease!,
                        parent: selectedParent!,
                        additionalInfo: additionalInfoController.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
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

                  const SizedBox(height: 16),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
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
            'heart disease',
            'Hypertension',
            'asthma',
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