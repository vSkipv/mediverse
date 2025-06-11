import 'package:flutter/material.dart';
import 'package:mediverse/core/utililes/cached_sp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../../../constants.dart';
import '../../../AccountScreen/presentaion/views/AccountScreen.dart';
import '../../../AppointmentIcon/presention/views/AppointmentPage.dart';
import '../../../../constants.dart' as Constant;
import '../../../HospitalList/presentaion/views/HospitalPage.dart';
import '../../../Ui-for-Ai-Models/presentaion/views/Ai-model.dart';
import '../../data/repository/appointment_repository.dart';
import '../../presention/cubit/appointment_cubit.dart';
import '../../../../core/network/api/api_service.dart';

// Add this line to your constants.dart file or add it directly here if you prefer
final Color kDarkerPrimaryColor = Color(0xFF036BB9); // Darker version of kPrimaryColor

void main() {
  runApp(MedicalApp());
}

class MedicalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MedicalAppHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MedicalAppHomePage extends StatefulWidget {
  @override
  _MedicalAppHomePageState createState() => _MedicalAppHomePageState();
}

class _MedicalAppHomePageState extends State<MedicalAppHomePage> {
  int _selectedIndex = 0;

  // Define the list of pages to show for the first three tabs
  final List<Widget> _pages = [
    HomePage(),
    ActivityPage(),
    PredictionModelsScreen(),
    // We'll handle the Account tab differently
    Container(), // Placeholder for the fourth tab
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Instead of the whole body, show the selected page from _pages list
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(horizontal: 24.0),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.all(
                Radius.circular(100.0)
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            selectedLabelStyle: TextStyle(color: Colors.white),
            unselectedLabelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Appointment',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.monitor_heart),
                label: 'Predictions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'ACCOUNT',
              ),
            ],
            onTap: (index) {
              if (index == 3) {
                // Navigate to a specific screen when Account tab is selected
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen())
                );
                // Keep the selected index at its current value so the bottom nav
                // doesn't show as changed (or you can set it to 3 if you want it to appear selected)
              } else {
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
          ),
        ),
      ),
    );
  }

  // Method to build icon widgets
  Widget _buildImageIconWithText(String imagePath, String text, VoidCallback onTap, {Color? iconColor}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              imagePath,
              width: 24,
              height: 24,
              color: iconColor ?? Colors.blue,
            ),
          ),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Create each page for bottom navigation
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  String? userId;
  String? userImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await CachedData.getData(Constant.name);
    final id = await CachedData.getData(Constant.id);
    final image = await CachedData.getData(Constant.image);
    setState(() {
      userName = name;
      userId = id.toString();
      userImage = image;
      print('User Name: $userName');
      print("user id $userId" );
      print("user image $userImage");
    });
  }

  @override
  Widget build(BuildContext context)   {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top greeting
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hello, ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  backgroundImage: userImage != null && userImage!.isNotEmpty
                      ? NetworkImage(userImage!)
                      : null,
                  child: userImage == null || userImage!.isEmpty
                      ? Icon(Icons.person, size: 30, color: kPrimaryColor)
                      : null,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Hi  $userName,',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Patient Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            backgroundImage: userImage != null && userImage!.isNotEmpty
                                ? NetworkImage(userImage!)
                                : null,
                            child: userImage == null || userImage!.isEmpty
                                ? Icon(Icons.person, size: 30, color: kPrimaryColor)
                                : null,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName ?? 'User',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Patient ID: ${userId ?? 'N/A'}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                ],
              ),
            ),
          ),

          // Bottom Icons - Now clickable
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildImageIconWithText(
                    'assets/images/Vector.png',
                    'Analysis',
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => AnalysisPage())),
                    iconColor: kPrimaryColor
                ),
                _buildImageIconWithText(
                    'assets/images/appoi.png',
                    'view Appointment',
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen())),
                    iconColor: kPrimaryColor),
                _buildImageIconWithText(
                    'assets/images/Medicine.png',
                    'Medicine',
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => MedicinePage())),
                    iconColor: kPrimaryColor
                ),
                _buildImageIconWithText(
                    'assets/images/hospital.png',
                    'Hospital',
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => HospitalListScreen())),
                    iconColor: kPrimaryColor
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Modified to accept a color parameter
  Widget _buildImageIconWithText(String imagePath, String text, VoidCallback onTap, {Color? iconColor}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              imagePath,
              width: 24,
              height: 24,
              color: iconColor ?? kPrimaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Activity Page
class ActivityPage extends StatefulWidget {
  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  String? patientId;

  @override
  void initState() {
    super.initState();
    _loadPatientId();
  }

  Future<void> _loadPatientId() async {
    final id = await CachedData.getData(Constant.id);
    setState(() {
      patientId = id?.toString(); // Convert to string
    });
  }

  @override
  Widget build(BuildContext context) {
    if (patientId == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return BlocProvider(
      create: (context) => AppointmentCubit(
        AppointmentRepository(
          ApiService(Dio()),
        ),
      )..getAppointments(patientId!),
      child: BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          print('Building UI with state: $state');
          print('Using patient ID: $patientId'); // Debug print
          
          if (state is AppointmentLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading appointments...'),
                ],
              ),
            );
          } else if (state is AppointmentLoaded) {
            if (state.appointments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No appointments found',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }
            
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Appointments',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = state.appointments[index];
                          // Parse the reservation date
                          final dateTime = DateTime.parse(appointment.reservation);
                          final formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                          final formattedTime = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
                          
                          return Card(
                            margin: EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: kPrimaryColor,
                                child: Icon(Icons.calendar_today, color: Colors.white),
                              ),
                              title: Text(
                                appointment.doctorName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Date: $formattedDate'),
                                  Text('Time: $formattedTime'),
                                  Text('Status: ${appointment.status}'),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is AppointmentError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error loading appointments',
                    style: TextStyle(fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AppointmentCubit>().getAppointments(patientId!);
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          return Center(
            child: Text('Initial state - waiting for data'),
          );
        },
      ),
    );
  }
}

// Predictions Page
class PredictionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monitor_heart, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Predictions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('View your health predictions and analytics.'),
          ],
        ),
      ),
    );
  }
}

// Existing destination pages
class AnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Analysis Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Your medical analysis data will be shown here.'),
          ],
        ),
      ),
    );
  }
}

class MedicinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medication, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Medicine Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('This Feature is under development. will in next update.'),
          ],
        ),
      ),
    );
  }
}

