import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants.dart';
import '../../../Login/presentaion/views/LoginScreen.dart';
import '../controller/cubit/register_cubit.dart';
import '../controller/cubit/register_state.dart';
import 'dart:io';

class ContactInfoScreen extends StatefulWidget {
  final Map<String, dynamic> personalInfo;

  const ContactInfoScreen({Key? key, required this.personalInfo}) : super(key: key);

  @override
  _ContactInfoScreenState createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedCountry = 'Egypt';
  String _selectedCity = 'Cairo';
  String? _selectedImagePath;

  final List<String> _egyptGovernorates = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Shubra El Kheima',
    'Port Said',
    'Suez',
    'Luxor',
    'Mansoura',
    'El-Mahalla El-Kubra',
    'Tanta',
    'Asyut',
    'Ismailia',
    'Fayyum',
    'Zagazig',
    'Aswan',
    'Damietta',
    'Damanhur',
    'El-Minya',
    'Sohag',
    'Beni Suef',
    'Hurghada',
    '6th of October City',
    'Shibin El Kom',
    'Banha',
    'Arish',
    '10th of Ramadan City',
    'Marsa Matruh',
    'Kafr El Sheikh',
    'El Obour',
    'New Cairo',
    'Sheikh Zayed City',
    'New Damietta',
    'New Alamein',
    'New Mansoura',
    'New Sohag',
    'New Aswan',
    'New Luxor',
    'New Qena',
    'New Beni Suef',
    'New Minya',
    'New Assiut',
    'New Fayoum',
    'New Valley',
    'Red Sea',
    'Matrouh',
    'North Sinai',
    'South Sinai',
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
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
    // TODO: Implement actual image picker functionality
    // You'll need to add image_picker package and implement this
    // Example implementation:
    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: source);
    // if (pickedFile != null) {
    //   setState(() {
    //     _selectedImagePath = pickedFile.path;
    //   });
    // }

    // Placeholder for now
    setState(() {
      _selectedImagePath = source == ImageSource.camera ? 'camera_image' : 'gallery_image';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${source == ImageSource.camera ? 'Camera' : 'Gallery'} functionality - Add image_picker package'),
      ),
    );
  }

  void _handleRegistration() {
    if (_phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Convert image path to File if available
    File? imageFile;
    if (widget.personalInfo['imagePath'] != null &&
        widget.personalInfo['imagePath'].isNotEmpty) {
      imageFile = File(widget.personalInfo['imagePath']);
    }

    context.read<RegisterCubit>().register(
      nationalId: widget.personalInfo['nationalId'],
      email: widget.personalInfo['email'],
      firstName: widget.personalInfo['firstName'],
      lastName: widget.personalInfo['lastName'],
      gender: widget.personalInfo['gender'],
      phoneNumber: _phoneController.text,
      country: _selectedCountry,
      city: _selectedCity,
      fullAddress: _addressController.text,
      password: widget.personalInfo['password'],
          image: imageFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registration successful! Please login to continue.'),
                  backgroundColor: Colors.green,
                ),
              );

              // Navigate to login screen and clear the stack
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            } else if (state is RegisterError) {
              print('state.message: ${state.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Back Button and Title
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: kPrimaryColor),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Spacer(),
                        const Text(
                          'Contact Information',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Subtitle
                    const Center(
                      child: Text(
                        'Please provide your contact details',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Phone Number Field
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),

                    // Country Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCountry,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      items: ['Egypt'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCountry = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 15),

                    // City Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCity,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      items: _egyptGovernorates.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCity = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 15),

                    // Address Field
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Full Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Add Photo Button/Display (Added after full address)
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: kPrimaryColor.withOpacity(0.3),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                            color: _selectedImagePath != null
                                ? Colors.grey.shade100
                                : kPrimaryColor.withOpacity(0.05),
                          ),
                          child: _selectedImagePath != null
                              ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.grey.shade200,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        size: 48,
                                        color: Colors.green,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Photo Selected',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Tap to change photo',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          )
                              : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 64,
                                color: kPrimaryColor,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Add Photo',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tap to select from camera or gallery',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Next Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is RegisterLoading ? null : _handleRegistration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: state is RegisterLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          'Complete Registration',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
