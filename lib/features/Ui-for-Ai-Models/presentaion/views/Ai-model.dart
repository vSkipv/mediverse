import 'package:flutter/material.dart';
import 'package:mediverse/features/Ui-for-Ai-Models/presentaion/views/retinal-disease.dart';
import 'package:mediverse/features/Ui-for-Ai-Models/presentaion/views/x-ray-view.dart';
import 'Mri-view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prediction Models',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
    );
  }
}

class PredictionModelsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        automaticallyImplyLeading: false, // This removes the back arrow
        title: Text(
          'Prediction Models',
          style: TextStyle(
            color: Color(0xff0E64D2),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            PredictionModelButton(
              title: 'MRI brain tumor\nclassification',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PredictionModelsScreen1(),
                  ),
                );
              },
            ),
            SizedBox(height: 24),
            PredictionModelButton(
              title: 'chest X-ray classification',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PredictionModelsScreen2(),
                  ),
                );
              },
            ),
            SizedBox(height: 24),
            PredictionModelButton(
              title: 'retinal disease detection',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PredictionModelsScreen3(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PredictionModelButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const PredictionModelButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0E64D2), Color(0xff0E64D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF4A90E2).withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}