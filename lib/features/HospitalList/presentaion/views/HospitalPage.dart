import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: HospitalListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Hospital {
  final String name;
  final String address;
  final String image;
  final bool isEmergency;

  Hospital({
    required this.name,
    required this.address,
    required this.image,
    required this.isEmergency,
  });
}

class HospitalListScreen extends StatelessWidget {
  final List<Hospital> hospitals = [
    Hospital(
      name: "مستشفى الشيخ زايد التخصصى",
      address: " طريق مدينه 6 اكتوبر الحى الاول المجاوره الاولى مدينه الشيخ زايد",
      image: "🏥",
      isEmergency: true,
    ),
    Hospital(
      name: "مستشفى جامعه 6 اكتوبر",
      address: " مدينه 6 اكتوبر المحور المركزى",
      image: "🏥",
      isEmergency: true,
    ),
    Hospital(
      name: "مستشفى جامعه مصر للعلوم والتكنولوجيا",
      address: " الحى المتميز مدينه السادس من اكتوبر",
      image: "🏥",
      isEmergency: false,
    ),
    Hospital(
      name: "مستشفى رفيدة",
      address: " الشيخ زايد 27 محور كريزى واتر مدخل 2 6 اكتوبر",
      image: "🏥",
      isEmergency: true,
    ),
    Hospital(
      name: "مستشفى فوقية",
      address: " الجيزة _6 اكتوبر 53 ش عبد العزيز فهمى الحى المتميز",
      image: "🏥",
      isEmergency: false,
    ),
    Hospital(
      name: "مستشفى الوادى قدرات",
      address: " الحى ال1 _ال 6 من اكتوبر _الجيزة قطعة رقم 5 مركز الحى 1 وال2 _طريق محور الكفراوى _بالقرب من ميدان الحصرى _6 اكتوبر",
      image: "🏥",
      isEmergency: true,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Nearby Hospitals',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: hospitals.length,
              itemBuilder: (context, index) {
                return HospitalCard(hospital: hospitals[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.red[600],
        child: Icon(Icons.emergency, color: Colors.white),
      ),
    );
  }
}

class HospitalCard extends StatelessWidget {
  final Hospital hospital;

  const HospitalCard({Key? key, required this.hospital}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Handle hospital selection
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        hospital.image,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                hospital.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            if (hospital.isEmergency)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '24/7',
                                  style: TextStyle(
                                    color: Colors.red[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      hospital.address,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text(
                      'Call',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
}
