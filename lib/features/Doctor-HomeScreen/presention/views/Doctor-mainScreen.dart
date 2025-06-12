import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/api/api_service.dart';
import '../../../../core/utililes/cached_sp.dart';
import '../../../MainScreen/presentaion/views/MainScreen_view.dart';
import '../../../appoitments_in_Doctor/presention/views/state_appoitments.dart';
import '../../../../constants.dart' as Constant;
import '../../data/repositories/patient_repository.dart';
import '../cubit/patient_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: MedicalDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MedicalDashboard extends StatefulWidget {
  @override
  State<MedicalDashboard> createState() => _MedicalDashboardState();
}

class _MedicalDashboardState extends State<MedicalDashboard> {
  String? userName;
  String? userId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await CachedData.getData(Constant.name);
    final id = await CachedData.getData(Constant.id);
    setState(() {
      userName = name;
      userId = id.toString();
      print('User Name: $userName');
      print("user id $userId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hi Doctor $userName',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Main Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Doctor View Display
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff0E64D2), Color(0xff0E64D2)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Doctor Id : $userId',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // // View Appointment Button
                    // Container(
                    //   width: double.infinity,
                    //   height: 70,
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       colors: [Color(0xff0E64D2), Color(0xff0E64D2)],
                    //       begin: Alignment.centerLeft,
                    //       end: Alignment.centerRight,
                    //     ),
                    //     borderRadius: BorderRadius.circular(35),
                    //   ),
                    //   child: Material(
                    //     color: Colors.transparent,
                    //     child: InkWell(
                    //       borderRadius: BorderRadius.circular(35),
                    //       onTap: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (context) => AppointmentsStatePage()),
                    //         );
                    //       },
                    //       child: Padding(
                    //         padding: EdgeInsets.symmetric(horizontal: 20),
                    //         child: Row(
                    //           children: [
                    //             Container(
                    //               padding: EdgeInsets.all(8),
                    //               child: Icon(
                    //                 Icons.calendar_today,
                    //                 color: Colors.white,
                    //                 size: 24,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    SizedBox(height: 20),

                    // View Patient Record Button
                    Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff0E64D2), Color(0xff0E64D2)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(35),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PatientRecordPage()),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.description,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  'view patient record',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Spacer(),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff0E64D2), Color(0xff0E64D2)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBottomNavItem(context, Icons.home, 'HOME', true),
                    _buildBottomNavItem(context, Icons.account_circle, 'ACCOUNT', false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(BuildContext context, IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        switch (label) {
          case 'HOME':
          // Already on home, no need to navigate
            break;
          case 'Reports':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportsPage()),
            );
            break;
          case 'Support':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SupportPage()),
            );
            break;
          case 'ACCOUNT':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountPage()),
            );
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// Appointment Page
class AppointmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Appointments'),
        backgroundColor: Color(0xff0E64D2),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 100,
              color: Color(0xff0E64D2),
            ),
            SizedBox(height: 20),
            Text(
              'Appointments',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'View and manage your appointments',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Patient Record Page
class PatientRecordPage extends StatefulWidget {
  @override
  _PatientRecordPageState createState() => _PatientRecordPageState();
}

class _PatientRecordPageState extends State<PatientRecordPage> {
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _treatmentController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  late PatientCubit _patientCubit;
  String? userId;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    final apiService = ApiService(dio);
    final repository = PatientRepositoryImpl(apiService);
    _patientCubit = PatientCubit(repository);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final id = await CachedData.getData(Constant.id);
    setState(() {
      userId = id.toString();
    });
  }

  @override
  void dispose() {
    _nationalIdController.dispose();
    _diagnosisController.dispose();
    _treatmentController.dispose();
    _doctorNameController.dispose();
    _hospitalNameController.dispose();
    _patientCubit.close();
    super.dispose();
  }

  void _showAddMedicalCaseDialog(BuildContext context, String patientId) {
    showDialog(
      context: context,
      builder: (context) => BlocListener<PatientCubit, PatientState>(
        listener: (context, state) {
          if (state is MedicalCaseAdded) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Medical case added successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is MedicalCaseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: AlertDialog(
          title: Text('Add Medical Case'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _diagnosisController,
                  decoration: InputDecoration(
                    labelText: 'Diagnosis',
                    border: OutlineInputBorder(),
                    hintText: 'Enter patient diagnosis',
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _treatmentController,
                  decoration: InputDecoration(
                    labelText: 'Prescription',
                    border: OutlineInputBorder(),
                    hintText: 'Enter prescription details',
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _doctorNameController,
                  decoration: InputDecoration(
                    labelText: 'Birth Type',
                    border: OutlineInputBorder(),
                    hintText: 'Enter birth type',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _diagnosisController.clear();
                _treatmentController.clear();
                _doctorNameController.clear();
              },
              child: Text('Cancel'),
            ),
            BlocBuilder<PatientCubit, PatientState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state is MedicalCaseAdding
                      ? null
                      : () {
                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Doctor ID not found')),
                      );
                      return;
                    }

                    if (_diagnosisController.text.isEmpty ||
                        _treatmentController.text.isEmpty ||
                        _doctorNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    _patientCubit.addMedicalCase(
                      patientId: patientId,
                      diagnosis: _diagnosisController.text,
                      prescription: _treatmentController.text,
                      doctorId: userId!,
                      creationDate: DateTime.now().toIso8601String(),
                      birthtype: _doctorNameController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0E64D2),
                    foregroundColor: Colors.white,
                  ),
                  child: state is MedicalCaseAdding
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text('Add Medical Case'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _patientCubit,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text('Patient Records'),
          backgroundColor: Color(0xff0E64D2),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nationalIdController,
                decoration: InputDecoration(
                  labelText: 'Enter National ID',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      if (_nationalIdController.text.isNotEmpty) {
                        _patientCubit.getPatientByNationalId(_nationalIdController.text);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<PatientCubit, PatientState>(
                  builder: (context, state) {
                    if (state is PatientLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is PatientLoaded) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Patient Information',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    _buildInfoRow('Name',
                                        '${state.patient.firstName ?? ''} ${state.patient.lastName ?? ''}'),
                                    _buildInfoRow('National ID',
                                        state.patient.nationalId),
                                    _buildInfoRow('Phone', state.patient.phoneNumber),
                                    _buildInfoRow('Email', state.patient.email),
                                    _buildInfoRow(
                                        'Address', state.patient.fullAddress),
                                    _buildInfoRow(
                                        'age', state.patient.age),
                                    _buildInfoRow(
                                        'Gender', state.patient.gender),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => _showAddMedicalCaseDialog(context, state.patient.id!),
                              icon: Icon(Icons.add),
                              label: Text('Add Medical Case'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff0E64D2),
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 50),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is PatientError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Colors.red),
                            SizedBox(height: 16),
                            Text(
                              'Error',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              state.message,
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.description,
                              size: 100,
                              color: Color(0xff0E64D2),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Patient Records',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Enter National ID to view patient records',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(value ?? ''),
          ),
        ],
      ),
    );
  }
}

// Reports Page
class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Reports'),
        backgroundColor: Color(0xff0E64D2),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment,
              size: 100,
              color: Color(0xff0E64D2),
            ),
            SizedBox(height: 20),
            Text(
              'Reports',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'View medical reports and analytics',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Support Page
class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Support'),
        backgroundColor: Color(0xff0E64D2),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.headset_mic,
              size: 100,
              color: Color(0xff0E64D2),
            ),
            SizedBox(height: 20),
            Text(
              'Support',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Get help and support',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Account Page
class AccountPage extends StatefulWidget {
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? userName;
  String? userId;
  String? userimage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await CachedData.getData(Constant.name);
    final id = await CachedData.getData(Constant.id);
    setState(() {
      userName = name;
      userId = id.toString();
      print('User Name: $userName');
      print("user id $userId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFF1976D2),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      '$userName ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Doctor',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Account Options
              _buildAccountOption(
                icon: Icons.edit,
                title: 'Edit Profile',
                onTap: () {},
              ),
              _buildAccountOption(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () {},
              ),
              _buildAccountOption(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {},
              ),
              _buildAccountOption(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red),
                            SizedBox(width: 10),
                            Text('Logout'),
                          ],
                        ),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Logout'),
                            onPressed: () {
                              CachedData.removeToken();
                              Navigator.pop(context); // Close dialog
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : Color(0xFF1976D2),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }
}
