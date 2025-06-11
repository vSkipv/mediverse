import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mediverse/features/add_Doctor/data/model/new_doctor.dart';
import 'package:mediverse/features/add_Doctor/data/repositories/new_doctor_repo_imp.dart';
import 'package:mediverse/features/add_Doctor/presentaion/controller/new_doctor_cubit.dart';
import 'package:mediverse/features/add_Doctor/presentaion/controller/new_doctor_state.dart';

import '../../../../core/network/api/api_service.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({Key? key}) : super(key: key);

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  late NewDoctorCubit newDoctorCubit;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _specialistController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _genderController = TextEditingController();
  final _imageController = TextEditingController();

  bool _obscurePassword = true;
  String _selectedGender = 'Male';
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _specialistController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final dio = Dio();
    final apiService = ApiService(dio);
    final repo = NewDoctorRepoImp(apiService: apiService);
    newDoctorCubit = NewDoctorCubit(repo);
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final XFile? image = await _imagePicker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => newDoctorCubit,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Add Doctor',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: BlocConsumer<NewDoctorCubit, NewDoctorState>(
            listener: (context, state) {
              if (state is NewDoctorSuccessState) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Doctor Added Successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is NewDoctorErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Failed to add doctor ${state.message}"),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // First Name and Last Name Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _firstNameController,
                            hintText: 'First Name',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _lastNameController,
                            hintText: 'Last Name',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Email Field
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 20),

                    // Phone Number Field
                    _buildTextField(
                      controller: _phoneNumberController,
                      hintText: 'Phone Number',
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 20),

                    // Gender Dropdown
                    _buildGenderDropdown(),

                    const SizedBox(height: 20),

                    // Password Field
                    _buildPasswordField(),

                    const SizedBox(height: 20),

                    // City and Country Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _cityController,
                            hintText: 'City',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _countryController,
                            hintText: 'Country',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Specialist Field
                    _buildTextField(
                      controller: _specialistController,
                      hintText: 'Specialist',
                    ),

                    const SizedBox(height: 20),

                    // Full Address Field
                    _buildTextField(
                      controller: _addressController,
                      hintText: 'Full Address',
                    ),

                    const SizedBox(height: 20),

                    // Description Field
                    _buildTextField(
                      controller: _descriptionController,
                      hintText: 'Description',
                      maxLines: 4,
                    ),

                    const SizedBox(height: 20),

                    // Image Picker
                    _buildImagePicker(),

                    const SizedBox(height: 40),

                    // Submit Button
                    _buildSubmitButton(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          // Email validation
          if (hintText == 'Email Address') {
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
          }
          // Phone validation
          if (hintText == 'Phone Number') {
            if (!RegExp(r'^[+]?[0-9]{10,15}$').hasMatch(value.replaceAll(' ', ''))) {
              return 'Please enter a valid phone number';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(
          hintText: 'Select Gender',
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: InputBorder.none,
        ),
        items: ['Male', 'Female', 'Other'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedGender = newValue!;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a gender';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: _pickImage,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (_selectedImage != null)
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImage!,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to change image',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add Doctor Image',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to select from gallery or camera',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
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

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: 'Enter Your Password',
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[500],
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Color(0xFF1976D2)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Handle form submission
            _submitForm();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'Submit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    // Create doctor data map
    final doctorData = NewDoctor(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phoneNumber: _phoneNumberController.text,
      gender: _selectedGender,
      description: _descriptionController.text,
      city: _cityController.text,
      country: _countryController.text,
      fullAdress: _addressController.text,
      password: _passwordController.text,
      specialist: _specialistController.text,
      image: _selectedImage,
    );

    newDoctorCubit.addNewDoc(newDoc: doctorData);
    // Print data for debugging
    print('Doctor: $doctorData');
    print('Selected Image: $_selectedImage');
  }
}