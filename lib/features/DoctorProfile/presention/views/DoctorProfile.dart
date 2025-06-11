import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mediverse/core/network/api/api_service.dart';
import 'package:mediverse/core/utililes/cached_sp.dart';
import 'package:mediverse/features/DoctorProfile/data/repositories/doctor_profile_repository_impl.dart';
import 'package:mediverse/features/DoctorProfile/data/repositories/reservation_repository_impl.dart';
import '../../../../constants.dart';
import '../cubit/doctor_profile_cubit.dart';
import '../cubit/reservation_cubit.dart';
import '../cubit/reservation_state.dart';
import '../../../../constants.dart' as Constant;


class AppointmentScreen2 extends StatefulWidget {
  final int doctorId;

  const AppointmentScreen2({
    Key? key,
    required this.doctorId,
  }) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen2> {
  int selectedTimeIndex = 1;
  int selectedDateIndex = 0;
  DateTime selectedDate = DateTime.now();
  late DoctorProfileCubit _doctorProfileCubit;
  late ReservationCubit _reservationCubit;

  final List<String> timeSlots = ['10.00 AM', '11.00 AM', '12.00 PM'];
  List<String> dateSlots = ['Sun 4', 'Mon 5', 'Tue 6'];

  @override
  void initState() {
    super.initState();
    updateDateSlots();
    final dio = Dio();
    final apiService = ApiService(dio);
    final repository = DoctorProfileRepositoryImpl(apiService, context);
    _doctorProfileCubit = DoctorProfileCubit(repository: repository);
    _doctorProfileCubit.getDoctorProfile(widget.doctorId);

    // Initialize reservation cubit
    final reservationRepository = ReservationRepositoryImpl(apiService: apiService);
    _reservationCubit = ReservationCubit(repository: reservationRepository);
  }

  @override
  void dispose() {
    _doctorProfileCubit.close();
    _reservationCubit.close();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<DoctorProfileCubit, DoctorProfileState>(
          bloc: _doctorProfileCubit,
          builder: (context, state) {
            if (state is DoctorProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DoctorProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _doctorProfileCubit.getDoctorProfile(widget.doctorId);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is DoctorProfileLoaded) {
              final doctor = state.doctor;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 20),
                            color: kPrimaryColor,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                'Appointment',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4285F4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
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
                              child: doctor.image != null && doctor.image!.isNotEmpty
                                  ? Image.network(
                                      doctor.image!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.grey[600],
                                        );
                                      },
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey[600],
                                    ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Dr. ${doctor.firstName} ${doctor.lastName}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.green, width: 1),
                                      ),
                                      child: const Icon(Icons.check, size: 12, color: Colors.green),
                                    ),
                                    const Spacer(),
                                    CircleAvatar(
                                      backgroundColor: Colors.green[50],
                                      radius: 16,
                                      child: const Icon(Icons.phone, size: 16, color: Colors.green),
                                    ),
                                    const SizedBox(width: 8),
                                    CircleAvatar(
                                      backgroundColor: Colors.blue[50],
                                      radius: 16,
                                      child: doctor.image == null
                                          ? const Icon(Icons.message,
                                              size: 16, color: Colors.blue)
                                          : ClipOval(
                                              child: Image.network(
                                                doctor.image!,
                                                width: 32,
                                                height: 32,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(
                                                      Icons.message,
                                                      size: 16,
                                                      color: Colors.blue);
                                                },
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  doctor.specialist,
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

                    // Location info
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${doctor.fullAddress}, ${doctor.city}, ${doctor.country}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            doctor.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
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
                          const Text(
                            'Working Hours',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('All Available Time Slots'),
                                  content: SizedBox(
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
                                      child: const Text('Close'),
                                    )
                                  ],
                                ),
                              );
                            },
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Time slots
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: List.generate(timeSlots.length, (index) {
                          return _buildTimeSlot(timeSlots[index], index == selectedTimeIndex, index);
                        }),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Date section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Date slots
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: List.generate(dateSlots.length, (index) {
                          return _buildDateSlot(dateSlots[index], index == selectedDateIndex, index);
                        }),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Book button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: BlocConsumer<ReservationCubit, ReservationState>(
                        bloc: _reservationCubit,
                        listener: (context, state) {
                          if (state is ReservationSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Appointment booked successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else if (state is ReservationError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to book appointment: ${state.message}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          return Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: state is ReservationLoading
                                  ? null
                                  : () async {
                                      final selectedTime = timeSlots[selectedTimeIndex];
                                      final selectedDay = dateSlots[selectedDateIndex];
                                      
                                      // Parse the selected date and time
                                      final dateParts = selectedDay.split(' ');
                                      final timeParts = selectedTime.split(' ');
                                      final hour = int.parse(timeParts[0].split('.')[0]);
                                      final minute = int.parse(timeParts[0].split('.')[1]);
                                      final isPM = timeParts[1] == 'PM';
                                      
                                      final reservationDate = DateTime(
                                        selectedDate.year,
                                        selectedDate.month,
                                        selectedDate.day,
                                        isPM ? hour + 12 : hour,
                                        minute,
                                      );

                                      _reservationCubit.makeReservation(
                                        patientID: await CachedData.getData(Constant.id), // Replace with actual patient ID
                                        doctorID: widget.doctorId,
                                        reservationDate: reservationDate,
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: state is ReservationLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      'Book an Appointment',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('No doctor information available'));
          },
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
