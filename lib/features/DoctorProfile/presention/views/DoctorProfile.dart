import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: AppointmentScreen2(),
    );
  }
}

class AppointmentScreen2 extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen2> {
  int selectedTimeIndex = 1; // Default to 11:00 AM
  int selectedDateIndex = 0; // Default to Sun 4
  DateTime selectedDate = DateTime.now(); // Today's date

  final List<String> timeSlots = ['10.00 AM', '11.00 AM', '12.00 PM'];
  List<String> dateSlots = ['Sun 4', 'Mon 5', 'Tue 6'];

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[600]!, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue[600], // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // Update the date slots based on the selected date
        updateDateSlots();
      });
    }
  }

  // Function to update date slots based on selected date
  void updateDateSlots() {
    dateSlots = List.generate(3, (index) {
      final date = selectedDate.add(Duration(days: index));
      final day = DateFormat('E').format(date); // Day name (Mon, Tue, etc.)
      final dayNum = date.day.toString();
      return '$day $dayNum';
    });
    selectedDateIndex = 0; // Reset to first date
  }

  @override
  void initState() {
    super.initState();
    updateDateSlots(); // Initialize date slots
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 20),
                    color: kPrimaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Appointment',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40), // To balance the back button
                ],
              ),
            ),

            // Doctor info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: Image.network(
                        'https://placehold.co/80x80',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Dr.Upul',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.green, width: 1),
                              ),
                              child: Icon(Icons.check, size: 12, color: Colors.green),
                            ),
                            Spacer(),
                            CircleAvatar(
                              backgroundColor: Colors.green[50],
                              radius: 16,
                              child: Icon(Icons.phone, size: 16, color: Colors.green),
                            ),
                            SizedBox(width: 8),
                            CircleAvatar(
                              backgroundColor: Colors.blue[50],
                              radius: 16,
                              child: Icon(Icons.videocam, size: 16, color: Colors.blue),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Denteeth',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green[300],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Payment info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$120.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[300],
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),

            // Details section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Worem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur tempus urna at turpis condimentum lobortis. Ut commodo efficitur neque. Ut diam quam, semper iaculis condimentum ac, vestibulum eu nisi.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Working hours section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Working Hours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Show time picker dialog or all available time slots
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('All Available Time Slots'),
                          content: Container(
                            width: double.maxFinite,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: timeSlots.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(timeSlots[index]),
                                  selected: index == selectedTimeIndex,
                                  onTap: () {
                                    setState(() {
                                      selectedTimeIndex = index;
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close'),
                            )
                          ],
                        ),
                      );
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Time slots - Now Clickable
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: List.generate(timeSlots.length, (index) {
                  return _buildTimeSlot(timeSlots[index], index == selectedTimeIndex, index);
                }),
              ),
            ),

            SizedBox(height: 20),

            // Date section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Show calendar date picker when "See All" is pressed
                      _selectDate(context);
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Date slots - Also Clickable
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: List.generate(dateSlots.length, (index) {
                  return _buildDateSlot(dateSlots[index], index == selectedDateIndex, index);
                }),
              ),
            ),

            Spacer(),

            // Book button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final selectedTime = timeSlots[selectedTimeIndex];
                    final selectedDay = dateSlots[selectedDateIndex];
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Booking appointment for $selectedDay at $selectedTime'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Book an Appointment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String time, bool isSelected, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: InkWell(
          onTap: () {
            setState(() {
              selectedTimeIndex = index;
            });
          },
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue[500] : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                time,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSlot(String date, bool isSelected, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: InkWell(
          onTap: () {
            setState(() {
              selectedDateIndex = index;
            });
          },
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue[500] : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                date,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}