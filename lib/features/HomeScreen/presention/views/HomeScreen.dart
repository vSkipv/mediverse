import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../AppointmentIcon/presention/views/AppointmentPage.dart';
import '../../../AppointmentIcon/presention/views/AppointmentPage.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    'Hello,',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text(
                      'A',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Hi Anthony',
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
                              backgroundImage: AssetImage('assets/images/thony.png'),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Anthony Ehab',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Patient',
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      textAlign: TextAlign.center,
                      '4080709010856',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => AnalysisPage()))
                  ),
                  _buildImageIconWithText(
                      'assets/images/appoi.png',
                      'Appointment',
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()))
                  ),
                  _buildImageIconWithText(
                      'assets/images/Medicine.png',
                      'Medicine',
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => MedicinePage()))
                  ),
                  _buildImageIconWithText(
                      'assets/images/hospital.png',
                      'Hospital',
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => HospitalPage()))
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
                label: 'My Activity',
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
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  // Updated method to make icons clickable
  Widget _buildImageIconWithText(String imagePath, String text, VoidCallback onTap) {
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
              color: Colors.blue,
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

// New destination pages
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
            Text('View and manage your medications here.'),
          ],
        ),
      ),
    );
  }
}

class HospitalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospitals'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_hospital, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Hospital Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Find and connect with nearby hospitals and clinics.'),
          ],
        ),
      ),
    );
  }
}